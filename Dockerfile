FROM nvidia/cuda:11.1.1-cudnn8-devel-ubuntu20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    ca-certificates \
    ccache \
    cmake \
    curl \
    git \
    git-lfs \
    libcurl3-dev \
    libfreetype6-dev \
    libhdf5-serial-dev \
    libzmq3-dev \
    libjpeg-dev \
    libpng-dev \
    libopenjp2-7-dev \
    liblcms2-dev \
    libtiff-dev \
    libsndfile1 \
    ffmpeg \
    libz-dev \
    pkg-config \
    rsync \
    software-properties-common \
    sox \
    unzip \
    zip \
    zlib1g-dev \
    wget \
    vim \
    zsh \
    fonts-powerline \
    fonts-firacode \
    openmpi-bin \
    python3-dev \
    python3-opencv \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && rm -rf /var/lib/apt/lists/*

ENV PATH /opt/conda/bin:$PATH
ARG PYTHON_VERSION=3.7
RUN wget -O ~/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && chmod +x ~/miniconda.sh \
    && ~/miniconda.sh -b -p /opt/conda \
    && /opt/conda/bin/conda config --set repodata_threads 4 \
    && /opt/conda/bin/conda config --add channels nvidia \
    && /opt/conda/bin/conda config --add channels pytorch \
    && /opt/conda/bin/conda config --append channels conda-forge \
    && rm ~/miniconda.sh
RUN /opt/conda/bin/conda install -y \
    python=${PYTHON_VERSION} \
    # pytorch \
    # torchvision \
    # cudatoolkit \
    black \
    flake8 \
    h5py \
    matplotlib \
    ninja \
    pandas \
    pillow \
    scikit-learn \
    scipy \
    seaborn \
    # protobuf=3.0 \
    "cmake>=3.20" \
    && /opt/conda/bin/conda clean -ya

RUN /opt/conda/bin/pip install --no-cache-dir --upgrade \
    opencv-python

RUN apt-get update && apt-get install -y \
    libboost-all-dev \
    libprotobuf-dev \
    libatlas-base-dev \
    libleveldb-dev \
    libsnappy-dev \
    libhdf5-serial-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    liblmdb-dev \
    opencl-headers \
    ocl-icd-opencl-dev \
    libviennacl-dev \
    protobuf-compiler \
    python3-dev \
    python3-opencv \
    libopencv-dev \
    && rm -rf /var/lib/apt/lists/*
ENV NVIDIA_DRIVER_CAPABILITIES all
# RUN git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose \
#     && cd /openpose \
#     && git submodule update --init --recursive --remote \
#     && mkdir build \
#     && cd build \
#     && cmake .. \
#     && make -j $(nproc)

RUN pip install flask
