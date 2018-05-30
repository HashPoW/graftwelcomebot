#!/bin/bash
dir=$(pwd)
while sleep 60
do
if pgrep -f bin/bot >/dev/null
then
	echo "works" 
else
 ruby $dir/bin/bot>>$dir/logs/bot.log 2>&1
fi
done
