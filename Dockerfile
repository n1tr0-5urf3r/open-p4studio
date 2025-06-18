# Dockerfile
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    git \
    curl \
    sudo \
    python3 \
    python3-pip \
    build-essential \
    ca-certificates \
    libssl-dev \
    && apt-get clean

# Clone the repository
RUN git clone https://github.com/p4lang/open-p4studio.git /open-p4studio

WORKDIR /open-p4studio

# Apply the profile
RUN ./p4studio/p4studio profile apply testing

# Set environment variables
ENV SDE=/open-p4studio
ENV SDE_INSTALL=/open-p4studio/install

# Create the symlink
RUN ln -s $SDE_INSTALL/bin/p4c $SDE_INSTALL/bin/bf-p4c

# Set entrypoint or default command if needed
CMD ["/bin/bash"]
