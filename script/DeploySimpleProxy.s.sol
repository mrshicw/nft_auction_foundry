// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {SimpleProxy} from "../src/SimpleProxy.sol";

contract DeploySimpleProxy is Script {
    function run() external returns (SimpleProxy) {
        // 从环境变量读取私钥（安全方式）
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address implemention = vm.envAddress("NFTMARKETPLACEV1");

        // 开始广播交易
        vm.startBroadcast(deployerPrivateKey);
        SimpleProxy proxy = new SimpleProxy(implemention);

        // 停止广播
        vm.stopBroadcast();
        
        // 打印部署后的合约地址
        console2.log("Contract deployed at:", address(implemention));
        return proxy;
    }
}