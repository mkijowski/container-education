# Purpose
The purpose of this repository is to gather information useful to someone who is new to HPC systems running a container technology.  In order to support a rapidly changing computational environment we have adopted the use of singularity
containers.  In this repository you will find guides that introduce our chosen container solution 
[Singularity](https://singularity.lbl.gov/) 
and our chosen job scheduler [Slurm Workload Manager](https://slurm.schedmd.com/).  By using both of these tools
we allow students and researchers to develop a container environment locally (on their laptop or PC) and enable them to move 
the container and job script around to different compute resources without needing to re-install software or 
libraries.  

## How to use this guide
To get the most of these materials you need to have a basic understanding of linux and knowledge of the 
computational problem you are trying to solve.  To better outline how to use this guide I will first layout the
expected workflow a user should use:
1. Install Singularity on your local system
   * [linux  install instructions](https://singularity.lbl.gov/install-linux)
   * [mac install instructions](https://singularity.lbl.gov/install-mac)
   * windows users should install virtual box and a linux VM, then follow the above linux instructions
2. Build your Singularity container (use `sudo singularity build --sandbox /my/container/directory/ buildfile` so that you can make changes to it)
   * Make changes to your Singularity container by launching a writable shell inside of it 
   `sudo singularity shell --writable /my/container/directory/`
   * Test your container using `singularity exec /my/container/directory/ command options`
   * Convert your sandbox container directory to a read-only container file (static image or .simg) BEFORE transferring(sftp/scp) it with 
   `sudo singularity build my-container.simg /my/container/directory/`
3. Once you have a working container `.simg` you need to create a slurm job submission script `.sbatch` for the desired compute resource
4. Upload your `.simg` container, your `.sbatch` file, and your code/data to the compute resrouce you are using
5. Submit your job using `sbatch my-file.sbatch`

In order to support the above workflow we have divided this repository into two parts, one for singularity and 
one for slurm.  In each you will find a README.md that contains a quick start to the technology as well as example
scripts that will be usefull for you to base your work off of.
