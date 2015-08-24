FROM                                   centos:7
MAINTAINER                             David Scott <dave.scott@citrix.com>

# Build requirements
RUN     yum install -y \
            git \
            make \
            mercurial \
            mock \
            rpm-build \
            rpm-python \
            sudo \
            yum-utils \
            epel-release \
            redhat-lsb-core

# Niceties
RUN     yum install -y \
            tig \
            tmux \
            vim \
            wget \
            which

# Install planex
RUN     yum -y install https://xenserver.github.io/planex-release/release/rpm/el/planex-release-7-1.noarch.rpm
RUN     yum -y install planex

# Set up the builder user
RUN     useradd builder
RUN     echo "builder:builder" | chpasswd
RUN     echo "builder ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN     usermod -G mock builder

