#!/bin/bash
#SBATCH --job-name=SLiMtoLDhat
#SBATCH --partition=popgenom,kamiak,cas,cahnrs
#SBATCH --output=/data/cornejo/projects/e.jimenezschwarzkop/LDModel/1.scripts/1.log/SLiMtoLDhat.out
#SBATCH --error=/data/cornejo/projects/e.jimenezschwarzkop/LDModel/1.scripts/1.log/SLiMtoLDhat.err
#SBATCH --time=7-00:00:00
#SBATCH --nodes=1
#SBATCH --workdir="/data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel"

grep -v ";MULTIALLELIC" SLiMoutput > SLiMtoLDhat

vcftools --vcf SLiMtoLDhat --chr 1 --ldhat --phased --maf 0.01 --out LDhatfile

/home/e.jimenezschwarzkop/LDhat-master/interval -seq LDhatfile.sites -loc LDhatfile.locs -lk /home/e.jimenezschwarzkop/LDhat-master/lk_files/lk_n200_t0.01


