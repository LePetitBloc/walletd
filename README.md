# Cross Wallet Daemon (`walletd`)
Cross Wallet Daemon for headless wallets and **masternodes**.

## Usage
The container can either be used as a classic headless wallet or a **masternode**, only the *command* arguments will differ.

### Headless wallet
1. Build the *container* with the *arguments* that suit your wallet:
```
git clone git@github.com:LePetitBloc/walletd.git
cd walletd
docker build -t mywallet --build-arg WALLET="mywallet" --build-arg REPOSITORY="https://github.com/coin/mywallet.git" .
```
> **Note 1:** Usually the base name of the *wallet binary* and the *repository* is sufficient for any **masternode** coin.

> **Note 2:** It is not required to `clone` the repository you can just specify the location of the dockerfile at the end:
>
> `docker build -t mywallet --build-arg WALLET="mywallet" --build-arg REPOSITORY="https://github.com/coin/mywallet.git" . https://github.com/LePetitBloc/walletd.git`

2. Run a **wallet** container and specify at least the `rpcuser` and `rpcpassword` to interact with the **Wallet** daemon:
```
docker run --name wallet wallet -rpcuser=walletrpc -rpcpassword=4VvDhcoqFUcZbmkWUMJz8P443WLfoaMmiREKSByJaT4j
```
> We recommend to mount a volume for easier access to the *data* and the *configuration* files.
> You should also create a configuration for your RPC credentials (see `wallet/conf/wallet.conf`) to avoid retyping them when using the internal `wallet-cli`.
> ```
> docker run --name wallet -v ./wallet:/home/wallet/ wallet
> ```

> :warning: Ensure that a `data` directory **exists** and is **writable** in the mounted host directory.

3. Once your wallet is running, you can print your main address:
```
docker exec wallet wallet-cli getaccountaddress ""
```
> GK92mbjS9bCAUuU7DEyyuK9US1qLqkoyce

4. **Encrypt your wallet:**
> You can use `pwgen` first to generate your *passphrase*:
> ```
> pwgen 32 1
> ```
> quohd4kaw9guvi8ie7phaighawaiLoo6
```
docker exec wallet wallet-cli encryptwallet quohd4kaw9guvi8ie7phaighawaiLoo6
```
> Wallet encrypted; Wallet Core server stopping, restart to run with encrypted wallet. The keypool has been flushed, you need to make a new backup.

:ocean: Don't forget to **backup** your *passphrase*.

### Masternode

#### Prerequisites
1. You must have received *1000 GOA* on your **wallet** in a **single transaction**, and **must** have waited for, at least, **1 confirmation**.
> **Note1:** If the *1000 GOA* came from multiple transactions, you can send them back to yourself.

> **Note2:** Beware of the transaction cost, you should own *1001 GOA* as a safety measure.

2. Only then you may find the corresponding transaction `hash` and `index` :
```
docker exec wallet wallet-cli masternode outputs
```
>```
>{
>  "8e835a7d867d335434925c32f38902268e131e99a5821557d3e77f8ca3829fd8" : "0"
>}
>```

3. Then generate a **masternode** private key:
```
masternode genkey
```
>```
>7ev3RXQXYfztreEz8wmPKgJUpNiqkAkkdxt24C3ZKtg5qEVfou9
>```

4. And finally creates the `./wallet/conf/masternode.conf` file, and fill in following this template:
> `mn01 masternode:21529 YouMasterNodePrivateKey TransactionHash 0 YourWalletAddress:100`
```
touch ./wallet/conf/masternode.conf
```

#### Setup
1. As a classic wallet, you should create a `masternode/conf/wallet.conf` configuration file
```
rpcuser=walletrpc
rpcpassword=4VvDhcoqFUcZbmkWUMJz8P443WLfoaMmiREKSByJaT4j
```

2. Run a container as a **masternode**:
```
docker run --name masternode -v ./masternode:/home/wallet/ wallet -masternode=1 -masternodeprivkey=YourMasternodePrivKey -addnode=54.37.74.53
```

2. Check the status until the masternode is started:
```
docker exec masternode wallet-cli getinfo
```
> **Pro Tip:** Check the next section for available implementations, that will save you the build step, compose will
just have to pull the images.

## docker-compose
You could setup **both** at the same time using `docker-compose`.
Check the provided `docker-compose.yml` as an example and tweak it to your needs!
```
docker-compose up --build
```

## Wallet implementations
Quite a few **masternode** coin wallets are already available as pre-configured *images* and `docker-compose` files:
* Artax https://github.com/LePetitBloc/artaxd
* Sparks https://github.com/LePetitBloc/sparksd
* Goacoin https://github.com/LePetitBloc/goacoind
* *Fork this repository, tweak it to suit your needs and get in touch to be referenced here!*

## Compatible JSON-RPC clients
Most of the **masternode** coins are based on **Dash** so any Dash client would do.
* Promise based Javascript client: [dashd-client](https://github.com/LePetitBloc/dashd-client)
> See [Dash RPC commands](https://dashpay.atlassian.net/wiki/spaces/DOC/pages/131924073/RPC+commands) for a list of all available commands.

## Parent image
- Berkeley DB v5.3.28.NC
`FROM lepetitbloc/bdb:5.3.28.NC`
> https://github.com/LePetitBloc/bdb/tree/5.3.28.NC
> https://hub.docker.com/r/lepetitbloc/bdb/

## Licence
MIT
