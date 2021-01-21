#!/bin/bash
#SBATCH --job-name=LDhotSummary
#SBATCH --partition=popgenom,kamiak,cas,cahnrs
#SBATCH --output=/data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel/1.scripts/1.log/LDhotSummary.out
#SBATCH --error=/data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel/1.scripts/1.log/LDhotSummary.err
#SBATCH --time=7-00:00:00
#SBATCH --nodes=1
#SBATCH --workdir="/data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel"
#SBATCH --array=1-36

i=$SLURM_ARRAY_TASK_ID

n=$(awk 'FNR == '$i' {print}' tmp2.txt)

module load r/4.0.2

filepath=$(lsworkspace -v | tail -n 4 | head -n 1)

filetemplate=$(echo ${filepath}/5.LDhot_output/case_${n}/SLiM_case_${n}_)

Rscript --vanilla 1.scripts/LDhotOutputAnalysis.R ${filetemplate} 500

