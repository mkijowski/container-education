# Purpose
The purpose of this repository is to gather information useful to someone who is new to the HPC systems available 
at Wright State.  In order to support a rapidly changing computational environment we have adopted the use of 
containers.  In this repository you will find guides that introduce our chosen container solution 
[Singularity](https://singularity.lbl.gov/) 
and our chosen job scheduler [Slurm Workload Manager](https://slurm.schedmd.com/).  By using both of these tools
we allow students and researchers to develop a container environment locally to them and enable them to move 
the container and job script around to different compute resources without needing to re-install software or 
libraries.  

## How to use this guide
To get the most of these materials you need to have a basic understanding of linux and knowledge of the 
computational problem you are trying to solve.  To betteroutline how to use this guide I will first layout the
expected workflow a user should use:
1. Get access to a linux system and install Singularity [linux instructions](https://singularity.lbl.gov/install-linux), [mac instructions](https://singularity.lbl.gov/install-mac)
2. Build your Singularity container (use `singularity build --sandbox` so that you can make changes to it)
   * Make changes to your Singularity container by launching a writable shell inside of it `sudo singularity shell --writable my-container/`
   * Test your container using `singularity exec command options`
   * Convert your container to a static image before transferring it with `singularity build my-container.simg my-container/`
3. Once you have a working container `my-container.simg` you need to create a job submission script for slurm (check out the 2_slurm folder for more details.


