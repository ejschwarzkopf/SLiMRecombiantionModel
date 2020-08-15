#!/bin/bash

for i in `seq 801 900`;
do
	sbatch SLiM_Model_case${i}.sh
	sleep 180
done
