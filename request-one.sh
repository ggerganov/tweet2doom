#!/bin/bash

dir_lock="./tmp/requests.lock"
dir_requests="./requests"
dir_processing="./processing"

if mkdir $dir_lock ; then
    echo "Start processing a request"

    id=$(ls -t $dir_requests | tail -n 1)
    if [ -z $id ] ; then
        echo "No available tasks"
    else
        mv -v $dir_requests/$id $dir_processing/$id
        ts=$(date +%s)
        echo $ts > $dir_processing/$id/started.time
        echo "__REQUEST__ $id"
    fi

    if rmdir $dir_lock ; then
        :
    else
        echo "Cannot remove lock - should never happen" >&2
        exit 43
    fi
else
    echo "Processing another request. Please try again"
    exit 42
fi

exit 0
