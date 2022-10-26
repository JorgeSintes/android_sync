#!/bin/bash
# Program for synchronizing a phone's clock to a computer. Needs to have set_time.c and get_time.c compiled on the phone.
# It calculates the offset of writing and getting the time on the phone doing several trials (5 by default) and then 
# writes the time compensating it (assuming that get_time is negligible against set_time).

n=${1:-5}
echo "Synchronizing! Estimating offset with $n iterations"
echo "Synchronizing! Estimating offset with $n iterations" >> log

path="/data/data/com.termux/files/home/time" # path to set_time and get_time executables in the phone
offset=0 # Variable that will store the running avg of the offset
num_accepted=0

while [ $num_accepted -lt $n ]
do
    # Writing and reading the current time
    current_time=$(date +"%s.%6N")
    adb shell "su -c '$path/set_time $current_time'"
    phone_time=$(adb shell "su -c '$path/get_time'")
    current_time=$(date +"%s.%6N")
    # Calculate difference
    diff=$(echo $phone_time-$current_time | bc)

    # Only accept negative diffs. Sometimes adb takes longer to read the time from the phone and returns a great positive diff, which makes no sense
    if (( $(echo "$diff < 0" | bc -l) )); then 
        offset=$(echo "($num_accepted * $offset + $diff)/($num_accepted+1)"| bc -l)
        num_accepted=$(($num_accepted+1))
        # Print out
        echo "[$(date -d @$current_time)] It. $num_accepted. Offset: $diff. Running avg: $offset"
        echo "[$(date -d @$current_time)] It. $num_accepted. Offset: $diff. Running avg: $offset" >> log
    fi
    sleep 1
done

# Write compensating the offset
current_time=$(date +"%s.%6N")
offseted_time=$(echo "$current_time - $offset" | bc)
adb shell "su -c '$path/set_time $offseted_time'"
echo "[$(date -d @$current_time)] Synced!" 
echo "[$(date -d @$current_time)] Synced!" >> log

./check_time_reset.sh