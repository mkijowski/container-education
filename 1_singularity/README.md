# Singularity Quick-Start guide
This quide will get you working with singularity quickly.

---

### Installing Singularity <latest>

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

### Building a singulularity container if you don't have || can't run singularity locally

If you don't have singularity on your local system but have access to a server with singularity installed (like `bender` or `fry`), you are able to build containers on the server. However, unless you're one of the lucky people with sudo privileges, you won't be able to build containers with the commands given above. Instead, you'll have to use a remote builder. This is essentially yet another remote server that will accept singularity recipe files and return built images.

The default remote builder for singularity is [cloud.sylabs.io/builder](https://cloud.sylabs.io/builder). In order to be able to use this remote builder with singularity, you will have to generate an API key at [cloud.sylabs.io/auth/tokens](https://cloud.sylabs.io/auth/tokens). Once you have generated an api key, save it to a local file for future reference and run the command `singularity remote login`. This will prompt you to enter the API token you just generated. If the login process works, singularity will print a message to the tune of "INFO:    API Key Verified!" At this point you are able to build singularity containers remotely by adding the `-r` or `--remote` flag to the build command.

Re-working the examples above for remote building:

```bash
singularity remote login
## Logs in to the remote builder

singularity build -r --sandbox /home/mkijowski/ubuntu-container/ docker://ubuntu
## Remotely builds a sandbox container directly from a dockerhub container

singularity build -r ubuntu.sif docker://ubuntu
## Remotely builds a static .sif containter
## NOTE: this is actually slightly different than the example above.
##  I wasn't able to find a way to easily convert the sandbox image to a .sif image,
##  so I just gave code for building a .sif container remotely :(
```

---

### Using and editing containers with `singularity shell` 
The `sudo singularity shell --writable /my/container/directory/` launches a shell inside the container from which we can continue our software installation and testing.  Note: the `--writable` flag requires sudo priveleges, without `--writable` the container would be read only (even though it is a `--sandbox` container.

Once you are finished installing and testing your software, do not forget to convert your `--sandbox` container back to a `.simg` with 
`sudo singularity build my-container.simg /my/container/directory/`

---

## Advanced Singularity topics

### [Singularity recipes](http://singularity.lbl.gov/docs-recipes)
A singularity recipe is a text file that defines a custom container build.  Instead of going into all of the ins nad outs of singularity recipes, refer to the document above and experimetn on our own.  In this directory are several exmaples of singularity recipes.  

### Binding with `-B`
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


