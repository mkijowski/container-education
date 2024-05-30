## These build files can be built with the following command:

```
sudo singularity build <container image name> <container build file>
``` 

For example:

```
sudo singularity build pytorch.sif pytorch/pytorch-cuda12_4.build
```

This will provide an container image ready to be run and used.  

### Note:

Some build files will require local files to be available or access to restricted systems.  Please check comments in each build file for any pre-requisite steps for build.

## You can also build directly from a dockerhub container 

```
sudo singularity build <container image name> docker://<dockerhub pull tag location>
```

For example to build a jupyter minimal-notebook container run the following:

```
sudo singularity build jupyter_minimal.sif docker://jupyter/minimal-notebook
```

