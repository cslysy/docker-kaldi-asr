FROM debian:8

ARG MAKE_JOBS=1

RUN apt-get update && apt-get install --no-install-recommends -y  \
    autoconf \
    automake \
    bzip2 \
    g++ \
    git \
    libatlas3-base \
    libtool-bin \
    make \
    patch \
    python2.7 \
    python3 \
    python-pip \
    subversion \
    wget \
    zlib1g-dev && \
    apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y

RUN mkdir -p /opt/kaldi && \
    git clone https://github.com/kaldi-asr/kaldi /opt/kaldi && \
    cd /opt/kaldi/tools && \
    make -j${MAKE_JOBS} && \
    ./install_portaudio.sh && \
    cd /opt/kaldi/src && \
    ./configure --shared && \
    sed -i '/-g # -O0 -DKALDI_PARANOID/c\-O3 -DNDEBUG' kaldi.mk && \
    make -j${MAKE_JOBS} depend && \
    make -j${MAKE_JOBS} && \
    cd /opt/kaldi && git log -n1 > current-git-commit.txt
