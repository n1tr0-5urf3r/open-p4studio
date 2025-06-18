FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Create workspace and copy code into container
WORKDIR /open-p4studio
COPY . .

# Apply the profile
RUN ./p4studio/p4studio profile apply --jobs $(nproc) ./p4studio/profiles/testing.yaml

# Set environment variables
ENV SDE=/open-p4studio
ENV SDE_INSTALL=/open-p4studio/install

# Create the symlink
RUN ln -s $SDE_INSTALL/bin/p4c $SDE_INSTALL/bin/bf-p4c

CMD ["/bin/bash"]
