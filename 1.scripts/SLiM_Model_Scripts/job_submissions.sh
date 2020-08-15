#!/bin/bash

for i in `seq 1 900`;
do
	sbatch SLiM_Model_case${i}.sh
	echo $i
	sleep 180
	if [ $(($i % 100)) -eq 0 ]; then
		sleep 10800
	fi
done
