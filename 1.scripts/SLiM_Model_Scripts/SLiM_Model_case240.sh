#!/bin/bash
#SBATCH --job-name=SLiMRun1
#SBATCH --partition=popgenom,kamiak,cas,cahnrs
#SBATCH --output=/data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel/1.scripts/1.log/SLiMRun240_%a.out
#SBATCH --error=/data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel/1.scripts/1.log/SLiMRun240_%a.err
#SBATCH --time=7-00:00:00
#SBATCH --nodes=1
#SBATCH --workdir="/data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel"
#SBATCH --array=1-500

n=$SLURM_ARRAY_TASK_ID

i=$((240+1))

directory=$(echo '/scratch/'$(lsworkspace -v | awk 'NR==1 {print}')'/2.model_output')

if [ $n -eq 1 ]
then
	mkdir $directory/case_240
fi

seed=$((($n-1)*500+240))

# Input file is tab delimited in the following format:
# N	POS_1	POS_2	HI_1	HI_2	ORD_FREQUENCY_1	ORD_FREQUENCY_2	PHASE_1	PHASE_2	STARTFREQ_1	STARTFREQ_2 R

N=$(awk 'NR=='$i' {print}' 6.aux/SLiM_Parameters.txt | cut -f 1) 
POS_1=$(awk 'NR=='$i' {print}' 6.aux/SLiM_Parameters.txt | cut -f 2)
POS_2=$(awk 'NR=='$i' {print}' 6.aux/SLiM_Parameters.txt | cut -f 3)
HI_1=$(awk 'NR=='$i' {print}' 6.aux/SLiM_Parameters.txt | cut -f 4)
HI_2=$(awk 'NR=='$i' {print}' 6.aux/SLiM_Parameters.txt | cut -f 5)
ORD_FREQUENCY_1=$(awk 'NR=='$i' {print}' 6.aux/SLiM_Parameters.txt | cut -f 6)
ORD_FREQUENCY_2=$(awk 'NR=='$i' {print}' 6.aux/SLiM_Parameters.txt | cut -f 7)
PHASE_1=$(awk 'NR=='$i' {print}' 6.aux/SLiM_Parameters.txt | cut -f 8)
PHASE_2=$(awk 'NR=='$i' {print}' 6.aux/SLiM_Parameters.txt | cut -f 9)
STARTFREQ_1=$(awk 'NR=='$i' {print}' 6.aux/SLiM_Parameters.txt | cut -f 10)
STARTFREQ_2=$(awk 'NR=='$i' {print}' 6.aux/SLiM_Parameters.txt | cut -f 11)
R=$(awk 'NR=='$i' {print}' 6.aux/SLiM_Parameters.txt | cut -f 12)

/data/cornejo/projects/SLiM/slim -s $seed -d N=$N -d POS_1=$POS_1 -d POS_2=$POS_2 -d HI_1=$HI_1 -d HI_2=$HI_2 -d ORD_FREQUENCY_1=$ORD_FREQUENCY_1 -d ORD_FREQUENCY_2=$ORD_FREQUENCY_2 -d PHASE_1=$PHASE_1 -d PHASE_2=$PHASE_2 -d STARTFREQ_1=$N -d STARTFREQ_2=$N -d R=$R 1.scripts/FluctuatingSelection_TwoLocus_SineWave.slim  > 2.model_output/Test_Model_case240_${n}.vcf

directory=$(echo '/scratch/'$(lsworkspace -v | awk 'NR==1 {print}')'/2.model_output')

mv 2.model_output/Test_Model_case240_${n}.vcf "${directory}/case_240/"

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


