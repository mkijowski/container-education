#!/bin/bash
#
#SBATCH --job-name=test
#SBATCH --output=/home/%u/%x-%u-%j.out
#SBATCH -N 2
#SBATCH --time=30:00
#SBATCH --mem-per-cpu=257669

# Create nodelist file
export NODELIST=nodelist.$$
srun -l bash -c 'hostname' | sort | awk '{print $2}' > $NODELIST
cat $NODELIST

# Use an ssh wrapper to make sure singularity is executed when remotely starting jobs
## Note: this has not been fully tested for ansys yet!
SSHWRAPPER=~/ssh-wrapper.sh

# might need the following options for fluent in the future:
#       -cnf=$NODELIST \
#	-rsh=$SSHWRAPPER


srun /usr/local/bin/singularity exec ~/ansys.sif \
	/usr/ansys_inc/v194/fluent/bin/fluent 3ddp \
	-g \
	-t16 \
	-i ~/fluentfile 
