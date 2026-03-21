// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// 简单的代理合约
contract SimpleProxy {
address public implementation;// 逻辑合约地址
    address public admin; // 管理员地址
    /**
     * @dev 挂单结构体
     */
    struct Listing {
        address seller;        // 卖家地址
        address nftContract;    // NFT合约地址
        uint256 tokenId;         // Token ID
        uint256 price;          // 售价（wei）
        uint256 priceUsd;       // USD价格
        uint256 priceErc20;     // ERC20价格
        bool active;            // 是否激活
    }
    
    /**
     * @dev 拍卖结构体
     */
    struct Auction {
        address seller;           // 卖家地址
        address nftContract;      // NFT合约地址
        uint256 tokenId;          // Token ID
        uint256 startPrice;       // 起拍价
        uint256 startPriceUsd;       // 起拍USD价格
        uint256 startPriceErc20;     // 起拍ERC20价格
        uint256 highestBid;       // 当前最高出价
        uint256 highestBidUsd;       // 当前最高出价USD价格
        uint256 highestBidErc20;     // 当前最高出价ERC20价格
        address highestBidder;    // 当前最高出价者
        uint256 endTime;          // 拍卖结束时间
        bool active;              // 是否激活
    }
    
    mapping(uint256 => Listing) public listings;// 挂单映射
    uint256 public listingCounter;
    
    mapping(uint256 => Auction) public auctions;// 拍卖映射
    uint256 public auctionCounter;
    
    mapping(uint256 => mapping(address => uint256)) public pendingReturns;// 待退款映射（用于拍卖）
    
    uint256 public platformFee = 250; // 2.5% // 平台手续费（基点，10000 = 100%）
    address public feeRecipient;// 手续费接收地址
    
    // ########  Price  ########
    uint8 private constant TOKEN_DECIMALS = 18;// 代币的小数位数 (例如，LINK是18位，USDC是6位)。此处以LINK为例。
    AggregatorV3Interface private ethUsdPriceFeed;// 预言机接口实例
    AggregatorV3Interface private erc20UsdPriceFeed;// 预言机接口实例
    // ########  以上变量，一个都不要动。如果更新可以在这行后面添加  ########
    
    /**
     * @notice 构造函数：初始化逻辑合约地址
     * @param _implementation 逻辑合约地址
     */
    constructor(address _implementation) {
        admin = msg.sender;
        implementation = _implementation;
    }

    function _onlyAdmin() internal view {
        require(msg.sender == admin, "Not admin");
    }
    /**
     * @notice onlyAdmin修饰符
     */
    modifier onlyAdmin() {
        _onlyAdmin();
        _;
    }
    
    /**
     * @notice 升级函数：更换逻辑合约
     * @param newImplementation 新的逻辑合约地址
     * @dev 只有admin可以调用
     */
    function upgrade(address newImplementation) external onlyAdmin {
        implementation = newImplementation;
    }
    
    function getImplement() external view returns(address) {
        return implementation;
    }

    /**
     * @notice fallback函数：将所有调用转发到逻辑合约
     * @dev 使用delegatecall调用逻辑合约
     */
    fallback() external payable {
        address impl = implementation;
        require(impl != address(0), "Implementation not set");
        
        // 使用delegatecall调用逻辑合约
        // delegatecall的特性：
        // 1. 代码在Implementation中执行
        // 2. 但使用的storage是Proxy的
        // 3. msg.sender保持不变（是原始调用者）
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }
    
    // 接收以太币
    receive() external payable {}
}