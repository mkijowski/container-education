# Singularity Quick-Start guide
This quide will get you working with singularity quickly.

* [Installing Singularity](#installing-singularity)
* [Building Singularity Containers](#building-singularity-containers-with-singularity-build)
* [Example Singularity build Workflow](#example-singularity-build-workflow)
* [Binding host directories into container](#binding-directories-with--b)
* [Using the GPU with --nv](#nvidia-gpu-support-cuda)

---

### Installing Singularity

Please see the [Singularity User Guide - Quick installation steps](https://docs.sylabs.io/guides/latest/user-guide/quick_start.html#quick-installation-steps) for complete details on how to install Singularity.  Below is a brief walktrhough of 3 typical installtions.

---

### [Building singularity containers](https://docs.sylabs.io/guides/latest/user-guide/build_a_container.html) with `singularity build`

The `singularity build` command is used to create singularity containers.  With it you specfy the output container image and a target input to build the contianer from.

```bash
singularity build <output-image> <target-input>
```

The `output-image` can produce containers in two different formats:
* `my-container.sif` compressed, *read-only*, squashfs files system suitable for production (default)
* `--sandbox </my/container/directory/>` *writable* chroot directory called a sandbox for interactive development (`--sandbox` option **GOOD** for testing and development)

The `target-input` is what specifies what will go into the container and can be one of the following:

* URI beginning with `docker://` to build from Docker Hub
* URI beginning with `shub://` to build from Singularity Hub
* path to an existing container (`.img`, `.simg`, or `.sif`)
* path to a directory of a sandbox container (an existing container built with `--sandbox`)
* path to an archive in `.tar` or `.tar.gz`
* path to a singularity recipe file

Example `singularity build` commands:

```bash
sudo singularity build --sandbox /home/mkijowski/ubuntu-container/ docker://ubuntu
## Builds a sandbox container directly from a dockerhub container

sudo singularity build ubuntu.sif /home/mkijowski/ubuntu-container/
## Converts a previoulsy created sandbox container to a static .sif containter
```

---

### Example Singularity build workflow

This section will describe my personal workflow for building a specific singularity container.  
To do this you need some information about what software you need / how to install it.

1. Determine a base OS (Ubuntu, rocky linux, etc).
2. Determine whether you need GPU access (determines whether you should start with a Cuda container from nvidia)
3. Start with a very simple build file using a docker image.  Check the `docker pull <owner/repo>` command and put it in the `From:` field in the recipe `.build` file.  The example below is using ubuntu latest via [Ubuntu dockerhub tags](https://hub.docker.com/_/ubuntu/tags)
```bash
## my-example-recipe.build
bootstrap:docker
From:ubuntu/latest

%setup
	# nothing yet
%environment
	# nothing yet
%post 
	# nothing yet
```
4. Build your container from the above as a `--sandbox`
```bash
sudo singularity build --sandbox ./my-sandbox/ ./my-axample-recipe.build
```
5. Enter your container and make changes using the following:
```bash
sudo singularity shell --writable ./my-sandbox/
```
  * I highly recommend documenting your changes back in the build file under the `%post` section.
    These need to be automated with no user input (silent installs) but dont worry about that for starters, just keep a
    record of what you are changing.
6. Test your container (preferably *without* using `--writable`)
7. Finalize your tested container by converting it to a `.sif` read-only file:
```bash
sudo singularity build my-container.sif ./my-sandbox/
```

---

## Advanced Singularity topics

### Binding directories with `-B`

By default the only directory shared between the host and container is /home/$USER.  This means other user's home directories are not accessible from within the container (nor are other useful directories like /scratch).
To remedy this you can specufy bind paths with the `--bind` or `-B` option.  
The format for bind baths is as follows:

```bash
singularity shell -B <src:dest> <container.sif>
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


