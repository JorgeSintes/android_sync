#!/bin/bash
# Checks the offset between phone's and computer's clock every second.

while true
do
	phone_time=$(adb shell "su -c '/data/data/com.termux/files/home/time/get_time'")
	current_time=$(date +"%s.%6N")
	diff=$(echo $phone_time-$current_time | bc)

	echo "[$(date -d @$current_time)] Offset: $diff"
	echo "[$(date -d @$current_time)] Offset: $diff" >> log
	sleep 1
done
