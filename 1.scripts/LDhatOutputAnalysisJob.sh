#!/bin/bash
#SBATCH --job-name=LDhatSummary
#SBATCH --partition=popgenom,kamiak,cas,cahnrs
#SBATCH --output=/data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel/1.scripts/1.log/LDhatSummary.out
#SBATCH --error=/data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel/1.scripts/1.log/LDhatSummary.err
#SBATCH --time=7-00:00:00
#SBATCH --nodes=1
#SBATCH --workdir="/data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel"
#SBATCH --array=1-900

n=$SLURM_ARRAY_TASK_ID

module load r/4.0.2

filepath=$(lsworkspace -v | tail -n 4 | head -n 1)

filetemplate=$(echo ${filepath}/4.LDhat_output/case_${n}/SLiM_case_${n}_)

Rscript --vanilla 1.scripts/LDhatOutputAnalysis.R ${filetemplate} 500

if [ $n -eq 900 ]; then
	for i in `seq 1 900`; do
		cp ${filepath}/4.LDhat_output/case_${i}/SLiM_case_${i}_.res.summary.txt 7.LDhat_summary/LDhat_case_${i}.summary.txt
	done
fi
