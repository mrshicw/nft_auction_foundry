// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {NFTMarketplaceV1} from "../src/NFTMarketplaceV1.sol";

contract DeployNFTMarketplaceV1 is Script {
    function run() external returns (NFTMarketplaceV1) {
        // 从环境变量读取私钥（安全方式）
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        // 从环境变量读取构造参数
        address feeRecipient = vm.envAddress("FEE_RECIPIENT");
        address ethUsdPriceFeed = vm.envAddress("ETH_USD_PRICE_FEED");
        address erc20UsdPriceFeed = vm.envAddress("ERC20_USD_PRICE_FEED");

        // 开始广播交易
        vm.startBroadcast(deployerPrivateKey);
        
        // 部署合约，传入三个构造函数参数
        NFTMarketplaceV1 implemention = new NFTMarketplaceV1(
            feeRecipient,
            ethUsdPriceFeed,
            erc20UsdPriceFeed
        );
        
        // 停止广播
        vm.stopBroadcast();
        
        // 打印部署后的合约地址
        console2.log("Contract deployed at:", address(implemention));
        return implemention;
    }
}