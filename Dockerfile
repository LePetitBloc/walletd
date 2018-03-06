ARG BDB_VERSION="4.8.30.NC"

FROM lepetitbloc/bdb:$BDB_VERSION

ARG USE_UPNP=1
ARG WALLET="wallet"
ARG CONF_DIRECTORY="conf/"
ARG REPOSITORY="https://github.com/org/wallet.git"

ENV USE_UPNP=$USE_UPNP \
    WALLET=$WALLET

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
    libevent-dev \
    libzmq3-dev \
    automake \
    pkg-config \
    git \
    bsdmainutils \
&& rm -rf /var/lib/apt/lists/* \
&& useradd -lrUm $WALLET \
&& git clone --depth 1 $REPOSITORY /tmp/$WALLET

WORKDIR /tmp/$WALLET

# build
RUN chmod +x autogen.sh share/genbuild.sh src/leveldb/build_detect_platform \
&& ./autogen.sh \
&& ./configure CPPFLAGS="-I/usr/local/db4/include -O2" LDFLAGS="-L/usr/local/db4/lib" \
&& make \
&& strip src/${WALLET}d src/${WALLET}-cli src/${WALLET}-tx \
&& mv src/${WALLET}d /usr/local/bin/ \
&& mv src/${WALLET}-cli /usr/local/bin/ \
&& mv src/${WALLET}-tx /usr/local/bin/ \
&& rm -rf /tmp/$WALLET

USER $WALLET

WORKDIR $HOME

RUN mkdir -p data $CONF_DIRECTORY

COPY wallet/$CONF_DIRECTORY $CONF_DIRECTORY

ENTRYPOINT ["/usr/local/bin/walletd", "-reindex", "-printtoconsole", "-logtimestamps=1", "-datadir=data", "-conf=../conf/wallet.conf", "-mnconf=../conf/masternode.conf", "-port=9999", "-rpcport=9998"]
CMD ["-rpcallowip=127.0.0.1", "-server=1", "-masternode=0"]
