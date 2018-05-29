## [Singularity recipes](http://singularity.lbl.gov/docs-recipes)
A singularity recipe is a text file that defines a custom container build.  Instead of going into all of the ins nad outs of singularity recipes, refer to the document above and experimetn on our own.  In this directory are several exmaples of singularity recipes.  

## Binding with `-B`
By default the only directory shared between the host and container is /home/$USER.  This means other user's home directories are not accessible from within the container (nor are other useful directories like /scratch).
To remedy this you can specufy bind paths with the `--bind` or `-B` option.  
The format for bind baths is as follows:
```
singularity shell -B src:dest cuda.simg
```
Where `src` is a path on the host and `dest` is a path within the container.  If no `dest` path is provided it will use the same path as `src` inside the container.

## Nvidia GPU support (CUDA)
Singularity containers support direct access to a local GPU only when given the `--nv` flag.
```
singularity shell --nv cuda.simg
```
This does more than just allow access to the GPU, it also binds a number of specified nvidia and cuda libraries into the container in the following directory:
```
/.singularity.d/lib/
```
Note: this path may need to be added to your defualt paths for cuda to work (in ubuntu you can copy the `singularity-nvidia.conf` file in this git repository to `/etc/ld.so.conf.d/singularity-nvidia.conf`.  You may need to reload the container for this to take effect.

