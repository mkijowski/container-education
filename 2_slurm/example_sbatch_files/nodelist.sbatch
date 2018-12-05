#!/bin/bash -l

#SBATCH -N 1
#SBATCH --job-name=myjob
#SBATCH --output=/home/%u/%x-%u-%j.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=matthewkijowski@gmail.com

# Create nodelist file
export NODELIST=nodelist.$$
srun -l bash -c 'hostname' | sort | awk '{print $2}' > $NODELIST
cat $NODELIST

# Set license path
export CDLMD_LICENSE_FILE=1999@starccmlm.cs.wright.edu

# Begin Execution
singularity exec \
    -B /home/cknapke:/home/cknapke \
    /data/singularity/starccm.simg \
    /opt/CD-adapco/12.06.010-R8/STAR-CCM+12.06.010-R8/star/bin/starccm+ \
    -power \
    -rsh /home/mkijowski/ssh_wrapper \
    -machinefile $NODELIST \
    -np $((8*$SLURM_JOB_NUM_NODES)) \
    -batch run \
    -load /home/cknapke/b_125Len_125Dep_2Asp_11a.sim 

