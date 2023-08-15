# Welcome to the PROTON Testnet [manual node installation]

Chain ID: `71ee83bcf52142d61019d95f9cc5427ba6a0d7ff8accd9e2088ae2abeaf3d3dd`
Based on tag: v4.0.4

Please join our <a target="_blank" href="https://t.me/ProtonTestnet/">PROTON Testnet Telegram channel</a>  
Network Monitor: https://monitor.testnet.protonchain.com/  

P2P endpoints:
```
p2p-peer-address = testnet.protonchain.com:9876
p2p-peer-address = peer1-proton-testnet.eosphere.io:9876
p2p-peer-address = peer.protontest.alohaeos.com:9876
p2p-peer-address = protontestnet.greymass.com:59876
p2p-peer-address = p2p-testnet-proton.eosarabia.net:9876
p2p-peer-address = testnet.proton.eosdetroit.io:1337
p2p-peer-address = proton-bp.dmail.co:7676
p2p-peer-address = test.proton.eosusa.news:19889
p2p-peer-address = protonp2p-testnet.eoscafeblock.com:9130
p2p-peer-address = proton-testnet.eosio.cr:9878
p2p-peer-address = p2p.alvosec.com:9876
p2p-peer-address = p2p-protonmain.saltant.io:9876

```

This repo is for binary installation!

**Proton is a protocol built on top of the Antelope (EOSIO) consensus layer that allows verified user identity and applications to generate signature requests (transactions) that can be pushed to signers (wallets) for authentication and signature creation. These signature requests can be used today to authenticate and sign cryptographic payments. The same architecture will be used in future version to initiate and track pending fiat transactions**

To start a Proton node you need install Leap software. You can compile from sources or install from precompiled binaries:  

## Important Update

Proton Consortium is requesting all Block Producers to update their nodes to the latest version of Leap (4.0.4) by 30 August 2023. This update is required to ensure the stability of the Proton Testnet.

Please contact us on Telegram if you have any questions: https://t.me/ProtonTestnet

To start a Proton TestNet node you need install EOSIO software. You can compile from sources or install from precompiled binaries:  

# 1. Installing  
---------------------------------------------------  

Make sure you have Ubuntu 22.04 installed.

# 1 Installing from precompiled binaries

A. Download the latest version of Antelope Leap for your OS from:
[https://github.com/AntelopeIO/leap/releases/tag/v4.0.4
](https://github.com/AntelopeIO/leap/releases/tag/v4.0.4)

For example, for Ubuntu 22.04 you need to download deb leap_4.0.4-ubuntu22.04_amd64.deb            
To install it you can use apt, but before that download it using wget command:
```
wget https://github.com/AntelopeIO/leap/releases/download/v4.0.4/leap_4.0.4-ubuntu22.04_amd64.deb
apt install ./leap_4.0.4-ubuntu22.04_amd64.deb 
```
It will download all dependencies and install Leap  

---------------------------------------------------------  
# 2. Update software to new version  

If upgrading from old 2.X or 3.X versions please see this important guide 
https://eosnetwork.com/blog/leap-3-1-upgrade-guide/

```
apt install ./leap_4.0.4-ubuntu22.04_amd64.deb 
```

------------------------------------------------------------------  

# 3. Install PROTON Testnet node [manual]  
    
```
    mkdir /opt/ProtonTestnet
    cd /opt/ProtonTestnet
    git clone https://github.com/ProtonProtocol/proton-testnet.start.git ./

```

- In case you use a different data-dir folders -> edit all paths in files cleos.sh, start.sh, stop.sh, config.ini, Wallet/start_wallet.sh, Wallet/stop_wallet.sh  

-  to create an account on Proton test network go to <a target="_blank" href="https://monitor.testnet.protonchain.com/">monitor</a>  
  Click <a target="_blank" href="https://monitor.testnet.protonchain.com/#createKey">“Create Keypair”</a> button located at the top left of the page, copy and save both public and private key.
  also you can create key pair using cleos command  
  `./cleos.sh create key`  
  next Click <a target="_blank" href="https://monitor.testnet.protonchain.com/#account">“Create Account”</a> at the top left of the page, enter an account name, submit your previously saved public key in both Owner and Active Public Key field, complete the captcha, and hit create.
  
- If non BP node: use the same config, just comment out rows with producer-name and signature-provider  
  
- Edit config.ini:  
  - server address: p2p-server-address = ENTER_YOUR_NODE_EXTERNAL_IP_ADDRESS:9876  
  - replace p2p-peer-address list with fresh generated on monitor site: https://monitor.testnet.protonchain.com/#p2p  
  - Check chain-state-db-size-mb value in config, it should be not bigger than you have RAM:  
    chain-state-db-size-mb = 16384  

  - if BP: your producer name: producer-name = YOUR_BP_NAME  
  - if BP: add producer keypair for signing blocks (this pub key should be used in regproducer action):  
  signature-provider = YOUR_PUB_KEY_HERE=KEY:YOUR_PRIV_KEY_HERE  
  - if BP: comment out eos-vm-oc-enable and eos-vm-oc-compile-threads (EOSVM OC is not to be used on a block signing node) 

- To register as Block Producer, run command    :
  ```
  ./cleos.sh system regproducer YOU_ACCOUNT PUBKEY "URL" LOCATION -p YOU_ACCOUNT
  ```
  

- Open TCP Ports (8888, 9876) on your firewall/router  

- Start wallet, run  
```
cd /opt/ProtonTestnet
./Wallet/start_wallet.sh  
```

**First run should be with --delete-all-blocks and --genesis-json**  
```
./start.sh --delete-all-blocks --genesis-json genesis.json
```  
Check logs stderr.txt if node is running ok. 


- Create your wallet file  
```
./cleos.sh wallet create --file pass.txt
```
Your password will be in pass.txt it will be used when unlock wallet  


- Unlock your wallet  
```
./cleos.sh wallet unlock  
```
enter the wallet password.  


- Import your key  
```
./cleos.sh wallet import
```
Enter your private key  



Check if you can access you node using link http://you_server:8888/v1/chain/get_info (<a href="https://testnet.protonchain.com/v1/chain/get_info" target="_blank">Example</a>)  


==============================================================================================  

# 4.1 Restore/Start from Backup
   Download latest block and state archive for your OS from http://backup.cryptolions.io/ProtonTestNet/
   
   ```
   wget http://backup.cryptolions.io/ProtonTestNet/ubuntu18/latest-blocks.tar.gz
   wget http://backup.cryptolions.io/ProtonTestNet/ubuntu18/latest-state.tar.gz
   ```
   After downloaded extract their
   ```
   tar xzvf blocks-latest.tar.gz -C .
   tar xzvf state-latest.tar.gz -C .
   ```
   You got two folders block and state.  
   Ater that go to **NODE** folder, and remove files from folder blocks and state
   ```
   cd /opt/ProtonTestnet/protonNode
   rm blocks/*
   rm state/*
   ```
   After that go where you extracted archive and move file from folder 
   ```
   mv ~/blocks/* /opt/ProtonTestnet/protonNode/blocks/
   mv ~/state/* /opt/ProtonTestnet/protonNode/state/
   ```
   After files moved start your NODE
   ```
   ./start.sh
   ```
# 4.2 Restore/Start from Snapshots
   Download latest snapshot from http://backup.cryptolions.io/ProtonTestNet/snapshots/ to snapshots folder in your **NODE** directory
   ```
   cd /opt/ProtonTestnet/protonNode/snapshots/
   wget http://backup.cryptolions.io/ProtonTestNet/snapshots/latest-snapshot.bin
   ```
   after it downloaded run `start.sh` script with option `--snapshot` and snapshot file path
   ```
   cd /opt/ProtonTestnet/protonNode
   ./start.sh --snapshot /opt/ProtonTestnet/protonNode/snapshots/latest-snapshot.bin
   ```


# 5. Usefull Information  
  
# Proton Faucet - get free XPR tokens:  
  https://monitor.testnet.protonchain.com/#faucet  

# Other Tools/Examples  

- Cleos commands:  

Send XPR
```
./cleos.sh transfer <your account> <receiver account> "1.0000 XPR" "test memo text"
```
Get Balance  
```
./cleos.sh get currency balance eosio.token <account name>
```

List registered producers (-l \<limit\>)  
```
./cleos.sh get table eosio eosio producers -l 100  
```

List staked/delegated  
```
./cleos.sh system listbw <account>   
```
 
# 6. Usefull Links

**Hyperion History**  
https://testnet.protonchain.com/v2/docs  
https://proton-testnet-hyperion.eoscafeblock.com/v2/docs
    
**Block Explorers**   
 https://testnet.protonscan.io

**LightAPI and State Track API**
here are all SimpleAssets and dGoods belonging to Jacob:
```
curl 'https://strack-dev.xeos.me/strack/tokens?network=protontest&account=jacob'
```

Here are all fungible tokens for the same user:
```
curl 'https://testnet-lightapi.eosams.xeos.me/api/account/protontest/jacob'
```
--------------  

# Backups
### Full(blocks and states):
  * [Ubuntu 18](http://backup.cryptolions.io/ProtonTestNet/ubuntu18/)  
  
### Snapshot:
  * [Snapshots](http://backup.cryptolions.io/ProtonTestNet/snapshots/)

--------------
