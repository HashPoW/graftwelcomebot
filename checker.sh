#!/bin/bash
dir=$(pwd)
while sleep 3600
do
 pkill -f bin/checker
 ruby $dir/bin/checker >> $dir/logs/checker 2>&1 &!
done

