#!/bin/bash
while sleep 3600
do
 pkill -f bin/autoposter_sender
 ruby /root/telegram_autoposter/bin/autoposter_sender >> /root/telegram_autoposter/logs/sender 2>&1 &!
done

