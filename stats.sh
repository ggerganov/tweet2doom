#!/bin/bash

wd=$(dirname $0)
cd $wd
wd=$(pwd)

cd processed

max_depth=$(for i in `find -name *depth` ; do cat $i ; done | sort -n | tail -n 1)
max_frames=$(for i in `find -name *frames` ; do cat $i ; done | sort -n | tail -n 1)
num_tweets=$(ls -l | wc -l)
num_players=$(for i in `find -name *username` ; do cat $i ; echo ""; done | sort | uniq | wc -l)

echo "Max depth:   $max_depth"
echo "Max frames:  $max_frames"
echo "Num tweets:  $num_tweets"
echo "Num players: $num_players"
