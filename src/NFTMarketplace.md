## 安装依赖
```bash
forge install smartcontractkit/chainlink-brownie-contracts

vim foundry.toml
remappings = [
    '@chainlink/contracts/=lib/chainlink-brownie-contracts/contracts/',
]
````
## 编译
```bash
forge build src/NFTMarketplaceV1.sol
````
````bash
[⠊] Compiling...
[⠒] Compiling 1 files with Solc 0.8.33
[⠢] Solc 0.8.33 finished in 60.08ms
Compiler run successful!
````

## 部署拍卖合约V1，返回合约地址：0xb39a9Fbd34813087DF5a28E85d565163E1dFdF7C
```bash
forge script script/DeployNFTMarketplace.s.sol:DeployNFTMarketplaceV1 \
    --rpc-url $SEPOLIA_URL \
    --broadcast \
    --sender $ADDRESS \
    --account deployer \
    -vvvvv
````
````bash
[⠊] Compiling...
[⠒] Files to compile: - script/DeployNFTMarketplace.s.sol
[⠑] Compiling 1 files with Solc 0.8.33
[⠘] Solc 0.8.33 finished in 484.25ms
Compiler run successful!

Traces:
  [3904163] DeployNFTMarketplaceV1::run()
    ├─ [0] VM::envUint("PRIVATE_KEY") [staticcall]
    │   └─ ← [Return] <env var value>
    ├─ [0] VM::envAddress("FEE_RECIPIENT") [staticcall]
    │   └─ ← [Return] <env var value>
    ├─ [0] VM::envAddress("ETH_USD_PRICE_FEED") [staticcall]
    │   └─ ← [Return] <env var value>
    ├─ [0] VM::envAddress("ERC20_USD_PRICE_FEED") [staticcall]
    │   └─ ← [Return] <env var value>
    ├─ [0] VM::startBroadcast(<pk>)
    │   └─ ← [Return]
    ├─ [3855347] → new NFTMarketplaceV1@0xb39a9Fbd34813087DF5a28E85d565163E1dFdF7C
    │   └─ ← [Return] 18697 bytes of code
    ├─ [0] VM::stopBroadcast()
    │   └─ ← [Return]
    ├─ [0] console::log("Contract deployed at:", NFTMarketplaceV1: [0xb39a9Fbd34813087DF5a28E85d565163E1dFdF7C]) [staticcall]
    │   └─ ← [Stop]
    └─ ← [Return] NFTMarketplaceV1: [0xb39a9Fbd34813087DF5a28E85d565163E1dFdF7C]
Script ran successfully.

== Return ==
0: contract NFTMarketplaceV1 0xb39a9Fbd34813087DF5a28E85d565163E1dFdF7C

== Logs ==
  Contract deployed at: 0xb39a9Fbd34813087DF5a28E85d565163E1dFdF7C

## Setting up 1 EVM.
==========================
Simulated On-chain Traces:
  [3855347] → new NFTMarketplaceV1@0xb39a9Fbd34813087DF5a28E85d565163E1dFdF7C
    └─ ← [Return] 18697 bytes of code

==========================
Chain 11155111
Estimated gas price: 0.00100002 gwei
Estimated total gas used for script: 5470760
Estimated amount required: 0.0000054708694152 ETH

==========================
Enter keystore password:

##### sepolia
✅  [Success] Hash: 0x8a31bc26c51eeb236bbbf5d7a17843c15ab3ab043b624a28f129311aacafb56f
Contract Address: 0xb39a9Fbd34813087DF5a28E85d565163E1dFdF7C
Block: 10475711
Paid: 0.00000420831908277 ETH (4208277 gas * 0.00100001 gwei)

✅ Sequence #1 on sepolia | Total Paid: 0.00000420831908277 ETH (4208277 gas * avg 0.00100001 gwei)
                                                                                                                                                     
==========================
ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.
Transactions saved to: /home/shicw/project/nft_auction_foundry/broadcast/DeployNFTMarketplace.s.sol/11155111/run-latest.json
Sensitive values saved to: /home/shicw/project/nft_auction_foundry/cache/DeployNFTMarketplace.s.sol/11155111/run-latest.json
````
## 
```bash

````
````bash

````
## 
```bash

````
````bash

````
## 
```bash

````
````bash

````
## 
```bash

````
````bash

````
## 
```bash

````
````bash

````
## 
```bash

````
````bash

````

