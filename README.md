# Artax Daemon (`artaxd`)

[![Docker Build Status](https://img.shields.io/docker/build/lepetitbloc/artax.svg)][hub]
[![Docker Stars](https://img.shields.io/docker/stars/lepetitbloc/artax.svg)][hub]
[![Docker Pulls](https://img.shields.io/docker/pulls/lepetitbloc/artax.svg)][hub]

Artax Daemon for headless wallet and masternode.

# Usage

## Prerequisites
1. You must have a wallet installed and sync (on your local machine for instance),
i.e. the **Control Wallet**.
> This part is not be covered here but you can find the appropriate instructions there https://github.com/Artax-Project/Artax/blob/master/doc/readme-qt.rst

2. You must have received the required 2500 ARTX in a single transaction transaction
on your **Control Wallet**.
> **Note1:** If you happend to already have the 2500 ARTX coming from multiple transactions, you can send the 2500 ARTX to yourself.

> **Note2:** Beware of the transaction cost of `0.000001` ARTX, you should 2501 ARTX as a safety measure.

## Setup the **masternode**
These steps consists in setting up the host machine which will run the **masternode**:

1. Create a dedicated user which is going to run the **masternode**:
```
groupadd -r artax
useradd --no-log-init -r -g artax artax
mkdir /home/artax
chown artax:artax /home/artax
```

2. Install Docker:
> https://docs.docker.com/install/

3. Run the image:
```
sudo docker run --rm -p 8890:8890 -h artax-mn01 --name artax-mn01 -v /home/artax:/sparks lepetitbloc/artax:latest
```

# Parent image
- Berkeley DB v5.3.28.NC
`FROM lepetitbloc/bdb:5.3.28.NC`
> https://github.com/LePetitBloc/bdb/tree/5.3.28.NC
> https://hub.docker.com/r/lepetitbloc/bdb/

# Resources
- https://bitcointalk.org/index.php?topic=2770033.0
- https://github.com/Artax-Project/Artax

# Licence
MIT

[hub]: https://hub.docker.com/r/lepetitbloc/artax/