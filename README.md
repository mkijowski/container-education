# Introduction to Containers & Singularity

The purpose of this repository is to provide a hands-on environment that provides some introductory experience in using containers.

By the end of this you will hopefully understand the following:
* What a container is
* When to use a container
* Several methods for building singularity containers
* Common Singularity flags

Since I am presenting this repository it will be used mostly for a reference.  

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
 
## What is a container


## Background information for all technologies
### Linux Containers (LXC)
[Linux Containers or LXC](https://en.wikipedia.org/wiki/LXC) is an operating system level virtualization method for running multiple isolated Linux systems (containers) on a host using a Single Linux kernel (wikipedia).

LXC uses a variety of kernel tools such as [chroot][chroot], [cgroups][cgroups], and [namespaces][namespaces] to provide isolation of containers.
