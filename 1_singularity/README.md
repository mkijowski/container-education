# Singularity Quick-Start guide
This quide will get you working with singularity quickly.

##Installing Singularity (and other pre-requisites)
Please see the [Singularity Installation Guide](https://singularity.lbl.gov/docs-installation) for complete details on how to install Singularity.  Below is a brief walktrhough of a typical installtion.
```
sudo apt update
sudo apt install python \
    dh-autoreconf \
    build-essential \
    libarchive-dev \
    git
git clone https://github.com/singularityware/singularity.git
cd singularity
./autogen.sh
./configure --prefix=/usr/local --sysconfdir=/etc
make
sudo make install
```

[Mac installation instructions can be found here.](http://singularity.lbl.gov/install-mac)

## Using Singularity
The expected workflow for singularity is as follows:
* Build your Singularity container (use `singularity build --sandbox` so that you can make changes to it)
* Make changes to your Singularity container by launching a writable shell inside of it  
`sudo singularity shell --writable my-container/`
* Test your container using `singularity exec my-container/ command options`
* Convert your container to a static image BEFORE transferring(sftp/scp) it with 
`singularity build my-container.simg my-container/`

### [Building singularity containers](https://singularity.lbl.gov/docs-build-container) with `singularity build`
The `singularity build` command is used to create singularity containers.  With it you specfy the output container image and a target input to build the contianer from.

```
singularity build output-image target-input
```

The `output-image` can produce containers in three different formats:
* compressed, read-only, squashfs files system suitable for production (default)
* writable ext3 file system for interactive development (`--writable` option, **BAD**)
* writable chroot directory called a sandbox for interactive development (`--sandbox` option **GOOD**)

The `target-input` is what specifies what will go into the container and can be one of the following:
* URI beginning with `shub://` to build from Singularity Hub
* URI beginning with `docker://` to build from Docker Hub
* path to an existing container (`.img` or `.simg`)
* path to a directory of a sandbox container (an existing container built with `--sandbox`)
* path to an archive in `.tar` or `.tar.gz`
* path to a singularity recipe file

Why is the `--writable` flag bad and the `--sandbox` flag good?  Because `--writable` creates a fixed
size disk image file that is very difficult to grow.  Because `--sandbox` containers exist as folders 
they have no pre-configured upper size limit (besides your file system size).

Example `singularity build` commands:
```
sudo singularity build MatlabCompiledRuntime18.simg MCR18a.build
## Builds from a recipe file named `MCR18a.build` that must be available locally.

sudo singularity build --sandbox cuda91/ docker://nvidia/cuda:9.1-cudnn7-devel-ubuntu16.04
## Builds a sandbox container directly from a dockerhub container

sudo singularity build cuda91.simg cuda91/
## Converts a sandbox container to a static .simg containter
```

### Using / editing containers with `singularity shell` 
The `singularity shell my-container/` launches a shell inside the container.
* `singularity shell container.simg` launches a shell inside the container
* `singularity exec container.simg command` executes the command specified inside of the container (will be used in job scheduling scripts)

