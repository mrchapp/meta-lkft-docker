FROM debian:stretch-slim
MAINTAINER Daniel Díaz <daniel.diaz@linaro.org>

RUN dpkg --add-architecture i386 \
 && echo 'locales locales/locales_to_be_generated multiselect C.UTF-8 UTF-8, en_US.UTF-8 UTF-8 ' | debconf-set-selections \
 && echo 'locales locales/default_environment_locale select en_US.UTF-8' | debconf-set-selections \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt dist-upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    binutils \
    bzip2 \
    ca-certificates \
    chrpath \
    cpio \
    cpp \
    diffstat \
    file \
    g++ \
    gawk \
    gcc \
    git \
    libc-dev-bin \
    libssl-dev \
    locales \
    make \
    patch \
    python \
    python3 \
    sudo \
    texinfo \
    wget \
 && apt-get clean \
 && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

ENV LC_ALL=en_US.UTF-8

RUN useradd -m lkftuser \
 && mkdir /oe && chown lkftuser:lkftuser /oe \
 && echo 'lkftuser ALL = NOPASSWD: ALL' > /etc/sudoers.d/lkft \
 && chmod 0440 /etc/sudoers.d/lkft

USER lkftuser

WORKDIR /oe

RUN git config --global user.name "LKFT OE User" \
 && git config --global user.email "lkft-maintainers@lists.linaro.org" \
 && git config --global color.ui auto \
 && mkdir -p $HOME/bin \
 && wget https://storage.googleapis.com/git-repo-downloads/repo -O $HOME/bin/repo \
 && chmod +x $HOME/bin/repo

RUN $HOME/bin/repo init -b lkft/rocko -u https://github.com/96boards/oe-rpb-manifest \
 && $HOME/bin/repo sync

COPY lkft-bitbake-helper /home/lkftuser/bin/lkft-bitbake-helper

ENTRYPOINT ["/home/lkftuser/bin/lkft-bitbake-helper"]
