#!/bin/bash
# This script updates the scratch folder (ideally before it expires)
# This script does not work when more than one scratch folder exists 

# We define a current time and an ending time for the script in general

current_time=$(date +%s)
end_time=$(date -d '07/01/2021 20:00' +%s)


while [ $end_time -ge $current_time ]
do

	sleep_seconds=$(( 13*24*60*60 ))

	sleep $sleep_seconds

	# We chech if there is a current workspace in scratch
	condition=$(lsworkspace | wc -l)


	# If there is not folder, we make one. Else, we extract the location
	# of the folder and save it in the 'currentscratch' variable
	if [ $condition -eq 0 ]
	then
	        currentscratch=$(mkworkspace)
	else
	        currentscratch=$(lsworkspace -v | awk 'NR==1 {print}')
	        currentscratch=$(echo '/scratch/'$currentscratch)
	fi

	# We make a new scratch folder and save its location to 'newscratch.'

	newscratch=$(mkworkspace)

	# We move all the content from the current scratch folder to the
	# newly created scratch folder

	if [ $(ls ${currentscratch} | wc -l) -ne 0 ]
	then
		mv ${currentscratch}/* ${newscratch}
	fi

	# We remove the current scratch folder

	rmdir $currentscratch

	# We update the current scratch folder's name in the variable

	currentscratch=$(echo $newscratch)

	# We remove the 'newscratch' variable

	unset newscratch

	# We define current time again, to return to the start of the loop

	current_time=$(date +%s)

done

