#!/bin/bash
#SBATCH --job-name=ParameterRun1
#SBATCH --partition=popgenom,kamiak,cas,cahnrs
#SBATCH --output=/data/cornejo/projects/e.jimenezschwarzkop/LDModel/1.scripts/1.log/ParameterRun1.out
#SBATCH --error=/data/cornejo/projects/e.jimenezschwarzkop/LDModel/1.scripts/1.log/ParameterRun1.err
#SBATCH --time=7-00:00:00
#SBATCH --nodes=1
#SBATCH --workdir="/data/cornejo/projects/e.jimenezschwarzkop/LDModel"
#SBATCH --array=1-1000

i=$SLURM_ARRAY_TASK_ID

/data/cornejo/projects/SLiM/slim SLiMscript -s $i --flags > 2.SLiM_output/ModelName_$i

# Extract the flags from a file with all parameter combinations
# Possible flags:
# N: population size, default 10000
# POS_1: location of the first mutation, default 1e4
# POS_2: location of the second mutation, default 1e4+1e3
# HI_1: upper bound for the first mutation, default 0.01
# HI_2: upper bound for the second mutation, default 0.01
# AMPLITUDE_1: height of the sine wave for the first mutation, default calculated from HI_1
# AMPLITUDE_2: height of the sine wave for the second mutation, default calculated from HI_2
# ORD_FREQUENCY_1: number of generations that a cycle of the sine wave takes for the first mutation, default 1/3
# ORD_FREQUENCY_2: number of generations that a cycle of the sine wave takes for the second mutation, default 1/3
# PHASE_1: the value of the sine wave at time zero for the first generation, default 0
# PHASE_2: the value of the sine wave at time zero for the second generation, default 0.6
# STARTFREQ_1: starting frequency of the first mutation, default N (half of the chromosomes)
# STARTFREQ_2: starting frequency of the second mutation, default N (half of the chromosomes)


