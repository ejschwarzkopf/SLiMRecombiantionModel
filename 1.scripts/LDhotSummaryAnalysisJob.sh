#!/bin/bash
#SBATCH --job-name=LDhotAnalysis
#SBATCH --partition=popgenom,kamiak,cas,cahnrs
#SBATCH --output=/data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel/1.scripts/1.log/LDhotAnalysis.out
#SBATCH --error=/data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel/1.scripts/1.log/LDhotAnalysis.err
#SBATCH --time=7-00:00:00
#SBATCH --nodes=1
#SBATCH --workdir="/data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel"

n=$SLURM_ARRAY_TASK_ID

module load r/4.0.2

Rscript --vanilla 1.scripts/LDhotOutputAnalysis.R /data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel/8.LDhot_summary/LDhot_case_ 900
