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
regular=$(echo "$updates" | cut -d ";" -f 1)

if [ $security != "0" ]
then
	# Generate some output which will be piped to cron
	summary=$(/usr/lib/update-notifier/apt-check --human-readable)
	middle=$'\n\n'"Packages pending upgrade:"$'\n'
	details=$((/usr/lib/update-notifier/apt-check --package-names) 2>&1)
	message="$summary$middle$details"
	echo "$message" | mail -s "$(hostname -s) $security security updates ($regular updates)" $(whoami)
fi
