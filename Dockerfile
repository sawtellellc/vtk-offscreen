#
# https://github.com/sawtellellc/vtk-offscreen
#
FROM ubuntu:18.04


RUN apt-get update && apt-get install -yq --no-install-recommends \
        autotools-dev \
        build-essential \
        ca-certificates \
        cmake \
        make \
        git \
        wget \
        unzip \
        vim \
        software-properties-common \
        x11-apps \
        autoconf \
        bison \
        curl \
        flex \
        g++ \
        pkg-config \
        zlib1g-dev \
        python3.6 \
        python3.6-dev \
        libpython3.6 \
        python-pip \
        libpthread-stubs0-dev \
        llvm-4.0-dev  \
        libpng-dev libfontconfig-dev libxrender-dev libncurses5-dev \
        libx11-dev libxt-dev \
        freeglut3 freeglut3-dev \
        libgl1-mesa-dev libglu1-mesa-dev

RUN  rm -rf /var/lib/apt/lists/*

# ref https://gist.github.com/nestarz/4d41986b29e55bd2a7a870ee0777f3f5
WORKDIR /src
RUN curl -L ftp://ftp.freedesktop.org/pub/mesa/mesa-18.1.7.tar.gz | tar xz \
 && cd mesa-18.1.7 \
 && ./configure                                     \
  --prefix=/mesa/                                   \
  --enable-opengl --disable-gles1 --disable-gles2   \
  --disable-va --disable-xvmc --disable-vdpau       \
  --enable-shared-glapi                             \
  --disable-texture-float                           \
  --enable-gallium-llvm --enable-llvm-shared-libs   \
  --with-gallium-drivers=swrast,swr                 \
  --disable-dri --with-dri-drivers=                 \
  --disable-egl --with-egl-platforms= --disable-gbm \
  --disable-glx                                     \
  --disable-osmesa --enable-gallium-osmesa          \
  ac_cv_path_LLVM_CONFIG=/usr/bin/llvm-config-4.0   \
 && make -j"$(nproc)" \
 && make install -j"$(nproc)" \
 && ldconfig
 
# ref https://gist.github.com/pangyuteng/3fea371f9c783d81b75d0ef12099dbef
RUN mkdir -p /src/vtk
RUN wget https://www.vtk.org/files/release/9.0/VTK-9.0.1.tar.gz -O vtk.tar.gz && \
    tar -xzf vtk.tar.gz -C /src/vtk --strip-components 1

RUN mkdir -p /src/vtk/build
WORKDIR /src/vtk/build
RUN cmake .. \
        -DVTK_OPENGL_HAS_OSMESA=ON \
        -DVTK_USE_OFFSCREEN=ON \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DVTK_PYTHON_VERSION=3 \
        -DVTK_WRAP_PYTHON=ON \
        -DPYTHON_EXECUTABLE=/usr/bin/python3 \
        -DPYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.6m.so \
        -DBUILD_SHARED_LIBS=ON \
        -DOSMESA_INCLUDE_DIR=/src/mesa-18.1.7/include \
        -DOSMESA_LIBRARY=/mesa/lib/libOSMesa.so \
        -DOPENGL_INCLUDE_DIR=/src/mesa-18.1.7/include \
        -DOPENGL_gl_LIBRARY=/usr/lib/x86_64-linux-gnu/libGL.so \
        -DOPENGL_glu_LIBRARY=/usr/lib/x86_64-linux-gnu/libGLU.so \
        -DVTK_USE_X=OFF 

RUN make -j"$(nproc)" && make install -j"$(nproc)"

ENV VTK_BUILD=/usr/local
ENV MESA_HOME=/mesa
ENV LD_LIBRARY_PATH $VTK_BUILD/lib:$MESA_HOME/lib:$LD_LIBRARY_PATH
ENV PYTHONPATH $VTK_BUILD/bin

RUN rm /usr/bin/python && ln -s /usr/local/bin/vtkpython /usr/bin/python

RUN apt-get update && apt-get -y install python3-pip ffmpeg && pip3 install pillow numpy moviepy

WORKDIR /opt
COPY test_offscreen.py /opt


