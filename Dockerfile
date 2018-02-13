ARG BDB_VERSION="5.3.28.NC"

FROM lepetitbloc/bdb:${BDB_VERSION}

ENV WALLET="artax" \
    REPOSITORY="https://github.com/Artax-Project/Artax.git"

RUN HOME /home/$WALLET \
&& groupadd -r $WALLET && useradd --no-log-init -r -g $WALLET $WALLET \
&& mkdir /home/$WALLET && chown $WALLET:$WALLET /home/$WALLET \
&& apt-get update -y && apt-get install -y \
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
&& USE_UPNP=1 \
&& cd /home/$WALLET

USER $WALLET

RUN git clone $REPOSITORY wallet \
&& cd wallet/src \
&& make -f makefile.unix \
&& strip ${WALLET}d \
&& mkdir -p $HOME/data $HOME/backup $HOME/conf $HOME/bin \
&& mv ${WALLET}d $HOME/bin

COPY conf $HOME/conf

WORKDIR $HOME

CMD "${HOME}/bin/${WALLET}d -rescan -printtoconsole --datadir=${HOME}/data -conf=${HOME}/conf/wallet.conf --mnconf=${HOME}/conf/masternode.conf"
