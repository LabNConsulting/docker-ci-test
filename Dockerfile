# -*- Dockerfile -*-
ARG UVERSION
FROM ubuntu:$UVERSION
MAINTAINER Christian Hopps <chopps@labn.net>

ENV LANG=en_US.UTF-8 \
    LC_ALL="en_US.UTF-8" \
    LC_CTYPE="en_US.UTF-8"

ARG UNAME
ARG LIBYANGVERSION=1.0.167
ARG SYSREPOVERSION=1.4.66

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
        libprotobuf-c-dev \
        libreadline-dev \
        libsnmp-dev \
        libsystemd-dev \
        libzmq3-dev \
        libzmq5 \
        perl \
        protobuf-c-compiler \
        python-ipaddress \
        python3-sphinx \
        texinfo \
        # For libyang build
        libpcre3-dev \
        # For libyang and sysrepo
        swig \
        && \
    groupadd -r -g 92 frr && \
    groupadd -r -g 85 frrvty && \
    adduser --system --ingroup frr --home /var/run/frr --gecos "FRR suite" --shell /sbin/nologin frr && \
    usermod -a -G frrvty frr && \
    echo en_US.UTF-8 UTF-8 >> /etc/locale.gen && \
    locale-gen && \
    #pip install -U \
    #    cffi coverage cryptography docker docker-compose lxml nose pyang pylint pysnmp \
    #    pytest pyyaml remarshal tox twine wheel && \
    pip3 install -U \
        cffi coverage cryptography docker                lxml nose       pylint pysnmp \
        pytest pyyaml remarshal tox twine wheel && \
    # Install MIBs
        apt-get install -y snmp-mibs-downloader && download-mibs && \
    # Install libyang
    curl -o libyang-$LIBYANGVERSION.tgz -L https://github.com/CESNET/libyang/tarball/v$LIBYANGVERSION && \
    mkdir -p $LIBYANGVERSION/build && \
    tar -C $LIBYANGVERSION --strip-components=1 -xf ../libyang-$LIBYANGVERSION.tgz && \
    cd $LIBYANGVERSION/build && \
    cmake -DGEN_LANGUAGE_BINDINGS=ON -DENABLE_LYD_PRIV=ON -DCMAKE_INSTALL_PREFIX:PATH=/usr \
        -D CMAKE_BUILD_TYPE:String="Release" .. && \
    make && make install && \
    # Install sysrepo
    curl -o sysrepo-$SYSREPOVERSION.tgz -L https://github.com/sysrepo/sysrepo/tarball/v$SYSREPOVERSION && \
    mkdir -p $SYSREPOVERSION/build && \
    tar -C $SYSREPOVERSION --strip-components=1 -xf ../sysrepo-$SYSREPOVERSION.tgz && \
    cd $SYSREPOVERSION/build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DGEN_LANGUAGE_BINDINGS=ON .. && \
    make && make install

RUN if [ "$(lsb_release -rs)" = "18.04" ]; then DEBIAN_FRONTEND=noninteractive apt-get install -y bsdtar python-pip libffi6 python-virtualenv; fi
RUN if [ "$(lsb_release -rs)" = "20.04" ]; then DEBIAN_FRONTEND=noninteractive apt-get install -y libarchive-tools; fi
