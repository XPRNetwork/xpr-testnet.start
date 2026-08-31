# Welcome to the XPR Network Testnet [Validator Node Installation]

Chain ID: `71ee83bcf52142d61019d95f9cc5427ba6a0d7ff8accd9e2088ae2abeaf3d3dd`

Please join our [XPR Network Testnet Telegram channel](https://t.me/XPRNetwork/935112)
Testnet Explorer: https://testnet.explorer.xprnetwork.org/

## Temporary Pause on New Block Producer Submissions

XPR Network is temporarily pausing new Block Producer submissions while the network completes its transition to PulseVM.

This is a precautionary measure to protect network stability during a critical protocol upgrade. The transition will be handled by established Block Producers with demonstrated production, upgrade, monitoring, recovery, and incident-response experience.

During the pause:

- No new BP Testnet or Mainnet onboarding applications will be accepted.
- No new `regprod` permissions will be issued for BP candidates.
- Existing active Block Producers and non-BP Testnet node operators are unaffected.
- Current applicants will be contacted directly regarding their status.

The Consortium will use this period to complete the PulseVM transition and finalise strengthened BP admission standards covering manual KYB/KYC, sanctions screening, technical competency, operational accountability, and ecosystem contribution.

New BP submissions will reopen once PulseVM is deployed, stable, and the XPR Network Consortium has formally approved the reopening of onboarding.

Thank you for your understanding and for supporting a secure, reliable XPR Network.

## Block Producer eligibility — complete this before Testnet

This repository may be used to operate a general Testnet node. However, **you must not attempt to join Testnet as a Block Producer, request `regprod` permission, register as a producer, or request BP onboarding support until you have completed the following mandatory eligibility steps:**

1. Read [How to Become a Block Producer on the XPR Network](https://xprnetwork.org/blog/how-to-become-a-block-producer-on-the-xpr-network) in full.
2. Complete required KYC verification. Applicants operating as or through a business must also pass the XPR Network Consortium's manual Know Your Business (KYB) review. A legally registered business is preferred but not required: individuals and sole traders may apply if they can be properly verified by KYC, demonstrate a verifiable online professional presence and operational control, and show proven IT experience operating servers. Business applicants must provide their business registration or equivalent official identifier, the person authorised to bind the business, ultimate beneficial ownership, and operational control information. This is required **before any BP Testnet access is granted**.
3. After KYC and, where applicable, KYB approval, pass the XPR Network Operator Competency Assessment.

All BP applicants must read and sign the [XPR Network BP Code of Conduct v1.0](https://github.com/XPRNetwork/xpr.start/blob/master/XPR%20Network%20BP%20Code%20of%20Conduct%20v1.0.pdf).

Only applicants that have passed these pre-Testnet requirements may proceed with BP Testnet onboarding. Completion of the Testnet period does not guarantee Mainnet approval.

This repo is for binary installation!

**XPR Network is a protocol built on top of the Antelope (EOSIO) consensus layer that allows verified user identity and applications to generate signature requests (transactions) that can be pushed to signers (wallets) for authentication and signature creation. These signature requests can be used today to authenticate and sign cryptographic payments. The same architecture will be used in future version to initiate and track pending fiat transactions**

To start a XPR Network node you need install Leap software. You can compile from sources or install from precompiled binaries:  

## Important Update

> [!IMPORTANT] 
> XPR Network Consortium is requesting all Block Producers to update their nodes to the latest version of Leap (5.0.3). This update is required to ensure the stability of the XPR Network TestNet.

Please contact us on Telegram if you have any questions: [https://t.me/XPRNetwork/935112](https://t.me/XPRNetwork/935112)


---------------------------------------------------  

Make sure you have Ubuntu 22.04 or later installed. (Check OS version by using this command `lsb_release -a`)

# 1. Installing from precompiled binaries

A. Download the latest version of Antelope Leap for your OS from:
[https://github.com/AntelopeIO/leap/releases/latest
](https://github.com/AntelopeIO/leap/releases/latest)

To install it you can use apt, but before that download it using wget command:
```
wget $(curl -s https://api.github.com/repos/AntelopeIO/leap/releases/latest | grep "browser_download_url" | cut -d '"' -f 4 | grep -E "leap_.*_amd64\.deb$")
```
Once the package is downloaded, install it using the command:
```
sudo apt install ./$(ls | grep -E "leap_.*_amd64\.deb$")
```
It will download all dependencies and install Leap. 

---------------------------------------------------------  
# 2. Update software to new version  

When upgrading from older versions of 2.X, 3.X or 4.X, simply use the commands above having previously stopped your nodes.

------------------------------------------------------------------  

# 3. Install XPR Network Testnet node [manual]  

> [!IMPORTANT] 
> ⚠️ **Critical information**: NEVER open access to a server with producer type node (where `eosio::producer_plugin` is active) from outside! 
If you want to get access for some service tasks - use a firewall `sudo ufw status` configured on this server, having previously opened the necessary ports only for certain IP addresses from which you will connect for service work.
If firewall is not installed, install it:
`sudo apt update`
`sudo apt install ufw`
As an example, open SSH (port 22) for the IP address (192.168.1.100 - replace it with your own!) from which the administrator will connect for maintenance `sudo ufw allow from 192.168.1.100 to any port 22` Then activate the firewall `sudo ufw enable`

```
mkdir -p /opt/XPRTestNet && cd /opt/XPRTestNet && git clone https://github.com/XPRNetwork/xpr-testnet.start.git ./
```

- In case you use a different data-dir folders -> edit all paths in files cleos.sh, start.sh, stop.sh, config.ini, Wallet/start_wallet.sh, Wallet/stop_wallet.sh  

-  to create an account on XPR Network test network go to <a target="_blank" href="https://testnet.webauth.com/">testnet.webauth.com</a> create your account, use 000000 for the email activation code. You can get your private key by going to settings > backup private key.
-  There is also an option to create account by using <a target="_blank" href="https://testnet.explorer.xprnetwork.org/wallet/create-account/advanced">Testnet Explorer</a>, only that here you will need to pay for ram fee (6.66 XPR).
- If non BP node: use the same config, just comment out rows with `producer-name` and `signature-provider` 
  
- Edit config.ini:  
  - server address: `p2p-server-address = EXTERNAL_IP_ADDRESS:OPENED_PORT`
  - > ⚠️ **IMPORTANT!** Please pay attention!
In order for your node to synchronize successfully and fastest with the blockchain, you need P2P nodes sorted by latency relative to your server, for this purpose use the [get_p2p_nodes.sh](xprNode/get_p2p_nodes.sh) script by making it executable `chmod +x /opt/XPRTestNet/xprNode/get_p2p_nodes.sh` then run it `opt/XPRTestNet/xprNode/get_p2p_nodes.sh`.

  - > After that, a file `available_nodes.txt` will be created in the `/opt/XPRTestNet/xprNode` folder, in it you will find a sorted list of active p2p nodes that you need to copy to the `/opt/XPRTestNet/xprNode/config.ini` file after removing `p2p-peer-address = ...` lines if exist.
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
   Download the latest snapshot from https://snapshots.bloxprod.io/testnet/ to the snapshots folder in your **NODE** directory.
   ```
   mkdir /opt/XPRTestNet/xprNode/snapshots
   cd /opt/XPRTestNet/xprNode/snapshots/
   wget https://snapshots.bloxprod.io/testnet/latest-snapshot.bin
   ```
   
   After the download completes, run the `start.sh` script with the `--snapshot` option and the snapshot file path.
   ```
   cd /opt/XPRTestNet/xprNode
   ```

   before starting from snapshot make sure to delete /blocks and /state folders
   ```
   rm -rf blocks/*
   rm -rf state/*
   ```

   run the `start.sh` script with the `--snapshot` option and the snapshot file path
   ```
   ./start.sh --snapshot /opt/XPRTestNet/xprNode/snapshots/latest-snapshot.bin
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

## XPR Network TESTNET P2P (Verified January 2026)

```
p2p-protontest.saltant.io:9879
testnet-p2p.alvosec.com:9878
proton-seed-testnet.eosiomadrid.io:9877
proton.testnet.protonuk.io:9876
p2p.testnet.totalproton.tech:9842
testnet.brotonbp.com:9877
p2p-xpr-test.danemarkbp.com:9876
tn1.protonnz.com:9876
xpr-testnet-p2p.bloxprod.io:9875
peer-xprtest.blocksforge.com:9876
test.proton.p2p.eosusa.io:19879
p2p.proton-testnet.genereos.io:9876
protontest.eu.eosamsterdam.net:9905
testnet-p2p.xprcore.com:9876
p2p-testnet.chaininfra.net:9876
testnet-p2p.xprdata.org:19876
proton-testnet.cryptolions.io:9874
testnet-p2p.cerebro.host:9876
testchain.simpleblock.org:9876
p2p-testnet.artwebin.com:19876
testnet-p2p.xprlabs.org:9870
tn1.cats.vote:9876
peer-protontest.nodeone.network:9871
testnet.proton.eosrio.io:58142
p2p-proton-testnet.cryptotribe.io:9877
p2p-test.turtlebp.online:19878
testxpr-p2p.cindro.net:9874
p2p-testnet-proton.eosarabia.net:9876
testnet-p2p.luminaryvisn.com:9876
p2p-xpr-testnet.a-dex.xyz:9876
proton-p2p-testnet.neftyblocks.com:19876
testnet.rockerone.io:9876
```

## XPR Network TESTNET API

```
https://proton-testnet.eosusa.io
https://test.proton.eosusa.io
https://testnet-api.alvosec.com
https://proton-testnet.cryptolions.io
https://testnet.protonuk.io
https://testnet.brotonbp.com
https://testnet-api.xprcore.com
https://testnet.proton.genereos.io
https://protontest.eu.eosamsterdam.net
https://api-xprnetwork-test.saltant.io
https://testnet-api.xprdata.org
https://testnet.rockerone.io
https://tn1.protonnz.com
```

# Backups
  
### Snapshot:
  * [Full State History Snapshots / BP Saltant](https://snapshots.saltant.io/testnet/)
  * [Snapshots & Full State History Snapshots / BP Bloxprod](https://snapshots.bloxprod.io/testnet/)
  * [Snapshots / BP ProtonNZ](https://tn1.protonnz.com/snapshots/)



--------------
