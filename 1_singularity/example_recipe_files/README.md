## These build files can be built with the following command:
```
singularity build (container image name) (container build file)
``` 

For example:
```
singularity build matlab.simg matlab/MCRv90-R2015b.build
```

This will provide an container image ready to be run and used.  

### Note:
Some build files will require local files to be available or access to restricted systems.  Please check comments in each build file for any pre-requisite steps for build.

## You can also build directly from a dockerhub container 
```
singularity build (container image name) docker://(dockerhub location)
```

For example to build a jupyter minimal-notebook container run the following:
```
singularity build jupyter_minimal.simg docker://jupyter/minimal-notebook
```
