# Cuda examples

The most useful thing here is simply NVidia's own cuda containers on Docker Hub.  Using these we can simply run the below build file:

```bash
bootstrap:docker                                                                              
From:nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04

%setup

%environment

%post
	sudo apt update && upgrade

```

And we will have a working container.  

## Other Cuda versions / dev environments

For other versions check out the Nvidia/cuda dockerhub tags page:

* https://hub.docker.com/r/nvidia/cuda/tags

Older versions like `cuda9_0.build` probably wont build anymore, so they are only here for reference.

## fix-cuda.sh

I honestly do not recall why this exists but am leaving it here anyway.  I seem to recall issues with gpu detection even when using the `--nv` flag
and this may have fixed it.
 
