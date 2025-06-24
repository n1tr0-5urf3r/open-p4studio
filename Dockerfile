FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    sudo python3 python3-pip build-essential cmake ca-certificates libssl-dev \
    ccache \
    && apt-get clean

# Enable ccache for GCC/G++
ENV CC="ccache gcc"
ENV CXX="ccache g++"Add commentMore actions
ENV CCACHE_BASEDIR=/open-p4studio
ENV CCACHE_NOHASHDIR=true
RUN echo "compiler_check=content" >> /etc/ccache.conf
ENV CCACHE_DIR=/root/.ccache

# Let CMake know to use ccache
ENV CMAKE_GENERATOR="Unix Makefiles"
ENV CMAKE_C_COMPILER_LAUNCHER=ccache
ENV CMAKE_CXX_COMPILER_LAUNCHER=ccache

# Create workspace
WORKDIR /open-p4studio
COPY . .

RUN ccache --set-config cache_dir=.ccache
RUN ccache --set-config max_size=2G

RUN --mount=type=cache,target=.ccache \
    ./p4studio/p4studio profile apply --jobs $(nproc) ./p4studio/profiles/docker.yaml && \
    ccache -s

# Set environment variables
ENV SDE=/open-p4studio
ENV SDE_INSTALL=/open-p4studio/install

# Create the symlink
RUN ln -s $SDE_INSTALL/bin/p4c $SDE_INSTALL/bin/bf-p4c

CMD ["/bin/bash"]
