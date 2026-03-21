// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {MyNFT} from "../src/MyNFT.sol";

contract DeployMyNFT is Script {
    // 部署函数
    function run() external returns (MyNFT) {
        // 开始广播交易
        vm.startBroadcast(); 

        // 部署合约
        MyNFT myNft = new MyNFT();

        // 停止广播
        vm.stopBroadcast();

        // 打印部署信息
        console.log("MyNFT deployed to:", address(myNft));
        console.log("Initial mint price:", myNft.mintPrice());
        console.log("Max supply:", myNft.MAX_SUPPLY());
        console.log("Owner:", myNft.owner());

        return myNft;
    }
}