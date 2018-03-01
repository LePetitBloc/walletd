# Setup a GUI Wallet and a distant **masternode**

These steps will guide you through the setup of a GUI **Control Wallet** and a **masternode**.

### Prerequisites
1. You must have a wallet installed and synced (on your local machine for instance),
i.e. the **Control Wallet**.

2. You must receive the *required number of tokens* for the **masternode** in a single transaction on your **Control Wallet** and wait for at least 1 confirmation.
> **Note1:** If you already have the *required number of tokens* but it came from multiple transactions, you can send the *required number of tokens* to yourself.

> **Note2:** Beware of the transaction cost, you should own the *required number of tokens plus 1* as a safety measure.

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
2. Edit `~/.Wallet/masternode.conf`
```
mn01 YOUR.SERVER.IP:21527 YouMasterNodePrivateKey TransactionHash TransactionIndex YourWalletAddress:100
```
3. Save and exit

### Setup the **masternode**
These steps consist in setting up the machine which will run the **masternode**:

1. Install Docker:
> https://docs.docker.com/install/
> https://docs.docker.com/v17.09/engine/installation/linux/linux-postinstall/

2. Create a `wallet` folder :
> where `wallet` is the name of your wallet.
```
mkdir -p ~/wallet/data
```

3. Build the image:
```
docker build -t wallet --build-arg WALLET="wallet" --build-arg REPOSITORY="https://github.com/coin/wallet.git" .
```

4. Create the required `data` directory and run the image:
```
mkdir data
docker run --rm -p 21527:21527 -p 21528:21528 -h wallet-mn01 --name wallet-mn01 -v ~/wallet/data:/home/wallet/data -v ~/wallet/conf:/home/wallet/conf wallet -server=0 -masternode=1 -masternodeprivkey=YourMasternodePrivKey -addnode=0.0.0.0:0
```