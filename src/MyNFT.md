# MyNFT.sol
0xb50d51532941Df7C68c541D668647Ce8644f1616
## 编译
```bash
forge build src/MyNFT.sol
````
````bash
[⠊] Compiling...
[⠢] Compiling 1 files with Solc 0.8.33
[⠆] Solc 0.8.33 finished in 147.51ms
Compiler run successful with warnings:
Warning (9207): 'transfer' is deprecated and scheduled for removal. Use 'call{value: <amount>}("")' instead.
   --> src/MyNFT.sol:102:9:
    |
102 |         payable(owner()).transfer(balance);
    |         ^^^^^^^^^^^^^^^^^^^^^^^^^

````
## 部署合约
```bash
forge script script/DeployMyNFT.s.sol:DeployMyNFT \
    --rpc-url $SEPOLIA_URL \
    --broadcast \
    --sender 0x3432967F9609A02b965Fb0a32424b3B476B49f0D \
    --account deployer \
    -vvvvv
````
````bash
[⠊] Compiling...
[⠒] Files to compile:
- script/DeployMyNFT.s.sol
[⠑] Compiling 1 files with Solc 0.8.33
[⠘] Solc 0.8.33 finished in 526.74ms
Compiler run successful with warnings:
Warning (9207): 'transfer' is deprecated and scheduled for removal. Use 'call{value: <amount>}("")' instead.
   --> src/MyNFT.sol:102:9:
    |
102 |         payable(owner()).transfer(balance);
    |         ^^^^^^^^^^^^^^^^^^^^^^^^^

Traces:
  [2327183] DeployMyNFT::run()
    ├─ [0] VM::startBroadcast()
    │   └─ ← [Return]
    ├─ [2278711] → new MyNFT@0xb50d51532941Df7C68c541D668647Ce8644f1616
    │   ├─ emit OwnershipTransferred(previousOwner: 0x0000000000000000000000000000000000000000, newOwner: 0x3432967F9609A02b965Fb0a32424b3B476B49f0D)
    │   └─ ← [Return] 10924 bytes of code
    ├─ [0] VM::stopBroadcast()
    │   └─ ← [Return]
    ├─ [0] console::log("MyNFT deployed to:", MyNFT: [0xb50d51532941Df7C68c541D668647Ce8644f1616]) [staticcall]
    │   └─ ← [Stop]
    ├─ [558] MyNFT::mintPrice() [staticcall]
    │   └─ ← [Return] 10000000000000000 [1e16]
    ├─ [0] console::log("Initial mint price:", 10000000000000000 [1e16]) [staticcall]
    │   └─ ← [Stop]
    ├─ [370] MyNFT::MAX_SUPPLY() [staticcall]
    │   └─ ← [Return] 10000 [1e4]
    ├─ [0] console::log("Max supply:", 10000 [1e4]) [staticcall]
    │   └─ ← [Stop]
    ├─ [582] MyNFT::owner() [staticcall]
    │   └─ ← [Return] 0x3432967F9609A02b965Fb0a32424b3B476B49f0D
    ├─ [0] console::log("Owner:", 0x3432967F9609A02b965Fb0a32424b3B476B49f0D) [staticcall]
    │   └─ ← [Stop]
    └─ ← [Return] MyNFT: [0xb50d51532941Df7C68c541D668647Ce8644f1616]
Script ran successfully.

== Return ==
0: contract MyNFT 0xb50d51532941Df7C68c541D668647Ce8644f1616

== Logs ==
  MyNFT deployed to: 0xb50d51532941Df7C68c541D668647Ce8644f1616
  Initial mint price: 10000000000000000
  Max supply: 10000
  Owner: 0x3432967F9609A02b965Fb0a32424b3B476B49f0D

## Setting up 1 EVM.
==========================
Simulated On-chain Traces:
  [2278711] → new MyNFT@0xb50d51532941Df7C68c541D668647Ce8644f1616
    ├─ emit OwnershipTransferred(previousOwner: 0x0000000000000000000000000000000000000000, newOwner: 0x3432967F9609A02b965Fb0a32424b3B476B49f0D)
    └─ ← [Return] 10924 bytes of code

==========================
Chain 11155111
Estimated gas price: 0.00100002 gwei
Estimated total gas used for script: 3272891
Estimated amount required: 0.00000327295645782 ETH

==========================
Enter keystore password:

##### sepolia
✅  [Success] Hash: 0x7f75b8f19d2e8df9980a047f7bab6e07ed4824e5a72aa471186c5141f3dce705
Contract Address: 0xb50d51532941Df7C68c541D668647Ce8644f1616
Block: 10470537
Paid: 0.00000251763417609 ETH (2517609 gas * 0.00100001 gwei)

✅ Sequence #1 on sepolia | Total Paid: 0.00000251763417609 ETH (2517609 gas * avg 0.00100001 gwei)
                                                                                                                                
==========================
ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.
Transactions saved to: /home/shicw/project/nft_auction_foundry/broadcast/DeployMyNFT.s.sol/11155111/run-latest.json
Sensitive values saved to: /home/shicw/project/nft_auction_foundry/cache/DeployMyNFT.s.sol/11155111/run-latest.json
```
## 
```bash
cast send 0x你的合约地址 "setValue(uint256)" 8 \
  --rpc-url https://sepolia.infura.io/v3/你的项目ID \
  --private-key 你的私钥

cast send <合约地址> \
  "mint(string)" \
  "ipfs://QmP4QFPqMCNacRpKZtFmWgQ9gqAJbYq5KzGX5FqVwJtYVp" \
  --value 0.01ether \
  --rpc-url $SEPOLIA_URL \
  --private-key $PRIVATE_KEY

cast send 0xb50d51532941Df7C68c541D668647Ce8644f1616 \
  "mint(string)" \
  "ipfs://bafybeicumcryrbppiuqquki7txd6xcuubyvjomrh3lvkjao2t6nehwwkiu" \
  --value 0.01ether \
  --rpc-url $SEPOLIA_URL \
  --private-key $PRIVATE_KEY
https://chocolate-fashionable-opossum-636.mypinata.cloud/ipfs/bafybeicumcryrbppiuqquki7txd6xcuubyvjomrh3lvkjao2t6nehwwkiu
==> ipfs://bafybeicumcryrbppiuqquki7txd6xcuubyvjomrh3lvkjao2t6nehwwkiu

cast send 0xb50d51532941Df7C68c541D668647Ce8644f1616 \
  "mint(string)" \
  "ipfs://bafybeiedtr5ubnxak2prqt5xsuyfbm6kxmq3hggepfy2lukt2zcze3di7q" \
  --value 0.01ether \
  --rpc-url $SEPOLIA_URL \
  --private-key $PRIVATE_KEY
  https://chocolate-fashionable-opossum-636.mypinata.cloud/ipfs/bafybeiedtr5ubnxak2prqt5xsuyfbm6kxmq3hggepfy2lukt2zcze3di7q
```
```bash
blockHash            0xa527dcc2f72c469bc7999bbb4399d0090060dc271cfe39f822733e63c71f1189
blockNumber          10470616
contractAddress      
cumulativeGasUsed    18457867
effectiveGasPrice    1000010
from                 0x3432967F9609A02b965Fb0a32424b3B476B49f0D
gasUsed              189356
logs                 [{"address":"0xb50d51532941df7c68c541d668647ce8644f1616","topics":["0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef","0x0000000000000000000000000000000000000000000000000000000000000000","0x0000000000000000000000003432967f9609a02b965fb0a32424b3b476b49f0d","0x0000000000000000000000000000000000000000000000000000000000000001"],"data":"0x","blockHash":"0xa527dcc2f72c469bc7999bbb4399d0090060dc271cfe39f822733e63c71f1189","blockNumber":"0x9fc4d8","blockTimestamp":"0x69babb68","transactionHash":"0x99d7444e01e7e8819cb17ece48caae2b105554eb2ed3148c5b942af404d28e18","transactionIndex":"0xf4","logIndex":"0x15e","removed":false},{"address":"0xb50d51532941df7c68c541d668647ce8644f1616","topics":["0xf8e1a15aba9398e019f0b49df1a4fde98ee17ae345cb5f6b5e2c27f5033e8ce7"],"data":"0x0000000000000000000000000000000000000000000000000000000000000001","blockHash":"0xa527dcc2f72c469bc7999bbb4399d0090060dc271cfe39f822733e63c71f1189","blockNumber":"0x9fc4d8","blockTimestamp":"0x69babb68","transactionHash":"0x99d7444e01e7e8819cb17ece48caae2b105554eb2ed3148c5b942af404d28e18","transactionIndex":"0xf4","logIndex":"0x15f","removed":false},{"address":"0xb50d51532941df7c68c541d668647ce8644f1616","topics":["0xd35bb95e09c04b219e35047ce7b7b300e3384264ef84a40456943dbc0fc17c14","0x0000000000000000000000003432967f9609a02b965fb0a32424b3b476b49f0d","0x0000000000000000000000000000000000000000000000000000000000000001"],"data":"0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000042697066733a2f2f6261667962656963756d6372797262707069757171756b693774786436786375756279766a6f6d7268336c766b6a616f3274366e656877776b6975000000000000000000000000000000000000000000000000000000000000","blockHash":"0xa527dcc2f72c469bc7999bbb4399d0090060dc271cfe39f822733e63c71f1189","blockNumber":"0x9fc4d8","blockTimestamp":"0x69babb68","transactionHash":"0x99d7444e01e7e8819cb17ece48caae2b105554eb2ed3148c5b942af404d28e18","transactionIndex":"0xf4","logIndex":"0x160","removed":false}]
logsBloom            0x00000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000040000000000000000000000000008000000000000000000040000000000000000000000000000020000000000000000000800000000000000000000000010000000000000000000000000000000000000000000100000000100000000000000000000000000000000000000000000000000002000000000080840080000000000008000000002000000000800000000000000000000000000000000000000000060000000000000000000200000000000000000000400000000000000000000000000
root                 
status               1 (success)
transactionHash      0x99d7444e01e7e8819cb17ece48caae2b105554eb2ed3148c5b942af404d28e18
transactionIndex     244
type                 2
blobGasPrice         
blobGasUsed          
to                   0xb50d51532941Df7C68c541D668647Ce8644f1616

## 铸造2
blockHash            0xfdb03bffde947f1c06970c69dc937009ffd6617497e9f0210598ea18dfa96473
blockNumber          10484294
contractAddress      
cumulativeGasUsed    14299735
effectiveGasPrice    1000026
from                 0x3432967F9609A02b965Fb0a32424b3B476B49f0D
gasUsed              155156
logs                 [{"address":"0xb50d51532941df7c68c541d668647ce8644f1616","topics":["0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef","0x0000000000000000000000000000000000000000000000000000000000000000","0x0000000000000000000000003432967f9609a02b965fb0a32424b3b476b49f0d","0x0000000000000000000000000000000000000000000000000000000000000003"],"data":"0x","blockHash":"0xfdb03bffde947f1c06970c69dc937009ffd6617497e9f0210598ea18dfa96473","blockNumber":"0x9ffa46","blockTimestamp":"0x69bd5544","transactionHash":"0x7c8816e0a88b4efecc596258ea4961f81302651bf4b4ed49321d335705fdb330","transactionIndex":"0x67","logIndex":"0x137","removed":false},{"address":"0xb50d51532941df7c68c541d668647ce8644f1616","topics":["0xf8e1a15aba9398e019f0b49df1a4fde98ee17ae345cb5f6b5e2c27f5033e8ce7"],"data":"0x0000000000000000000000000000000000000000000000000000000000000003","blockHash":"0xfdb03bffde947f1c06970c69dc937009ffd6617497e9f0210598ea18dfa96473","blockNumber":"0x9ffa46","blockTimestamp":"0x69bd5544","transactionHash":"0x7c8816e0a88b4efecc596258ea4961f81302651bf4b4ed49321d335705fdb330","transactionIndex":"0x67","logIndex":"0x138","removed":false},{"address":"0xb50d51532941df7c68c541d668647ce8644f1616","topics":["0xd35bb95e09c04b219e35047ce7b7b300e3384264ef84a40456943dbc0fc17c14","0x0000000000000000000000003432967f9609a02b965fb0a32424b3b476b49f0d","0x0000000000000000000000000000000000000000000000000000000000000003"],"data":"0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000042697066733a2f2f62616679626569656474723575626e78616b3270727174357873757966626d366b786d713368676765706679326c756b74327a637a653364693771000000000000000000000000000000000000000000000000000000000000","blockHash":"0xfdb03bffde947f1c06970c69dc937009ffd6617497e9f0210598ea18dfa96473","blockNumber":"0x9ffa46","blockTimestamp":"0x69bd5544","transactionHash":"0x7c8816e0a88b4efecc596258ea4961f81302651bf4b4ed49321d335705fdb330","transactionIndex":"0x67","logIndex":"0x139","removed":false}]
logsBloom            0x00000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000020000000000000000000800000000000000000000000010000000000000000000000000000000000000000000100000000100000000000000000000000000000000000000000000000000002000000000880840080000000000408000000002000000000800000000000000000000000000000000000000000020000000000000000000200000000000000000000400000000000000000000000000
root                 
status               1 (success)
transactionHash      0x7c8816e0a88b4efecc596258ea4961f81302651bf4b4ed49321d335705fdb330
transactionIndex     103
type                 2
blobGasPrice         
blobGasUsed          
to                   0xb50d51532941Df7C68c541D668647Ce8644f1616

```
## account1 铸造NFT，命令多个--from <0xYourAccount1Address>
```bash
cast send <合约地址> \
  "mint(string)" \
  "ipfs://QmP4QFPqMCNacRpKZtFmWgQ9gqAJbYq5KzGX5FqVwJtYVp" \
  --value 0.01ether \
  --rpc-url $SEPOLIA_URL \
  --private-key $PRIVATE_KEY
  --from <0xYourAccount1Address>

cast send 0xb50d51532941Df7C68c541D668647Ce8644f1616 \
  "mint(string)" \
  "ipfs://bafkreid2gfp3hbixwgdizyqbrmiz5jfxsxijrl3twxn65uineqmv5j2fwe" \
  --value 0.01ether \
  --rpc-url $SEPOLIA_URL \
  --private-key $ACCOUNT1_KEY \
  --from $ACCOUNT1

https://chocolate-fashionable-opossum-636.mypinata.cloud/ipfs/bafkreid2gfp3hbixwgdizyqbrmiz5jfxsxijrl3twxn65uineqmv5j2fwe
````
````bash
blockHash            0x0c90eba0bf3afd9111e48b9e64260b8661bb3403051f98d23b694b1029fd371c
blockNumber          10473438
contractAddress      
cumulativeGasUsed    7252853
effectiveGasPrice    1000008
from                 0x7FA1160ad2e667fD6F37882142eDEe650B682D0D
gasUsed              172256
logs                 [{"address":"0xb50d51532941df7c68c541d668647ce8644f1616","topics":["0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef","0x0000000000000000000000000000000000000000000000000000000000000000","0x0000000000000000000000007fa1160ad2e667fd6f37882142edee650b682d0d","0x0000000000000000000000000000000000000000000000000000000000000002"],"data":"0x","blockHash":"0x0c90eba0bf3afd9111e48b9e64260b8661bb3403051f98d23b694b1029fd371c","blockNumber":"0x9fcfde","blockTimestamp":"0x69bb48bc","transactionHash":"0x4cc54f6def28de35a1c281b3b88bc0e624fe2b79b1c9cda3e9ab86a06a33ce9e","transactionIndex":"0x49","logIndex":"0x96","removed":false},{"address":"0xb50d51532941df7c68c541d668647ce8644f1616","topics":["0xf8e1a15aba9398e019f0b49df1a4fde98ee17ae345cb5f6b5e2c27f5033e8ce7"],"data":"0x0000000000000000000000000000000000000000000000000000000000000002","blockHash":"0x0c90eba0bf3afd9111e48b9e64260b8661bb3403051f98d23b694b1029fd371c","blockNumber":"0x9fcfde","blockTimestamp":"0x69bb48bc","transactionHash":"0x4cc54f6def28de35a1c281b3b88bc0e624fe2b79b1c9cda3e9ab86a06a33ce9e","transactionIndex":"0x49","logIndex":"0x97","removed":false},{"address":"0xb50d51532941df7c68c541d668647ce8644f1616","topics":["0xd35bb95e09c04b219e35047ce7b7b300e3384264ef84a40456943dbc0fc17c14","0x0000000000000000000000007fa1160ad2e667fd6f37882142edee650b682d0d","0x0000000000000000000000000000000000000000000000000000000000000002"],"data":"0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000042697066733a2f2f6261666b72656964326766703368626978776764697a797162726d697a356a66787378696a726c337477786e363575696e65716d76356a32667765000000000000000000000000000000000000000000000000000000000000","blockHash":"0x0c90eba0bf3afd9111e48b9e64260b8661bb3403051f98d23b694b1029fd371c","blockNumber":"0x9fcfde","blockTimestamp":"0x69bb48bc","transactionHash":"0x4cc54f6def28de35a1c281b3b88bc0e624fe2b79b1c9cda3e9ab86a06a33ce9e","transactionIndex":"0x49","logIndex":"0x98","removed":false}]
logsBloom            0x04000000000000000080000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000000000004000000000000000000000000000000000020000000000000000000800000000000000000000000010000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000100000000002000000000080040080000000000008000000002000000000000000000000000000000000000000000000000000020000000000000000000200020000000000000000400008000000000000000000000
root                 
status               1 (success)
transactionHash      0x4cc54f6def28de35a1c281b3b88bc0e624fe2b79b1c9cda3e9ab86a06a33ce9e
transactionIndex     73
type                 2
blobGasPrice         
blobGasUsed          
to                   0xb50d51532941Df7C68c541D668647Ce8644f1616
````
