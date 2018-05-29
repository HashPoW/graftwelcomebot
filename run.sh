#!/bin/bash
while sleep 60
do
if pgrep -f bin/autoposter_bot >/dev/null
then
	echo "works" 
else
 ruby /root/telegram_autoposter/bin/autoposter_bot>>/root/telegram_autoposter/logs/bot.log 2>&1
fi
done
