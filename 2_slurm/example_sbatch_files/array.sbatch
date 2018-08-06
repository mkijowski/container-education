#!/bin/bash
#
#SBATCH --job-name=test_emb_arr
#SBATCH --output=res_emb_arr.txt
#
#SBATCH --ntasks=1
#SBATCH --time=10:00
#SBATCH --mem-per-cpu=100
#
#SBATCH --array=1-8

srun singularity exec mycontainer.simg ./my_program.exe $SLURM_ARRAY_TASK_ID

##  For non-integer array usage

ARGS=(0.05 0.25 0.5 1 2 5 100 1000)

srun singularity exec mycontainer.simg ./my_program.exe ${ARGS[$SLURM_ARRAY_TASK_ID]}
