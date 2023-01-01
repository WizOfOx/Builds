FROM worc4021/hsl:latest as hsl-builder

RUN apt update && apt install -y \
    build-essential \
    gfortran \
    libblas-dev \
    liblapack-dev \
    libopenblas-dev \
    libtool \
    wget

COPY . /ipopt-src

WORKDIR /ipopt-src

RUN ./configure --prefix=/build \
     --with-hsl-cflags="-I/build/include" \
     --with-hsl-lflags="-L/build/lib -lcoinhsl" \
     --with-lapack="-llapack" \
     --disable-linear-solver-loader \
     --disable-sipopt \
     --disable-java \
     --enable-static \
    && make -j$(nproc) \
    && make install

