#!/bin/bash
#
#SBATCH --job-name=test_cuda
#SBATCH --output=/home/%u/%x-%u-%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --time=5:00
#SBATCH --mem-per-cpu=1000

#SBATCH --gres=gpu:1

srun singularity exec --nv \
    /home/mkijowski/cuda.img \
    /home/mkijowski/samples-nvidia/1_Utilities/deviceQuery/deviceQuery
