# Artax Daemon (`artaxd`)

[![Docker Build Status](https://img.shields.io/docker/build/lepetitbloc/artax.svg)][hub]
[![Docker Stars](https://img.shields.io/docker/stars/lepetitbloc/artax.svg)][hub]
[![Docker Pulls](https://img.shields.io/docker/pulls/lepetitbloc/artax.svg)][hub]

Artax Daemon for headless wallet and masternode.

## Usage

### Prerequisites
1. You must have a wallet installed and synced (on your local machine for instance),
i.e. the **Control Wallet**.
> This part is not covered here but you can find the appropriate instructions there https://github.com/Artax-Project/Artax/blob/master/doc/readme-qt.rst

2. You must receive the required 2500 ARTX in a single transaction on your **Control Wallet** and wait for at least 1 confirmation.
> **Note1:** If you already have the 2500 ARTX but it came from multiple transactions, you can send the 2500 ARTX to yourself.

> **Note2:** Beware of the transaction cost of `0.000001` ARTX, you should own 2501 ARTX as a safety measure.

### Setup the **Control Wallet**

1. Generate the **masternode** private key via the *Debug console*:
`masternode genkey`

The output looks as follow:
```
64o98ohh4hEA14FXdMbdV5FeH2QKe4ntv6c9mR3EenM5g9VYYWS
```
Keep this value somewhere.

2. Find the transaction `hash` and `index` with the following command via the *Debug console*:
```
masternode outputs
```

The output should looks as follow:
```
{
  "8e835a7d867d335434925c32f38902268e131e99a5821557d3e77f8ca3829fd8" : "0"
}
```
Keep this output somewhere.

#### Prepare the **Masternode** configuration
1. Close your **Control Wallet**
2. Edit `~/.Artax/masternode.conf`
```
mn01 YOUR.SERVER.IP:21527 YouMasterNodePrivateKey TransactionHash TransactionIndex YourWalletAddress:100
```
3. Save and exit

### Setup the **masternode**
These steps consist in setting up the machine which will run the **masternode**:

1. Install Docker:
> https://docs.docker.com/install/
> https://docs.docker.com/v17.09/engine/installation/linux/linux-postinstall/

2. Create an `artax` folder:
```
mkdir ~/artax
```

3. Create the configuration file `~/artax/conf/wallet.conf` based on [the provided configuration template](conf/wallet.conf),
change the `rpcpassord` and fill the `masternodeprivkey` key with your **masternode** private key.

4. Run the image:
```
docker run --rm -p 21527:21527 -p 21528:21528 -h artax-mn01 --name artax-mn01 -v ~/artax/data:/home/artax/data -v ~/artax/conf:/home/artax/conf lepetitbloc/artax
```

> If you get the following error:
> ```
> ************************
> EXCEPTION: N5boost12interprocess22interprocess_exceptionE
> No such file or directory
> Artax in AppInit()
>
>terminate called after throwing an instance of 'boost::interprocess::interprocess_exception'
>  what():  No such file or directory
>
>
>************************
>EXCEPTION: N5boost12interprocess22interprocess_exceptionE
>No such file or directory
>Artax in AppInit()
>```
> Make sure the `data` folder is *writable* for the container.

### Start your **masternode** from your **Control wallet**
Get back to your **Control wallet** **unlock it** and start your **masternode**.

## Parent image
- Berkeley DB v5.3.28.NC
`FROM lepetitbloc/bdb:5.3.28.NC`
> https://github.com/LePetitBloc/bdb/tree/5.3.28.NC
> https://hub.docker.com/r/lepetitbloc/bdb/

## Resources
- https://bitcointalk.org/index.php?topic=2770033.0
- https://github.com/Artax-Project/Artax

## Licence
MIT

[hub]: https://hub.docker.com/r/lepetitbloc/artax/