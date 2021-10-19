#!/bin/bash

wd=$(dirname $0)
cd $wd
wd=$(pwd)

cd $wd/stream
rm -rf node_modules
npm install

cd $wd/reply
rm -rf node_modules
npm install

cd $wd/post
rm -rf node_modules
npm install

cd $wd
g++ -std=c++11 -O3 parse-tweet.cpp -o parse-tweet
g++ -std=c++11 -O3 parse-history.cpp -o parse-history

cd $wd
ln -sfnv ../doomreplay/doomgeneric ./doomreplay
