

?` export LIBGL_ALWAYS_INDIRECT=1 `
echo $DISPLAY
ssh -X $hostname
cd $repo
bash build.sh
docker run -it -e DISPLAY --net host -v /tmp/.X11-unix:/tmp/.X11-unix offscreen-vtk bash

docker run -it -e DISPLAY=192.168.68.117:1 offscreen-vtk bash

xclock

```


https://gist.github.com/pangyuteng/3fea371f9c783d81b75d0ef12099dbef
https://hub.docker.com/r/tailriver/paraview-osmesa/dockerfile

```
