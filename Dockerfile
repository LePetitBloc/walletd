ARG BDB_VERSION="5.3.28.NC"

FROM lepetitbloc/bdb:$BDB_VERSION

ARG WALLET="artax"
ARG USE_UPNP=1
ARG REPOSITORY="https://github.com/Artax-Project/Artax.git"

ENV WALLET=$WALLET \
    HOME=/home/$WALLET

EXPOSE 21527 21528

RUN apt-get update -y && apt-get install -y \
    libssl-dev \
    libboost-system-dev \
    libboost-filesystem-dev \
    libboost-chrono-dev \
    libboost-program-options-dev \
    libboost-test-dev \
    libboost-thread-dev \
    libminiupnpc-dev \
    libqrencode-dev \
    libgmp-dev \
    automake \
    pkg-config \
    git \
&& rm -rf /var/lib/apt/lists/* \
&& useradd -lrUm $WALLET

USER $WALLET

WORKDIR $HOME

RUN mkdir -p data bin conf \
&& git clone --depth 1 $REPOSITORY wallet

WORKDIR $HOME/wallet/src

RUN make -f makefile.unix \
&& strip ${WALLET}d \
&& mv ${WALLET}d $HOME/bin \
&& rm -rf wallet

WORKDIR $HOME

COPY conf conf

ENTRYPOINT "bin/${WALLET}d"
CMD ["-rescan", "-printtoconsole", "--datadir=data", "-conf=../conf/wallet.conf", "--mnconf=../conf/masternode.conf"]