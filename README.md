# Cross Wallet Daemon (`walletd`)

Cross Wallet Daemon for headless wallets and masternodes.

## Usage

The container can be either used as a simple headless wallet or a **masternode** only the options used
in the *command* will differ.

> **Pro Tip:** This repository can be used as is or you can fork it to create your specific wallet implementation.
> Check for [existing wallet implementation](#Wallet-implementations) before creating a new one:

### Headless wallet

1. First build the *container* with the *arguments* that suit your wallet:
```
git clone git@github.com:LePetitBloc/walletd.git
cd walletd
docker build -t mywallet --build-arg WALLET="mywallet" --build-arg REPOSITORY="https://github.com/coin/mywallet.git" .
```
> **Note 1:** Usually the base name of the *wallet binary* and the *repository* is sufficient for any **masternode** coin.

> **Note 2:** It is not required to `clone` the repository you can just specify the location of the dockerfile at the end:
>
> `docker build -t mywallet --build-arg WALLET="mywallet" --build-arg REPOSITORY="https://github.com/coin/mywallet.git" . https://github.com/LePetitBloc/walletd.git`

2. Run the container and specify at least the `rpcuser` and `rpcpassword` to interact with the wallet daemon:
```
docker run wallet -rpcuser=walletrpc -rpcpassword=4VvDhcoqFUcZbmkWUMJz8P443WLfoaMmiREKSByJaT4j
```
> We recommend mounting a volume for easier access to the *data* and the *configuration*.
> `docker run wallet -v ./wallet:/home/wallet/ -rpcuser=walletrpc -rpcpassword=4VvDhcoqFUcZbmkWUMJz8P443WLfoaMmiREKSByJaT4j`

> :warning: Make sur the host directory contains at least an empty, *writable* `data` directory.

### Headless control wallet and masternode

The easiest way to setup **both** at the same is to use `docker-compose`.
Check the provided `docker-compose.yml` as an example and tweak it to your needs!

Then just run:
```
docker-compose up --build
```

> **Pro Tip:** Check the next section for available implementations, that will save you the build step, compose will
just have to pull the images.

## Wallet implementations

Quite a few **masternode** coin wallets are already available as pre-configured *images* and `docker-compose` files:

* Artax https://github.com/LePetitBloc/artaxd
* Sparks https://github.com/LePetitBloc/sparksd
* Goa https://github.com/LePetitBloc/goad
* *Fork this repository, tweak it to suit your needs and get in touch to be referenced here!*

## Parent image
- Berkeley DB v5.3.28.NC
`FROM lepetitbloc/bdb:5.3.28.NC`
> https://github.com/LePetitBloc/bdb/tree/5.3.28.NC
> https://hub.docker.com/r/lepetitbloc/bdb/

## Licence
MIT
