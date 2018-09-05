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
* Build your Singularity container (use `sudo singularity build --sandbox /my/container/directory/ buildfile` so that you can make changes to it)
* Make changes to your Singularity container by launching a writable shell inside of it  
`sudo singularity shell --writable /my/container/directory/`
* Test your container using `singularity exec /my/container/directory/ command options`
* Convert your sandbox container directory to a read-only container file (static image or .simg) BEFORE transferring(sftp/scp) it with 
   `sudo singularity build my-container.simg /my/container/directory/`

### [Building singularity containers](https://singularity.lbl.gov/docs-build-container) with `singularity build`
The `singularity build` command is used to create singularity containers.  With it you specfy the output container image and a target input to build the contianer from.

```
singularity build output-image target-input
```

The `output-image` can produce containers in three different formats:
* `my-container.simg` compressed, read-only, squashfs files system suitable for production (default)
* ` --sandbox /my/container/directory/` writable chroot directory called a sandbox for interactive development (`--sandbox` option **GOOD**)
* it is possible to make a writable ext3 file system for interactive development **BUT** because this file system gets created with a fixed size it is not useful when attempting to create containers unless you now exactly how big your final container image will be from the beginning.

The `target-input` is what specifies what will go into the container and can be one of the following:
* URI beginning with `shub://` to build from Singularity Hub
* URI beginning with `docker://` to build from Docker Hub
* path to an existing container (`.img` or `.simg`)
* path to a directory of a sandbox container (an existing container built with `--sandbox`)
* path to an archive in `.tar` or `.tar.gz`
* path to a singularity recipe file


Example `singularity build` commands:
```
sudo singularity build MatlabCompiledRuntime18.simg MCR18a.build
## Builds from a recipe file named `MCR18a.build` that must be available locally.

sudo singularity build --sandbox /home/mkijowski/cuda91/ docker://nvidia/cuda:9.1-cudnn7-devel-ubuntu16.04
## Builds a sandbox container directly from a dockerhub container

sudo singularity build cuda91.simg /home/mkijowski/cuda91/
## Converts a previoulsy created sandbox container to a static .simg containter
```

### Using / editing containers with `singularity shell` 
The `sudo singularity shell --writable /my/container/directory/` launches a shell inside the container from which we can continue our software installation and testing.  Note: the `--writable` flag requires sudo priveleges, without `--writable` the container would be read only (even though it is a `--sandbox` container.

Once you are finished installing and testing your software, do not forget to convert your `--sandbox` container back to a `.simg` with 
`sudo singularity build my-container.simg /my/container/directory/`

### Advacned Singularity topics
### [Singularity recipes](http://singularity.lbl.gov/docs-recipes)
A singularity recipe is a text file that defines a custom container build.  Instead of going into all of the ins nad outs of singularity recipes, refer to the document above and experimetn on our own.  In this directory are several exmaples of singularity recipes.  

### Binding with `-B`
By default the only directory shared between the host and container is /home/$USER.  This means other user's home directories are not accessible from within the container (nor are other useful directories like /scratch).
To remedy this you can specufy bind paths with the `--bind` or `-B` option.  
The format for bind baths is as follows:
```
singularity shell -B src:dest cuda.simg
```
Where `src` is a path on the host and `dest` is a path within the container.  If no `dest` path is provided it will use the same path as `src` inside the container.

### Nvidia GPU support (CUDA)
Singularity containers support direct access to a local GPU only when given the `--nv` flag.
```
singularity shell --nv cuda.simg
```
This does more than just allow access to the GPU, it also binds a number of specified nvidia and cuda libraries into the container in the following directory:
```
/.singularity.d/lib/
```
Note: this path may need to be added to your defualt paths for cuda to work (in ubuntu you can copy the `singularity-nvidia.conf` file in this git repository to `/etc/ld.so.conf.d/singularity-nvidia.conf`.  You may need to reload the container for this to take effect.


