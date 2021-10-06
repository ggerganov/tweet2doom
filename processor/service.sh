#!/bin/bash

wd=$(dirname $0)
cd $wd/../
wd=$(pwd)

dir_requests="./requests"
dir_processing="./processing"
dir_pending="./pending"
dir_invalid="./invalid"
dir_nodes="./nodes"
dir_doomreplay="$wd/doomreplay"

while true ; do
    sleep 3

    id=$(./request-one.sh | grep __REQUEST__ | awk '{print $2}')

    if [ -z $id ] ; then
        continue;
    fi

    echo "processing request $id ..."

    cd $dir_processing/$id

    result=0

    cat ./payload.json | jq -r .data.text > cmd.txt || result=$?

    if [ ! "$result" -eq 0 ] ; then
        echo "Missing '.data.text' field in the request" > error
        cd $wd
        #mv -v $dir_processing/$id $dir_invalid/
        mv -v $dir_processing/$id $dir_pending/
        continue
    fi

    parent_id=$(cat parent_id)
    if [ ! -d $wd/$dir_nodes/$parent_id ] ; then
        echo "Unknown parent_id" > error
        cd $wd
        #mv -v $dir_processing/$id $dir_invalid/
        mv -v $dir_processing/$id $dir_pending/
        continue
    fi

    echo "parent_id=$parent_id"

    $wd/parse-tweet cmd.txt "/play" input-cur.txt frames || result=$?

    if [ ! "$result" -eq 0 ] ; then
        echo "Failed to parse the command" > error
        if [ "$result" -eq 2 ] ; then
            echo "Missing slash command" >> error
        fi
        if [ "$result" -eq 3 ] ; then
            echo "Empty command" >> error
        fi
        if [ "$result" -eq 4 ] ; then
            echo "Invalid token - too many dashes" >> error
        fi
        if [ "$result" -eq 5 ] ; then
            echo "Invalid token - max repeat is 99" >> error
        fi
        if [ "$result" -eq 6 ] ; then
            echo "Minimum number of new frames is 18" >> error
        fi
        if [ "$result" -eq 7 ] ; then
            echo "Empty command" >> error
        fi

        cd $wd
        #mv -v $dir_processing/$id $dir_invalid/
        mv -v $dir_processing/$id $dir_pending/
        continue
    fi

    depth_old=$(cat $wd/$dir_nodes/$parent_id/depth | awk '{print $1}')
    frames_old=$(cat $wd/$dir_nodes/$parent_id/frames | awk '{print $1}')

    echo $(($depth_old + 1)) > depth
    frames_cur=$(cat frames | awk '{print $1}')
    echo $frames_cur > frames_cur
    echo $(($frames_old + $frames_cur)) > frames

    username=$(cat username)
    cat $wd/$dir_nodes/$parent_id/history.txt > input-all.txt
    echo -n ",#@$username#" >> input-all.txt
    cat input-cur.txt >> input-all.txt

    ln -sf $dir_doomreplay/.savegame .savegame
    $dir_doomreplay/doomgeneric \
        -iwad $dir_doomreplay/doom1.wad \
        -input input-all.txt \
        -output record.mp4 \
        -nrecord 350 \
        -nfreeze 18 \
        -render_frame \
        -render_input \
        -render_username || result=$?

    if [ ! "$result" -eq 0 ] ; then
        echo "Failed to generate the video" > error
        cd $wd
        #mv -v $dir_processing/$id $dir_invalid/
        mv -v $dir_processing/$id $dir_pending/
        continue
    fi

    cd $wd

    mv -v $dir_processing/$id $dir_pending/
done
