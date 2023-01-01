# syntax=docker/dockerfile-upstream:master-labs
FROM worc4021/hsl:latest as hsl-builder

RUN apt update && apt install -y \
    build-essential \
    gfortran \
    libblas-dev \
    liblapack-dev \
    libopenblas-dev \
    libtool \
    wget \
    metis \
    pkg-config 

ENV PKG_CONFIG_PATH=/build/lib/pkgconfig

ADD https://github.com/coin-or-tools/ThirdParty-Mumps.git#stable/3.0 /mumps-src

WORKDIR /mumps-src

RUN ./get.Mumps && \
    ./configure --prefix=/build \
    --enable-mpi \
    --enable-64bit-int \
    --enable-parallel \
    --enable-static \
    && make -j$(nproc) \
    && make test \
    && make install

ADD https://github.com/coin-or/Ipopt.git#stable/3.14 /ipopt-src

WORKDIR /ipopt-src

RUN /ipopt-src/configure --prefix=/build \
     --disable-linear-solver-loader \
     --disable-sipopt \
     --disable-java \
     --enable-static \
    && make -j$(nproc) \
    && make test \
    && make install

