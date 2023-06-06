ARG CUDA_VERSION=11.8.0
ARG CUDNN_VERSION=8
ARG UBUNTU_VERSION=22.04

FROM nvidia/cuda:${CUDA_VERSION}-cudnn${CUDNN_VERSION}-devel-ubuntu${UBUNTU_VERSION}

ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
ENV LIBRARY_PATH=${LIBRARY_PATH}:/usr/local/cuda/lib64
ENV PATH /usr/local/bin:/usr/local/cuda/bin:$PATH
ENV XLA_FLAGS --xla_gpu_cuda_data_dir=/usr/local/cuda

ARG DEBIAN_FRONTEND=noninteractive
# update and upgrade your system:
RUN apt-get update && apt-get upgrade -y
# install Linux tools and Python 3
RUN apt-get install -y build-essential cmake pkg-config unzip yasm git checkinstall wget
RUN apt-get install -y python3-dev python3-pip python3-wheel python3-setuptools
# install Python packages
RUN python3 -m pip install --upgrade pip
COPY requirements.txt /tmp/
RUN python3 -m pip install -r /tmp/requirements.txt && rm /tmp/requirements.txt
# install quarto
RUN wget https://quarto.org/download/latest/quarto-linux-amd64.deb
RUN dpkg -i quarto-linux-amd64.deb
RUN rm quarto-linux-amd64.deb
# clean up
RUN pip3 cache purge
RUN apt-get autoremove -y && apt-get clean
RUN rm -rf /var/lib/apt/lists/*
