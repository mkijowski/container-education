#!/bin/bash
#
#SBATCH --job-name=test_cuda
#SBATCH --output /home/mkijowski/output/%j.%N.out
#
#SBATCH --nodes=2
#SBATCH --ntasks=2
#SBATCH --time=5:00
#SBATCH --mem-per-cpu=1000

#SBATCH --gres=gpu:2

srun singularity exec --nv \
    /home/mkijowski/cuda.img \
    /home/mkijowski/samples-nvidia/1_Utilities/deviceQuery/deviceQuery
