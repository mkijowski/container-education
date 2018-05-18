# Slurm Quick Start
This guide was [templated from here,](https://support.ceci-hpc.be/doc/_contents/QuickStart/SubmittingJobs/SlurmTutorial.html) which goes into more detail regarding many of these commands.
Another greate resource is the [Slurm Quick Start User Guide](https://slurm.schedmd.com/quickstart.html) which has links to other good slurm documentation.

Resource sharing on a High Performance Computer (HPC) system is typically organized by a pieve of software called a resource manager or job scheduler.  Users submit jobs which are scheduled and allocated resources (CPU cores, GPU, RAM, time, etc.) by the resource manager.

[Slurm](https://slurm.schedmd.com/) is the scheduler that we are using here at Wright State.  In this document we will cover the basics of interacting with slurm in order to figure out what resources are available and to submit jobs for computation on a cluster.

## Gathering information
The first two slurm commands that are arguably the most important are `sinfo` and `squeue`.
The `sinfo` command displays information about nodes and partitions available to you.  To find out more about the command run `man sinfo` on the atrc-data system to displa the manual.
Two useful options for displaying information on atrc-data are `sinfo -lN` which prints out more information about the cluster (`-l` option) and displays information o na per node format (`-N` option).  The current output of the above when run on the local atrc-data cluster is as follows:

```
NODELIST   NODES PARTITION       STATE CPUS    S:C:T MEMORY TMP_DISK WEIGHT AVAIL_FE REASON              
work01         1    debug*        idle   16    1:8:2 120000        0      1   (null) none                
work02         1    debug*        idle   16    1:8:2 120000        0      1   (null) none                
work03         1    debug*        idle   12    1:6:2  30000        0      1   (null) none                
work04         1    debug*        idle    8    1:4:2  30000        0      1   (null) none                
work05         1    debug*        idle   12    1:6:2  30000        0      1   (null) none                
work06         1    debug*        idle   16    1:8:2 120000        0      1   (null) none                
work07         1    debug*        idle    8    1:4:2  15000        0      1   (null) none 
```

And here is the output without the `-lN` options passed:

```
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
debug*       up   infinite      7   idle work[01-07]
```

The `squeue` command shows the list of jobs that are either currently running (in the RUNNING state, noted as 'R') or jobs that are waiting for resources (in the PENDING state, noted as 'PD').

Below you can see the output of a `squeue` command after I have submitted a slurm job that was a simple wait command:
```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                61     debug    sleep mkijowsk  R       0:03      1 work04
```

If I wanted to cancel the above job I can reference it's JOBID using the `scancel` command like so `scancel 61`.  Another way I could cancel the job would be to use the `-u` option like so: `scancel -u mkijowski`.  This command would cancel ALL jobs that were submitted by user mkijowski.  Note: you can only cancel jobs that were submitted by your user.

## Creating a job
Jobs consists of two parts: **resource requests** and **job steps**.  A resource request consists of a number of CPU's, amount of memory, amount of time, etc.  Job steps describe what programs to run.

It is usually easiest to submit a job by writing a sumbission script.  Typically these scripts are submitted with the `sbatch` command.  These job submission scripts have a common format that begins with a list of `#SBATCH` options that are interpretted by the slurm scheduler as resource requests and other options, followed by a list of job steps that are executed swith the `srun` command.

Take for instance the below example submission script:
```
#!/bin/bash
#
#SBATCH --job-name=test
#SBATCH --output=res.txt
#
#SBATCH --ntasks=1
#SBATCH --time=10:00
#SBATCH --mem-per-cpu=100

srun hostname
srun sleep 60
```

It defines a job name as well as an output file for anything written out during this job (first two `#SBATCH` options), then it requests 1 CPU core along with 100MB of RAM for 10 minutes.  Becasue it is not specified this job will start in the default queue.
Now that al of the **resource requests** are out of the way we get to the **job steps**.  There are two additional **job steps** defined in the example job submision script above which will be run on the compute node that hold sthe CPU core that gets allocated.  First it will execute `hostname` on that host, the output of which will go to the file `res.txt`, then it will `sleep` for 1 minute.

Note, the `--ntasks` flag above requests CPU cores for tasks, but frequently a task cannot be split across several compute nodes, if you are running a multithreaded program that needs access to more than one core request this with the `--cpus-per-task` option.

## Using Slurm with containers
It actuallty is quite easy.  Assuming you have a container that is known to work with your code, simply insert `singularity exec /path/to/container` between your `srun` and command.  For example:
```
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
```
There is a good bit to note from the above script.  In order:
- note the new output format `--output /home/mkijowski/output/%j.%N.out`
  - This will automatically create output files that look like this: `jobid.nodename.out` which prevents you from needing to change the outpout filename since this is generated based on the jobid and nodename it will be different each time you submit thisscript
- `#SBATCH --nodes=2` requests two different compute nodes.
- `#SBATCH --ntasks=2` requests two tasks.  Note that even though I only have one srun command I need two tasks if I plan on executing the srun on both of the `--nodes` I have requested.
- `#SBATCH --gres=gpu:2` this line is totally new, but slurm supports scheduling of GPU resources through its Generic Resrouce (GRES) Scheduling
  - The gres request above states that the resrouce you are requesting is a GPU and that you are requesting two of them.  Note: this is similar to the `--ntasks` option in that `--gres=gpu:2` will only request nodes that have two GPUs in them.
- Finally we get to the task creation 
```
srun singularity exec --nv \
             /home/mkijowski/cuda.img \
             /home/mkijowski/samples-nvidia/1_Utilities/deviceQuery/deviceQuery
```
Some notes on the `\` character.  When the script is executed two things happen:
  1. `\` are ignored
  2. newlines after `\` are ignored
  3. in the case above the `\` characters are used to make the script easier to read for humans...

## More advanced Slurm submission scripts
### Embarrassingly parallel workloads (using `--array`)
Sometimes you just need to get a lot of things done without thinking about things like message passing (MPI).  Good examples of this include **random draws** (Monte-Carlo simulations where you plan to combine the output and post-process as another task), or if you are performing **parameter sweeps**, where the same code will be executed multiple times with an initial high-level parameter changed each time.

```
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
```

The above submission script will execute `my_program.exe` eight times, creating eight different jobs, and each execution will be passed a the variable **SLURM_ARRAY_TASK_ID** which will range from 1 to 8.

If you need numerical arguments that are not a simple integer sequence you could also do the following:

```
ARGS=(0.05 0.25 0.5 1 2 5 100 1000)

srun ./my_program.exe ${ARGS[$SLURM_ARRAY_TASK_ID]}
```


In the case where you want to process **several data files** as input you could use the following:

```
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

FILES=(/path/to/data/*)

srun singularity exec ./my_container.simg ./my_program.exe ${FILES[$SLURM_ARRAY_TASK_ID]}
```

### Packed jobs
Say you don't actually want to count and instead want to execute your program on files in a directory:

```
#! /bin/bash
#
#SBATCH --ntasks=8

for file in /path/to/data/*
do
   srun -n1 --exclusive singularity exec ./my_container.simg ./myprog $file &
done
wait
```

The above submission script will execute `myprog` for every file in `/path/to/data/` but will do so 8 at a time, using one cpu per task.

### Interactive jobs
Finally, although normally you want to script/automate the batch execution of jobs, someitmes you just need a terminal to test some things.  Instead of directly SSH-ing into a system that might have another users job submitted, you can request a bash terminal on a node using the following:
```
srun --gres=gpu:1 --pty bash
```
