#!/bin/bash
# This script updates the scratch folder (ideally before it expires)
# This script does not work when more than one scratch folder exists 

dummy=$(echo 'test')

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
