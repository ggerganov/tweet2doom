#!/bin/bash

# parse child_id from all processed tweets
#
#  - writes "child_id" file in each processed folder
#  - writes "parent_id" file in each node folder

wd=$(dirname $0)
cd $wd/
wd=$(pwd)

dir_processed="./processed"
dir_nodes="./nodes"

for id in `ls $dir_processed` ; do
    child_id=$(cat $dir_processed/$id/result.json | jq -r .id_str)
    echo -n $child_id > $dir_processed/$id/child_id
    echo -n $id > $dir_nodes/$child_id/parent_id
    echo "$id -> $child_id"
done
