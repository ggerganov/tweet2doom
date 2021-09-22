#!/bin/bash

pid=$(pgrep -f tweet2doom.sh)
if [ ! -z $pid ] ; then
    echo "Killing $pid ..."
    kill -- -$pid
fi
