#!/bin/bash

yum install -y \
    gcc \
    gcc-c++ \
    make \
    openssl-devel \
    uuid-devel \
    libuuid-devel \
    squashfs-tools \
    gpgme-devel \
    libseccomp-devel \
    wget \
    git \
    pkgconfig \
    cryptsetup

## installing GO
export VERSION=1.14.2 OS=linux ARCH=amd64 
wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz 
sudo tar -C /usr/local -xzvf go$VERSION.$OS-$ARCH.tar.gz 
rm go$VERSION.$OS-$ARCH.tar.gz

## Set Go path
echo 'export PATH=/usr/local/go/bin:$PATH' > ~/.bashrc

## Download Singularity 
export VERSION=3.5.2 
wget https://github.com/sylabs/singularity/releases/download/v${VERSION}/singularity-${VERSION}.tar.gz
tar -xzf singularity-${VERSION}.tar.gz 
rm singularity-${VERSION}.tar.gz 
cd singularity


## This sometimes breaks because go is not in the path, amy need to run these 
## last few commands manually...
source ~/.bashrc
export PATH=/usr/local/go/bin:$PATH
./mconfig
make -C builddir
sudo make -C builddir install
