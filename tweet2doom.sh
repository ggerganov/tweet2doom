#!/bin/bash

wd=$(dirname $0)
cd $wd
wd=$(pwd)

#node stream/stream.js &
#P1=$!
#
#./reply/service.sh &
#P2=$!
#
#./processor/service.sh &
#P3=$!
#
#wait $P1 $P2 $P3

trap 'kill %1; kill %2' SIGINT
node stream/stream.js & ./reply/service.sh & ./processor/service.sh
