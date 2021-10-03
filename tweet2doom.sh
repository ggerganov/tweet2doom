#!/bin/bash

wd=$(dirname $0)
cd $wd
wd=$(pwd)

trap 'kill %1; kill %2' SIGINT
node stream/stream.js & ./reply/service.sh & ./processor/service.sh
