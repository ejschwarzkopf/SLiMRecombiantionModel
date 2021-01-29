#!/bin/bash
#SBATCH --job-name=LDhatParam
#SBATCH --partition=popgenom,kamiak,cas,cahnrs
#SBATCH --output=/data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel/1.scripts/1.log/LDhatParam.out
#SBATCH --error=/data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel/1.scripts/1.log/LDhatParam.err
#SBATCH --time=7-00:00:00
#SBATCH --nodes=1
#SBATCH --workdir="/data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel"


module load r/4.0.2

Rscript --vanilla 1.scripts/LDhatParameterReduction.R 6.aux/SLiM_Parameters.txt 7.LDhat_summary/LDhat_case_ .summary.txt LDhat_