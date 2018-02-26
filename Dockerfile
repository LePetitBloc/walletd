ARG BDB_VERSION="5.3.28.NC"

FROM lepetitbloc/bdb:$BDB_VERSION

ARG WALLET="artax"
ARG USE_UPNP=1
ARG REPOSITORY="https://github.com/Artax-Project/Artax.git"

ENV WALLET=$WALLET \
    HOME=/home/wallet

EXPOSE 9999 9998

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
&& useradd -lrUm wallet \
&& git clone --depth 1 $REPOSITORY /wallet

WORKDIR /wallet/src

RUN make -f makefile.unix \
&& strip ${WALLET}d \
&& mv ${WALLET}d /usr/local/bin/walletd \
&& rm -rf /wallet

USER wallet

WORKDIR $HOME

RUN mkdir -p data conf

COPY conf conf

ENTRYPOINT ["/usr/local/bin/walletd", "-rescan", "-printtoconsole", "-logtimestamps=1", "-datadir=data", "-conf=../conf/wallet.conf", "-mnconf=../conf/masternode.conf", "-port=9999", "-rpcport=9998"]
CMD ["-rpcuser=walletrpc", "-rpcpassword=4VvDhcoqFUcZbmkWUMJz8P443WLfoaMmiREKSByJaT4j", "-rpcallowip=127.0.0.1", "-server=1", "-listen=0", "-masternode=0"]
