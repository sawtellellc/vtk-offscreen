
## offscreen VTK docker container

+ build container

```
bash build.sh
```

+ versions used:
```
ubuntu-18.04 mesa-18.1.7 vtk-9.0.1
```

+ test out vtk

```
docker run -w /workdir -v $PWD:/workdir vtk-offscreen bash -c "python test_offscreen.py"

ls -lh *.png

```

## references

```
https://gist.github.com/nestarz/4d41986b29e55bd2a7a870ee0777f3f5
https://gist.github.com/pangyuteng/3fea371f9c783d81b75d0ef12099dbef
https://hub.docker.com/r/tailriver/paraview-osmesa/dockerfile
https://gist.github.com/pangyuteng/cf6345c4e5f8f77756064e4de9ef76c7
```
