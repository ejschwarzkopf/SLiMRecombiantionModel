#!/bin/bash
#SBATCH --job-name=SLiMjobs
#SBATCH --partition=popgenom,kamiak,cas,cahnrs
#SBATCH --output=/data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel/1.scripts/1.log/SLiMjobs.out
#SBATCH --error=/data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel/1.scripts/1.log/SLiMjobs.err
#SBATCH --time=7-00:00:00
#SBATCH --nodes=1
#SBATCH --workdir="/data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel/1.scripts/SLiM_Model_Scripts/"

for i in `seq 401  500`;
do
	sbatch SLiM_Model_case${i}.sh
	echo $i
	sleep 300
	if [ $(($i % 100)) -eq 0 ]; then
	sleep 10800 
	fi
done
