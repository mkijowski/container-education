## [Building a singularity container](https://singularity.lbl.gov/docs-build-container)
The `singularity build` command is used to create singularity containers.  With it you specfy the output container image and a target input to build the contianer from.

```
singularity build output-image target-input
```

The `output-image` can produce containers in three different formats:
* compressed, read-only, squashfs files system suitable for production (default)
* writable ext3 file system for interactive development (`--writable` option)
* writable chroot directory called a sandbox for interactive development (`--sandbox` option)

The `target-input` is what specifies what will go into the container and can be one of the following:
* URI beginning with `shub://` to build from Singularity Hub
* URI beginning with `docker://` to build from Docker Hub
* path to an existing container (`.img` or `.simg`)
* path to a directory of a sandbox container (an existing container built with `--sandbox`)
* path to an archive in `.tar` or `.tar.gz`
* path to a singularity recipe file

## Lets build our first container
Building from a dockerhub docker container.  Choose one of the following:
* [Anaconda3](https://hub.docker.com/r/continuumio/anaconda3/) `singularity build anaconda3.simg docker://continuumio/anaconda3` ~9m
* [Tensorflow](https://hub.docker.com/r/tensorflow/tensorflow/) `singularity build tensorflow.simg docker://tensorflow/tensorflow` ~5m
* [Cuda](https://hub.docker.com/r/nvidia/cuda/) `singularity build cuda.simg docker://nvidia/cuda:9.1-cudnn7-devel-ubuntu16.04` ~7m

## Great, now what?
The `singularity shell` and `singularity exec` commands allow us to use the container we have just built.
* `singularity shell container.simg` launches a shell inside the container
* `singularity exec container.simg command` executes the command specified inside of the container (will be used in job scheduling scripts)

### But what are the odds someone has done all your work for you? :)
Chances are another container won't quite work for a similar workflow (without some tweaking)

Enter `--sandbox` containers!  Convert your previous container into a sandbox directory. 
```singularity build --sandbox anaconda3-dir/ anaconda3.simg```
Copy files into the container as necessary.
Launch the container in a writable state:
```singularity shell --writable anaconda3-dir/```
