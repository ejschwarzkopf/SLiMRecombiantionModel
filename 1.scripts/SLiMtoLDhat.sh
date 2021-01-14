#!/bin/bash
#SBATCH --job-name=SLiMtoLDhat_CASE_NUM
#SBATCH --partition=popgenom,kamiak,cas,cahnrs
#SBATCH --output=/data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel/1.scripts/1.log/SLiMtoLDhat_CASE_NUM.out
#SBATCH --error=/data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel/1.scripts/1.log/SLiMtoLDhat_CASE_NUM.err
#SBATCH --time=7-00:00:00
#SBATCH --nodes=1
#SBATCH --array=1-500
#SBATCH --workdir="/data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel"

# Make the scripts:
# for i in `seq 1 900`; do sed 's/CASE_NUM/'${i}'/g' SLiMtoLDhat.sh > SLiMtoLDhat_Scripts/SLiMtoLDhat_case_${i}.sh; done

n=$SLURM_ARRAY_TASK_ID

i=CASE_NUM

file_path=$(lsworkspace -v | tail -n 4 | head -n 1)

mkdir ${file_path}/3.loc_site_files
mkdir ${file_path}/4.LDhat_output

mkdir ${file_path}/3.loc_site_files/case_${i}
mkdir ${file_path}/4.LDhat_output/case_${i}

cd ${file_path}/4.LDhat_output/case_${i}

grep -v ";MULTIALLELIC" ${file_path}/2.model_output/case_${i}/Test_Model_case${i}_${n}.vcf | tail -n+17 > ${file_path}/2.model_output/case_${i}/Test_Model_case${i}_${n}_LDhat.vcf

module load vcftools #version 0.1.16

vcftools --vcf ${file_path}/2.model_output/case_${i}/Test_Model_case${i}_${n}_LDhat.vcf --chr 1 --ldhat --phased --maf 0.01 --out ${file_path}/3.loc_site_files/case_${i}/SLiM_case_${i}_${n}

/home/e.jimenezschwarzkop/LDhat-master/interval -seq ${file_path}/3.loc_site_files/case_${i}/SLiM_case_${i}_${n}.ldhat.sites -loc ${file_path}/3.loc_site_files/case_${i}/SLiM_case_${i}_${n}.ldhat.locs -lk /home/e.jimenezschwarzkop/LDhat-master/lk_files/lk_n192_t0.001 -prefix ${file_path}/4.LDhat_output/case_${i}/SLiM_case_${i}_${n}. -its 10000000 -bpen 5 -samp 5000

#mv rates.txt ${file_path}/4.LDhat_output/case_${i}/SLiM_case_${i}_${n}.rates.txt
#mv bounds.txt ${file_path}/4.LDhat_output/case_${i}/SLiM_case_${i}_${n}.bounds.txt

/home/e.jimenezschwarzkop/LDhat-master/stat -input ${file_path}/4.LDhat_output/case_${i}/SLiM_case_${i}_${n}.rates.txt ${file_path}/4.LDhat_output/case_${i}/SLiM_case_${i}_${n}.bounds.txt -burn 1000 -loc ${file_path}/3.loc_site_files/case_${i}/SLiM_case_${i}_${n}.ldhat.locs -prefix ${file_path}/4.LDhat_output/case_${i}/SLiM_case_${i}_${n}.

#mv res.txt ${file_path}/4.LDhat_output/case_${i}/SLiM_case_${i}_${n}.res.txt


