#!/bin/sh

tail -F /var/log/system.log | while read line; do
  if echo "$line" | grep -q '.*wacom.*'; then
   	kill $(pidof PenTabletDriver)
	sleep 1
	open /Library/Application\ Support/Tablet/PenTabletDriver.app
  fi
done
