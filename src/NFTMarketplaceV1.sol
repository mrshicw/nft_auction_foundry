// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

/**
 * @title IERC2981
 * @dev ERC2981版税标准接口
 */
interface IERC2981 is IERC165 {
    function royaltyInfo(
        uint256 tokenId,
        uint256 salePrice
    ) external view returns (
        address receiver,
        uint256 royaltyAmount
    );
}

/**
 * @title NFTMarketplace
 * @dev 完整的NFT交易市场合约，支持上架、购买、版税和拍卖功能
 * @notice 使用ReentrancyGuard防止重入攻击
 */
contract NFTMarketplaceV1 is ReentrancyGuard {
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
     * @dev NFT上架事件
     */
    event NFTListed(
        uint256 indexed listingId,
        address indexed seller,
        address indexed nftContract,
        uint256 tokenId,
        uint256 price,
        uint256 priceUsd,
        uint256 priceErc20
    );
    
    /**
     * @dev NFT下架事件
     */
    event NFTDelisted(
        uint256 indexed listingId
    );
    
    /**
     * @dev 价格更新事件
     */
    event PriceUpdated(
        uint256 indexed listingId,
        uint256 newPrice,
        uint256 newPriceUsd,
        uint256 newPriceErc20
    );
    
    /**
     * @dev NFT售出事件
     */
    event NFTSold(
        uint256 indexed listingId,
        address indexed buyer,
        address indexed seller,
        uint256 price,
        uint256 priceUsd,
        uint256 priceErc20
    );
    
    /**
     * @dev 拍卖创建事件
     */
    event AuctionCreated(
        uint256 indexed auctionId,
        address indexed seller,
        address indexed nftContract,
        uint256 tokenId,
        uint256 startPrice,
        uint256 startPriceUse,
        uint256 startPriceErc20,
        uint256 endTime
    );
    
    /**
     * @dev 出价事件
     */
    event BidPlaced(
        uint256 indexed auctionId,
        address indexed bidder,
        uint256 amount,
        uint256 amountUsd,
        uint256 amountErc20
    );
    
    /**
     * @dev 拍卖结束事件
     */
    event AuctionEnded(
        uint256 indexed auctionId,
        address indexed winner,
        uint256 finalPrice,
        uint256 finalPriceUsd,
        uint256 finalPriceErc20
    );
    
    /**
     * @dev 构造函数
     * @param _feeRecipient 手续费接收地址
     * @param _ethUsdPriceFeed USD价格地址
     * @param _erc20UsdPriceFeed ERC20价格地址
     */
    constructor(address _feeRecipient, address _ethUsdPriceFeed, address _erc20UsdPriceFeed) {
        require(_feeRecipient != address(0), "Invalid fee recipient");
        require(_ethUsdPriceFeed != address(0), "Invalid ETH/USD price feed address");
        require(_erc20UsdPriceFeed != address(0), "Invalid ERC20/USD price feed address");

        feeRecipient = _feeRecipient;
        ethUsdPriceFeed = AggregatorV3Interface(_ethUsdPriceFeed);
        erc20UsdPriceFeed = AggregatorV3Interface(_erc20UsdPriceFeed);
    }
    
    // ########  Market  ########
    /**
     * @dev 上架NFT
     * @param nftContract NFT合约地址
     * @param tokenId Token ID
     * @param price 售价（wei）
     * @return listingId 挂单ID
     */
    function listNft(
        address nftContract,
        uint256 tokenId,
        uint256 price
    ) external returns (uint256) {
        require(price > 0, "Price must be greater than 0");
        require(nftContract != address(0), "Invalid NFT contract");
        
        IERC721 nft = IERC721(nftContract);
        
        // 验证所有权
        require(nft.ownerOf(tokenId) == msg.sender, "Not the owner");
        
        // 验证授权
        require(
            nft.getApproved(tokenId) == address(this) ||
            nft.isApprovedForAll(msg.sender, address(this)),
            "Marketplace not approved"
        );
        
        uint256 priceUsd = getEthValueInUsd(price);
        uint256 priceErc20 = getErc20ValueInUsd(price);
        // 创建挂单
        listingCounter++;
        listings[listingCounter] = Listing({
            seller: msg.sender,
            nftContract: nftContract,
            tokenId: tokenId,
            price: price,
            priceUsd: priceUsd,
            priceErc20: priceErc20,
            active: true
        });
        
        emit NFTListed(
            listingCounter,
            msg.sender,
            nftContract,
            tokenId,
            price,
            priceUsd,
            priceErc20
        );
        
        return listingCounter;
    }
    
    /**
     * @dev 下架NFT
     * @param listingId 挂单ID
     */
    function delistNft(uint256 listingId) external {
        Listing storage listing = listings[listingId];
        
        require(listing.active, "Listing not active");
        require(listing.seller == msg.sender, "Not the seller");
        
        listing.active = false;
        
        emit NFTDelisted(listingId);
    }
    
    /**
     * @dev 更新挂单价格
     * @param listingId 挂单ID
     * @param newPrice 新价格（wei）
     */
    function updatePrice(uint256 listingId, uint256 newPrice) external {
        require(newPrice > 0, "Price must be greater than 0");
        
        Listing storage listing = listings[listingId];
        require(listing.active, "Listing not active");
        require(listing.seller == msg.sender, "Not the seller");
        
        uint256 newPriceUsd = getEthValueInUsd(newPrice);
        uint256 newPriceErc20 = getErc20ValueInUsd(newPrice);
        listing.price = newPrice;
        listing.priceUsd = newPriceUsd;
        listing.priceErc20 = newPriceErc20;
        
        emit PriceUpdated(listingId, newPrice, newPriceUsd, newPriceErc20);
    }
    
    /**
     * @dev 购买NFT
     * @param listingId 挂单ID
     * @notice 需要支付足够的ETH，多余部分会自动退还
     */
    function buyNft(uint256 listingId) external payable nonReentrant {
        Listing storage listing = listings[listingId];
        
        // 检查挂单状态
        require(listing.active, "Listing not active");
        require(msg.value >= listing.price, "Insufficient payment");
        require(msg.sender != listing.seller, "Cannot buy your own NFT");
        
        // 先更新状态（CEI原则）
        listing.active = false;
        
        // 计算手续费
        uint256 fee = (listing.price * platformFee) / 10000;
        
        // 获取版税信息
        (address royaltyReceiver, uint256 royaltyAmount) = _getRoyaltyInfo(
            listing.nftContract,
            listing.tokenId,
            listing.price
        );
        
        // 计算卖家收益
        uint256 sellerAmount = listing.price - fee - royaltyAmount;
        
        // 转移NFT
        IERC721(listing.nftContract).safeTransferFrom(
            listing.seller,
            msg.sender,
            listing.tokenId
        );
        
        // 资金分配：版税 -> 平台手续费 -> 卖家收益
        if (royaltyAmount > 0 && royaltyReceiver != address(0)) {
            (bool successRoyalty, ) = royaltyReceiver.call{value: royaltyAmount}("");
            require(successRoyalty, "Royalty transfer failed");
        }
        
        (bool successSeller, ) = listing.seller.call{value: sellerAmount}("");
        require(successSeller, "Transfer to seller failed");
        
        (bool successFee, ) = feeRecipient.call{value: fee}("");
        require(successFee, "Transfer fee failed");
        
        // 退还多余资金
        if (msg.value > listing.price) {
            (bool successRefund, ) = msg.sender.call{
                value: msg.value - listing.price
            }("");
            require(successRefund, "Refund failed");
        }
        
        emit NFTSold(listingId, msg.sender, listing.seller, listing.price, listing.priceUsd, listing.priceErc20);
    }
    
    // ########  Auction  ########
    /**
     * @dev 创建拍卖
     * @param nftContract NFT合约地址
     * @param tokenId Token ID
     * @param startPrice 起拍价（wei）
     * @param durationHours 拍卖时长（小时）
     * @return auctionId 拍卖ID
     */
    function createAuction(
        address nftContract,
        uint256 tokenId,
        uint256 startPrice,
        uint256 durationHours
    ) external returns (uint256) {
        require(startPrice > 0, "Start price must be greater than 0");
        require(durationHours >= 1, "Duration must be at least 1 hour");
        require(nftContract != address(0), "Invalid NFT contract");
        
        IERC721 nft = IERC721(nftContract);
        
        // 验证所有权
        require(nft.ownerOf(tokenId) == msg.sender, "Not the owner");
        
        // 验证授权
        require(
            nft.getApproved(tokenId) == address(this) ||
            nft.isApprovedForAll(msg.sender, address(this)),
            "Marketplace not approved"
        );

        uint256 startPriceUsd = getEthValueInUsd(startPrice);
        uint256 startPriceErc20 = getErc20ValueInUsd(startPrice);
        // 创建拍卖
        auctionCounter++;
        auctions[auctionCounter] = Auction({
            seller: msg.sender,
            nftContract: nftContract,
            tokenId: tokenId,
            startPrice: startPrice,
            startPriceUsd: startPriceUsd,
            startPriceErc20: startPriceErc20,
            highestBid: 0,
            highestBidUsd: 0,
            highestBidErc20: 0,
            highestBidder: address(0),
            endTime: block.timestamp + (durationHours * 1 hours),
            active: true
        });
        
        emit AuctionCreated(
            auctionCounter,
            msg.sender,
            nftContract,
            tokenId,
            startPrice,
            startPriceUsd,
            startPriceErc20,
            auctions[auctionCounter].endTime
        );
        
        return auctionCounter;
    }
    
    /**
     * @dev 出价
     * @param auctionId 拍卖ID
     * @notice 需要支付足够的ETH，出价必须高于当前最高出价的5%
     */
    function placeBid(uint256 auctionId) external payable {
        Auction storage auction = auctions[auctionId];
        
        require(auction.active, "Auction not active");
        require(block.timestamp < auction.endTime, "Auction ended");
        require(msg.sender != auction.seller, "Seller cannot bid");
        
        // 计算最低出价
        uint256 minBid;
        if (auction.highestBid == 0) {
            minBid = auction.startPrice;
        } else {
            minBid = auction.highestBid + (auction.highestBid * 5 / 100); // 5% increment
        }
        
        require(msg.value >= minBid, "Bid too low");
        
        // 如果有之前的出价者，记录他们的待退款金额
        if (auction.highestBidder != address(0)) {
            pendingReturns[auctionId][auction.highestBidder] += auction.highestBid;
        }
        
        uint256 highestBidUsd = getEthValueInUsd(msg.value);
        uint256 highestBidErc20 = getErc20ValueInUsd(msg.value);

        // 更新最高出价
        auction.highestBid = msg.value;
        auction.highestBidUsd = highestBidUsd;
        auction.highestBidErc20 = highestBidErc20;
        auction.highestBidder = msg.sender;
        
        emit BidPlaced(auctionId, msg.sender, msg.value, highestBidUsd, highestBidErc20);
    }
    
    /**
     * @dev 提取出价退款
     * @param auctionId 拍卖ID
     * @notice 被超越的出价者可以提取他们的资金
     */
    function withdrawBid(uint256 auctionId) external {
        uint256 amount = pendingReturns[auctionId][msg.sender];
        require(amount > 0, "No pending return");
        
        pendingReturns[auctionId][msg.sender] = 0;
        
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
    }
    
    /**
     * @dev 结束拍卖
     * @param auctionId 拍卖ID
     * @notice 任何人都可以在拍卖结束后调用此函数进行结算
     */
    function endAuction(uint256 auctionId) external nonReentrant {
        Auction storage auction = auctions[auctionId];
        
        require(auction.active, "Auction not active");
        require(block.timestamp >= auction.endTime, "Auction not ended");
        
        auction.active = false;
        
        if (auction.highestBidder != address(0)) {
            // 有人出价，进行结算
            uint256 fee = (auction.highestBid * platformFee) / 10000;
            
            (address royaltyReceiver, uint256 royaltyAmount) = _getRoyaltyInfo(
                auction.nftContract,
                auction.tokenId,
                auction.highestBid
            );
            
            uint256 sellerAmount = auction.highestBid - fee - royaltyAmount;
            
            // 转移NFT
            IERC721(auction.nftContract).safeTransferFrom(
                auction.seller,
                auction.highestBidder,
                auction.tokenId
            );
            
            // 资金分配
            if (royaltyAmount > 0 && royaltyReceiver != address(0)) {
                (bool successRoyalty, ) = royaltyReceiver.call{value: royaltyAmount}("");
                require(successRoyalty, "Royalty transfer failed");
            }
            
            (bool successSeller, ) = auction.seller.call{value: sellerAmount}("");
            require(successSeller, "Transfer to seller failed");
            
            (bool successFee, ) = feeRecipient.call{value: fee}("");
            require(successFee, "Transfer fee failed");
            
            emit AuctionEnded(
                auctionId,
                auction.highestBidder,
                auction.highestBid,
                auction.highestBidUsd,
                auction.highestBidErc20
            );
        } else {
            // 没有人出价，拍卖流拍
            emit AuctionEnded(auctionId, address(0), 0, 0, 0);
        }
    }
    
    /**
     * @dev 获取版税信息
     * @param nftContract NFT合约地址
     * @param tokenId Token ID
     * @param salePrice 售价
     * @return receiver 版税接收地址
     * @return royaltyAmount 版税金额
     * @notice 内部函数，检查NFT合约是否支持ERC2981标准
     */
    function _getRoyaltyInfo(
        address nftContract,
        uint256 tokenId,
        uint256 salePrice
    ) internal view returns (address receiver, uint256 royaltyAmount) {
        // 检查NFT合约是否支持ERC2981
        if (IERC165(nftContract).supportsInterface(type(IERC2981).interfaceId)) {
            (receiver, royaltyAmount) = IERC2981(nftContract).royaltyInfo(
                tokenId,
                salePrice
            );
        } else {
            // 不支持版税，返回零地址和零金额
            receiver = address(0);
            royaltyAmount = 0;
        }
    }
    
    /**
     * @dev 查询挂单信息
     * @param listingId 挂单ID
     * @return seller 卖家地址
     * @return nftContract NFT合约地址
     * @return tokenId Token ID
     * @return price 价格
     * @return priceUsd 美元价格
     * @return priceErc20 ERC20价格
     * @return active 是否激活
     */
    function getListing(uint256 listingId) external view returns (
        address seller,
        address nftContract,
        uint256 tokenId,
        uint256 price,
        uint256 priceUsd,
        uint256 priceErc20,
        bool active
    ) {
        Listing memory listing = listings[listingId];
        return (
            listing.seller,
            listing.nftContract,
            listing.tokenId,
            listing.price,
            listing.priceUsd,
            listing.priceErc20,
            listing.active
        );
    }
    
    /**
     * @dev 查询拍卖信息
     * @param auctionId 拍卖ID
     * @return seller 卖家地址
     * @return nftContract NFT合约地址
     * @return tokenId Token ID
     * @return startPrice 起拍价
     * @return startPriceUsd Usd起拍价
     * @return startPriceErc20 Erc20起拍价
     * @return highestBid 当前最高出价
     * @return highestBidUsd Usd当前最高出价
     * @return highestBidErc20 Erc20当前最高出价
     * @return highestBidder 当前最高出价者
     * @return endTime 结束时间
     * @return active 是否激活
     */
    function getAuction(uint256 auctionId) external view returns (
        address seller,
        address nftContract,
        uint256 tokenId,
        uint256 startPrice,
        uint256 startPriceUsd,
        uint256 startPriceErc20,
        uint256 highestBid,
        uint256 highestBidUsd,
        uint256 highestBidErc20,
        address highestBidder,
        uint256 endTime,
        bool active
    ) {
        Auction memory auction = auctions[auctionId];
        return (
            auction.seller,
            auction.nftContract,
            auction.tokenId,
            auction.startPrice,
            auction.startPriceUsd,
            auction.startPriceErc20,
            auction.highestBid,
            auction.highestBidUsd,
            auction.highestBidErc20,
            auction.highestBidder,
            auction.endTime,
            auction.active
        );
    }
    
    /**
     * @dev 设置平台手续费
     * @param newFee 新的手续费（基点）
     * @notice 只有手续费接收地址可以调用
     */
    function setPlatformFee(uint256 newFee) external {
        require(msg.sender == feeRecipient, "Not fee recipient");
        require(newFee <= 1000, "Fee too high"); // 最大10%
        platformFee = newFee;
    }
    
    /**
     * @dev 更新手续费接收地址
     * @param newRecipient 新的接收地址
     * @notice 只有当前手续费接收地址可以调用
     */
    function updateFeeRecipient(address newRecipient) external {
        require(msg.sender == feeRecipient, "Not fee recipient");
        require(newRecipient != address(0), "Invalid address");
        feeRecipient = newRecipient;
    }

    // ########  Price  ########
    /**
     * @dev 获取最新的ETH/USD价格。
     * @return 最新的ETH/USD价格，包含8位小数。
     */
    function getEthUsdPrice() public view returns (int) {
        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = ethUsdPriceFeed.latestRoundData();
        require(price > 0, "Invalid ETH/USD price");
        return price;
    }

    /**
     * @dev 获取最新的指定ERC20/USD价格。
     * @return 最新的ERC20/USD价格，包含8位小数。
     */
    function getErc20UsdPrice() public view returns (int) {
        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = erc20UsdPriceFeed.latestRoundData();
        require(price > 0, "Invalid ERC20/USD price");
        return price;
    }

    /**
     * @dev 计算给定数量的ETH价值多少美元。
     * @param ethAmount 以wei为单位传入的ETH数量（1 ETH = 10^18 wei）。
     * @return 对应价值的美元金额，包含8位小数。
     */
    function getEthValueInUsd(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = uint256(getEthUsdPrice());
        // ethAmount (18 decimals) * ethPrice (8 decimals) / 10^18
        // 结果将具有 (18 + 8 - 18) = 8 位小数
        return (ethAmount * ethPrice) / (10 ** TOKEN_DECIMALS);
    }

    /**
     * @dev 计算给定数量的ERC20代币价值多少美元。
     * @param tokenAmount 以代币最小单位传入的数量（例如，1 LINK = 10^18）。
     * @return 对应价值的美元金额，包含8位小数。
     */
    function getErc20ValueInUsd(uint256 tokenAmount) public view returns (uint256) {
        uint256 tokenPrice = uint256(getErc20UsdPrice());
        // tokenAmount (TOKEN_DECIMALS decimals) * tokenPrice (8 decimals) / 10^TOKEN_DECIMALS
        // 结果将具有 (TOKEN_DECIMALS + 8 - TOKEN_DECIMALS) = 8 位小数
        return (tokenAmount * tokenPrice) / (10 ** TOKEN_DECIMALS);
    }

    /**
     * @dev 获取ETH/USD预言机的小数位数。
     */
    function getEthUsdDecimals() public view returns (uint8) {
        return ethUsdPriceFeed.decimals();
    }

    /**
     * @dev 获取ERC20/USD预言机的小数位数。
     */
    function getErc20UsdDecimals() public view returns (uint8) {
        return erc20UsdPriceFeed.decimals();
    }

}

