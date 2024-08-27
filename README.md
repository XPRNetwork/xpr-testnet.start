# Welcome to the XPR Network Testnet [Validator Node Installation]

Chain ID: `71ee83bcf52142d61019d95f9cc5427ba6a0d7ff8accd9e2088ae2abeaf3d3dd`
Based on tag: v4.0.4

Please join our [XPR Network Testnet Telegram channel](https://t.me/XPRNetwork/935112)
Testnet Explorer: https://testnet.explorer.xprnetwork.org/

P2P endpoints:
```
p2p-peer-address = tn1.protonnz.com:9876
p2p-peer-address = p2p-testnet-proton.eosarabia.net:9876
p2p-peer-address = testnet.proton.eosdetroit.io:1337
p2p-peer-address = proton-bp.dmail.co:7676
p2p-peer-address = test.proton.eosusa.news:19889
p2p-peer-address = protonp2p-testnet.eoscafeblock.com:9130
p2p-peer-address = proton-testnet.edenia.cloud:9878
p2p-peer-address = testnet-p2p.alvosec.com:9878
p2p-peer-address = p2p-protontest.saltant.io:9879
p2p-peer-address = protontest.eu.eosamsterdam.net:9905
```

This repo is for binary installation!

**XPR Network is a protocol built on top of the Antelope (EOSIO) consensus layer that allows verified user identity and applications to generate signature requests (transactions) that can be pushed to signers (wallets) for authentication and signature creation. These signature requests can be used today to authenticate and sign cryptographic payments. The same architecture will be used in future version to initiate and track pending fiat transactions**

To start a XPR Network node you need install Leap software. You can compile from sources or install from precompiled binaries:  

## Important Update

> [!IMPORTANT] 
> XPR Network Consortium is requesting all Block Producers to update their nodes to the latest version of Leap (4.0.4) by 30 October 2023. This update is required to ensure the stability of the XPR Network TestNet.

Please contact us on Telegram if you have any questions: [https://t.me/XPRNetwork/935112](https://t.me/XPRNetwork/935112)


---------------------------------------------------  

Make sure you have Ubuntu 22.04 installed. (Check OS version by using this command `lsb_release -a`)

# 1. Installing from precompiled binaries

A. Download the latest version of Antelope Leap for your OS from:
[https://github.com/AntelopeIO/leap/releases/tag/v4.0.4
](https://github.com/AntelopeIO/leap/releases/tag/v4.0.4)

For example, for Ubuntu 22.04 you need to download deb leap_4.0.4-ubuntu22.04_amd64.deb, note that Ubuntu 18.04 will not be any more supported in Leap.

To install it you can use apt, but before that download it using wget command:
```
wget https://github.com/AntelopeIO/leap/releases/download/v4.0.4/leap_4.0.4-ubuntu22.04_amd64.deb && apt install ./leap_4.0.4-ubuntu22.04_amd64.deb
```
It will download all dependencies and install Leap. 

---------------------------------------------------------  
# 2. Update software to new version  

If upgrading from old 2.X or 3.X versions please see this important guide 
https://eosnetwork.com/blog/leap-3-1-upgrade-guide/

```
apt install ./leap_4.0.4-ubuntu22.04_amd64.deb 
```

------------------------------------------------------------------  

# 3. Install XPR Network Testnet node [manual]  
    
```
mkdir -p /opt/XPRTestNet && cd /opt/XPRTestNet && git clone https://github.com/XPRNetwork/xpr-testnet.start.git ./
```

- In case you use a different data-dir folders -> edit all paths in files cleos.sh, start.sh, stop.sh, config.ini, Wallet/start_wallet.sh, Wallet/stop_wallet.sh  

-  to create an account on XPR Network test network go to <a target="_blank" href="https://testnet.webauth.com/">testnet.webauth.com</a> create your account, use 000000 for the email activation code. You can get your private key by going to settings > backup private key.
-  There is also an option to create account by using <a target="_blank" href="https://testnet.explorer.xprnetwork.org/wallet/create-account/advanced">Testnet Explorer</a>, only that here you will need to pay for ram fee (6.66 XPR).
- If non BP node: use the same config, just comment out rows with `producer-name` and `signature-provider` 
  
- Edit config.ini:  
  - server address: `p2p-server-address = EXTERNAL_IP_ADDRESS:9876`  
  - replace p2p-peer-address list from above in P2P list  
  - Check chain-state-db-size-mb value in config, it should be not bigger than you have RAM: `chain-state-db-size-mb = 16384`

  - if BP: your producer name: `producer-name = YOUR_BP_NAME`
  - if BP: generate a key pair for signing blocks (use the public key generated with the `cleos create key --to-console` command). Then, add this public key and its corresponding private key to the signature provider. Ensure that this key is not linked to your account keys and should be used exclusively for the regproducer action: `signature-provider = YOUR_PUB_KEY_HERE=KEY:YOUR_PRIV_KEY_HERE` 
  - if BP: comment out `eos-vm-oc-enable` and `eos-vm-oc-compile-threads` (EOSVM OC is not to be used on a block signing node)
  - set CPU governor to performance, first check current CPU governor by using this command `cpufreq-info` and then set to performance `sudo cpufreq-set -r -g performance`
  - use this command to watch current CPU clock speed `watch -n 0.4 "grep -E '^cpu MHz' /proc/cpuinfo"`
    
  - Before you register on Testnet you will need to get permission for `regprod`, you can copy this <a target="_blank" href="https://testnet.explorer.xprnetwork.org/msig/testalvosec/bkuib5">msig</a> (login with WebAuth or use cleos).

  - To register as Block Producer, run command and visit the testnet telegram channel [above](https://t.me/XPRNetwork/935112):
  ```
  cleos system regproducer YOU_ACCOUNT PUBKEY "URL" LOCATION -p YOU_ACCOUNT
  ```
  In this step, please provide your registered BP account, the public key you've included in the `signature-provider`, and specify the location using the ISO code for your country. You can find the ISO code for your country [here](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes).

- Open TCP Ports (8888, 9876) on your firewall/router  

- Start wallet, run  
```
cd /opt/XPRTestNet ; ./Wallet/start_wallet.sh 
```

**First run should be with --delete-all-blocks and --genesis-json**  
```
./start.sh --delete-all-blocks --genesis-json genesis.json
```  
Check logs stderr.txt if node is running ok, we can follow the logs like so.

```
tail -f stderr.txt
```
Ctrl + C to exit

>☝ Depending on your installation, you may experience issue with Keosd that not running (`is Keosd running ?`). That mean the keosd's path is not correct, edit the file in /opt/XPRTestNet/Wallet/start_wallet.sh to fix the path
```
nano /opt/XPRTestNet/Wallet/start_wallet.sh
```
If your `NODEOSBINDIR` has this dir:
```
#!/bin/bash

NODEOSBINDIR="/opt/XPRTestNet/Wallet/bin/bin"
DATADIR="/opt/XPRTestNet/Wallet"
WALLET_HOST="127.0.0.1"
WALLET_POSRT="3000"
```
Change the `NODEOSBINDIR` to `/usr/bin`, that shoud fix the problem (Thank to Andrey Salnikov)
***

- Create your wallet file  
```
cleos wallet create --file pass.txt
```
Your password will be in pass.txt it will be used when unlock wallet  


- Unlock your wallet  
```
cleos wallet unlock  
```
enter the wallet password.  


- Import your key  
```
cleos wallet import
```
Enter your private key  


Check if you can access you node using link http://you_server:8888/v1/chain/get_info (<a href="https://testnet.xprnetwork.org/v1/chain/get_info" target="_blank">Example</a>)  


==============================================================================================  

# 4. Restore/Start from Snapshots
   Download latest snapshot from http://backup.cryptolions.io/ProtonTestNet/snapshots/ to snapshots folder in your **NODE** directory
   ```
   cd /opt/XPRTestNet/xprNode/snapshots/ && wget http://backup.cryptolions.io/ProtonTestNet/snapshots/latest-snapshot.bin.zst
   ```
   after it downloaded you need to unzip, first install zstd package `sudo apt install zstd`

   unzip file with `unzstd latest-snapshot.bin.zst`

   before starting from snapshot make sure to delete /blocks and /state folders
    
    rm ./blocks/*
    rm ./state/*
    
   then `start.sh` script with option `--snapshot` and snapshot file path (check where you downloaded snapshot)
   
   ```
   cd /opt/XPRTestNet/xprNode && ./start.sh --snapshot /opt/XPRTestNet/xprNode/snapshots/latest-snapshot.bin
   ```


# 5. Usefull Information  
  
  XPR Network Faucet - get free XPR tokens:  
  [https://testnet.resources.xprnetwork.org/faucet](https://testnet.resources.xprnetwork.org/faucet)  

# Other Tools/Examples  

- Cleos commands:  

Send XPR
```
cleos transfer <your account> <receiver account> "1.0000 XPR" "test memo text"
```
Get Balance  
```
cleos get currency balance eosio.token <account name>
```

List registered producers (-l \<limit\>)  
```
cleos get table eosio eosio producers -l 100  
```

List staked/delegated  
```
cleos system listbw <account>   
```
Check account information
```
cleos get account <account-name>
```

# 6. Usefull Links
    
  * [WebAuth TestNet](https://testnet.webauth.com/)
  * [Metal X TestNet](https://testnet.app.metalx.com/swap)
  * [XPR Explorer TestNet](https://testnet.explorer.xprnetwork.org/)
  * [XPR Resources TestNet](https://testnet.resources.xprnetwork.org/faucet)
  * [Metal X Lending TestNet](https://testnet.lending.metalx.com/)

# Backups
  
### Snapshot:
  * [Snapshots](https://backup.cryptolions.io/ProtonTestNet/snapshots/)



--------------
