# -*- Dockerfile -*-
ARG UVERSION
FROM ubuntu:$UVERSION
MAINTAINER Christian Hopps <chopps@labn.net>

ENV LANG=en_US.UTF-8 \
    LC_ALL="en_US.UTF-8" \
    LC_CTYPE="en_US.UTF-8"

ARG UNAME

RUN apt-get update -qy && apt-get dist-upgrade -y && \
    # Add docker.
    apt-get install -y apt-transport-https dirmngr software-properties-common curl && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $UNAME stable" && \
    apt-get update -qy && apt-get dist-upgrade -y && \
    # Add useful stuff for building/CI-testing
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        autoconf \
        bash \
        bash-completion \
        bison \
        bridge-utils \
        build-essential \
        clang \
        clang-9 \
        cpio \
        curl \
        docker-ce \
        flex \
        gawk \
        gdb \
        gettext \
        git \
        gperf \
        iperf \
        iproute2 \
        iputils-ping \
        jq \
        kmod \
        libedit-dev \
        libev-dev \
        libffi-dev \
        libgmp-dev \
        libssl-dev \
        libxslt-dev \
        locales \
        locales-all \
        make \
        net-tools \
        netcat-openbsd \
        pciutils \
        python \
        python-cffi \
        python-dev \
        python3 \
        python3-cffi \
        python3-dev \
        python3-pip \
        python3-venv \
        rsync \
        snmp \
        ssh \
        systemd-coredump \
        sudo \
        tcpdump \
        tidy \
        traceroute \
        vim \
        xsltproc \
        zlib1g-dev \
        # From VPP install-dep
        autoconf \
        automake \
        build-essential \
        ccache \
        check \
        chrpath \
        clang-format \
        cmake \
        cscope \
        curl \
        debhelper \
        dh-systemd \
        dkms \
        exuberant-ctags \
        git \
        git-review \
        indent \
        lcov \
        libapr1-dev \
        libboost-all-dev \
        libconfuse-dev \
        libffi-dev \
        libmbedtls-dev \
        libnuma-dev \
        libmnl-dev \
        libssl-dev \
        libtool \
        ninja-build \
        pkg-config \
        python-all \
        python-dev \
        python3-all \
        python3-jsonschema \
        python3-ply \
        python3-setuptools \
        uuid-dev \
        # For FRR build
        bison \
        flex \
        install-info \
        libc-ares-dev \
        libcap-dev \
        libjson-c-dev \
        libpam0g-dev \
        libreadline-dev \
        libsnmp-dev \
        libsystemd-dev \
        perl \
        python-ipaddress \
        python3-sphinx \
        texinfo \
        && \
    echo en_US.UTF-8 UTF-8 >> /etc/locale.gen && \
    locale-gen && \
    #pip install -U \
    #    cffi coverage cryptography docker docker-compose lxml nose pyang pylint pysnmp \
    #    pytest pyyaml remarshal tox twine wheel && \
    pip3 install -U \
        cffi coverage cryptography docker                lxml nose       pylint pysnmp \
        pytest pyyaml remarshal tox twine wheel && \
    # Install MIBs
    apt-get install -y snmp-mibs-downloader && download-mibs

RUN echo "Versions $(lsb_release -rs)"
RUN if [ "$(lsb_release -rs)" = "18.04" ]; then DEBIAN_FRONTEND=noninteractive apt-get install -y bsdtar python-pip libffi6 python-virtualenv; fi
RUN if [ "$(lsb_release -rs)" = "20.04" ]; then DEBIAN_FRONTEND=noninteractive apt-get install -y libarchive-tools; fi
