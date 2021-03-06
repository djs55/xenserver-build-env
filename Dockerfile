FROM                                   centos:7.1.1503
MAINTAINER                             John Else <john.else@citrix.com>

# Update yum.conf - not default!
COPY    files/yum.conf                 /etc/yum.conf.xs

# Add the Citrix yum repo and GPG key
RUN     mkdir -p /etc/yum.repos.d.xs
COPY    files/Citrix.repo.in           /tmp/Citrix.repo.in
COPY    files/RPM-GPG-KEY-Citrix-6.6   /etc/pki/rpm-gpg/RPM-GPG-KEY-Citrix-6.6

# Add the publicly available repo
COPY    files/xs.repo /etc/yum.repos.d/xs.repo

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
            epel-release

# Niceties
RUN     yum install -y \
            tig \
            tmux \
            vim \
            wget \
            which

# Install planex
RUN     yum -y install https://xenserver.github.io/planex-release/release/rpm/el/planex-release-7-1.noarch.rpm
RUN     cp /etc/yum.repos.d/planex-release.repo /etc/yum.repos.d.xs/planex-release.repo
RUN     yum -y install planex

# OCaml in XS is slightly older than in CentOS
RUN	sed -i "/gpgkey/a exclude=ocaml*" /etc/yum.repos.d/Cent* /etc/yum.repos.d/epel*

# Set up the builder user
RUN     useradd builder
RUN     echo "builder:builder" | chpasswd
RUN     echo "builder ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN     usermod -G mock builder

RUN     mkdir -p /usr/local/bin
COPY    files/init-container.sh        /usr/local/bin/init-container.sh

RUN	yum --enablerepo=xs clean metadata

