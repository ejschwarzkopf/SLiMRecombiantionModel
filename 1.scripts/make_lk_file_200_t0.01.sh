#!/bin/bash
#SBATCH --job-name=lk_file
#SBATCH --partition=popgenom
#SBATCH --output=/data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel/1.scripts/1.log/lk_file.out
#SBATCH --error=/data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel/1.scripts/1.log/lk_file.err
#SBATCH --time=14-00:00:00
#SBATCH --nodes=1
#SBATCH --workdir="/data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel"

/home/e.jimenezschwarzkop/LDhat-master/complete -n 200 -rhomax 100 -n_pts 101 -theta 0.01

mv new_lk.txt /home/e.jimenezschwarzkop/LDhat-master/lk_files/lk_n200_t0.01
