#!/bin/bash
#
#SBATCH --job-name=test
#SBATCH --output=/home/%u/%x-%u-%j.out
#SBATCH --ntasks=1
#SBATCH --time=10:00
#SBATCH --mem-per-cpu=100

srun hostname
srun sleep 60

