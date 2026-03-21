
## 编译、部署代理合约，返回代理合约地址：0xbd51271726335597F6562D25F0B267344C2361FE
```bash
forge script script/DeploySimpleProxy.s.sol:DeploySimpleProxy \
    --rpc-url $SEPOLIA_URL \
    --broadcast \
    --sender $ADDRESS \
    --account deployer \
    -vvvvv
````
````bash
[⠊] Compiling...
[⠒] Files to compile:
- lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol
- lib/forge-std/src/Base.sol
- lib/forge-std/src/Script.sol
- lib/forge-std/src/StdChains.sol
- lib/forge-std/src/StdCheats.sol
- lib/forge-std/src/StdConstants.sol
- lib/forge-std/src/StdJson.sol
- lib/forge-std/src/StdMath.sol
- lib/forge-std/src/StdStorage.sol
- lib/forge-std/src/StdStyle.sol
- lib/forge-std/src/StdUtils.sol
- lib/forge-std/src/Vm.sol
- lib/forge-std/src/console.sol
- lib/forge-std/src/console2.sol
- lib/forge-std/src/interfaces/IMulticall3.sol
- lib/forge-std/src/safeconsole.sol
- lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/access/Ownable.sol
- lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/interfaces/IERC165.sol
- lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/interfaces/IERC4906.sol
- lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/interfaces/IERC721.sol
- lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/interfaces/draft-IERC6093.sol
- lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol
- lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol
- lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol
- lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol
- lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Metadata.sol
- lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/token/ERC721/utils/ERC721Utils.sol
- lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/Bytes.sol
- lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/Context.sol
- lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/Panic.sol
- lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol
- lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol
- lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/Strings.sol
- lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol
- lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol
- lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol
- lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/SafeCast.sol
- lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/SignedMath.sol
- script/DeploySimpleProxy.s.sol
- src/MyNFT.sol
- src/NFTMarketplaceV1.sol
- src/SimpleProxy.sol
[⠘] Compiling 42 files with Solc 0.8.33
[⠃] Solc 0.8.33 finished in 631.94ms
Compiler run successful with warnings:
Warning (9207): 'transfer' is deprecated and scheduled for removal. Use 'call{value: <amount>}("")' instead.
   --> src/MyNFT.sol:102:9:
    |
102 |         payable(owner()).transfer(balance);
    |         ^^^^^^^^^^^^^^^^^^^^^^^^^
Traces:
  [628249] DeploySimpleProxy::run()
    ├─ [0] VM::envUint("PRIVATE_KEY") [staticcall]
    │   └─ ← [Return] <env var value>
    ├─ [0] VM::envAddress("NFTMARKETPLACEV1") [staticcall]
    │   └─ ← [Return] <env var value>
    ├─ [0] VM::startBroadcast(<pk>)
    │   └─ ← [Return]
    ├─ [586341] → new SimpleProxy@0xbd51271726335597F6562D25F0B267344C2361FE
    │   └─ ← [Return] 2595 bytes of code
    ├─ [0] VM::stopBroadcast()
    │   └─ ← [Return]
    ├─ [0] console::log("Contract deployed at:", 0xb39a9Fbd34813087DF5a28E85d565163E1dFdF7C) [staticcall]
    │   └─ ← [Stop]
    └─ ← [Return] SimpleProxy: [0xbd51271726335597F6562D25F0B267344C2361FE]
Script ran successfully.

== Return ==
0: contract SimpleProxy 0xbd51271726335597F6562D25F0B267344C2361FE

== Logs ==
  Contract deployed at: 0xb39a9Fbd34813087DF5a28E85d565163E1dFdF7C

## Setting up 1 EVM.
==========================
Simulated On-chain Traces:
  [586341] → new SimpleProxy@0xbd51271726335597F6562D25F0B267344C2361FE
    └─ ← [Return] 2595 bytes of code


==========================
Chain 11155111
Estimated gas price: 0.00100002 gwei
Estimated total gas used for script: 890914
Estimated amount required: 0.00000089093181828 ETH

==========================
Enter keystore password:

##### sepolia
✅  [Success] Hash: 0x941c56e468b9ef24fb96e51ec87a0fca6740a392b0be7c9bc1e5b80982c8b792
Contract Address: 0xbd51271726335597F6562D25F0B267344C2361FE
Block: 10475781
Paid: 0.00000068532585319 ETH (685319 gas * 0.00100001 gwei)

✅ Sequence #1 on sepolia | Total Paid: 0.00000068532585319 ETH (685319 gas * avg 0.00100001 gwei)
                                                                                                                                                         
==========================
ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.
Transactions saved to: /home/shicw/project/nft_auction_foundry/broadcast/DeploySimpleProxy.s.sol/11155111/run-latest.json
Sensitive values saved to: /home/shicw/project/nft_auction_foundry/cache/DeploySimpleProxy.s.sol/11155111/run-latest.json
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