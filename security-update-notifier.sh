#!/bin/bash

# Grab the pending updates like 4;2
updates=$(/usr/lib/update-notifier/apt-check 2>&1)

# If there are no pending updates, exit now
if [ $updates == "0;0" ]
then
	exit
fi

# Get the number of security updates (after the colon)
security=$(echo "$updates" | cut -d ";" -f 2)

if [ $security != "0" ]
then
	# Generate some output which will be piped to cron
	/usr/lib/update-notifier/apt-check --human-readable
	/usr/lib/update-notifier/apt-check --package-names
fi
