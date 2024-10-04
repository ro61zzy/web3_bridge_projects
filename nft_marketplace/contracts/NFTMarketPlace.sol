// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

library NftMarketError {
    error NotOwner(address);
    error InsufficientBalance(uint256 amount);
    error WithdrawFailed(address, uint256);
    error InvalidPrice();
    error InvalidTokenAddress();
    error ListingExists();
    error NotNftOwner();
    error MarketPlaceNotApprovedToSpend();
    error NotFundsToWithdraw();
    error NotListingOwner();
    error ListingNotActive();
    error ListingExpired();
}

library NftMarketEvent {
    event OwnerWithdraw(address indexed owner, uint256 indexed amount);
    event SellerWithdraw(address indexed seller, uint256 indexed amount);
    event ListingCreated(
        address indexed seller,
        address indexed nftAddress,
        uint256 indexed tokenId,
        uint256 price,
        uint256 deadline
    );
    event UpdatedListing(
        address indexed nftAddress,
        uint256 indexed tokenId,
        uint256 price,
        uint256 deadline
    );
    event CancelListing(address indexed nftAddress, uint256 indexed tokenId);
    event BoughtNft(
        address indexed buyer,
        uint256 indexed price,
        address indexed nftAddress,
        uint256 tokenId
    );
}

contract NftMarket is ReentrancyGuard {
    struct Listing {
        address sellerAddress;
        uint256 nftPrice;
        uint256 salesDeadline;
        bool listingStatus;
    }

    // Mapping of NFT address and tokenId to Listing
    mapping(address => mapping(uint256 => Listing)) public nftListings;
    // Seller's address to amount available to withdraw
    mapping(address => uint256) public sellerBalances;

    address public owner;
    uint256 public withdrawableByOwner;

    constructor() {
        owner = msg.sender;
    }

    function getNftListing(address nftTokenAddress, uint256 tokenId) external view returns (Listing memory) {
        return nftListings[nftTokenAddress][tokenId];
    }

    function ownerWithdraw(uint256 amount) external nonReentrant {
        if (msg.sender != owner) revert NftMarketError.NotOwner(msg.sender);
        if (amount > withdrawableByOwner) revert NftMarketError.InsufficientBalance(amount);

        withdrawableByOwner -= amount;

        (bool success, ) = payable(owner).call{ value: amount }("");
        if (!success) revert NftMarketError.WithdrawFailed(msg.sender, amount);

        emit NftMarketEvent.OwnerWithdraw(msg.sender, amount);
    }

    function listNftForSale(address nftAddress, uint256 tokenId, uint256 nftPrice, uint256 salesDeadline) external {
        if (nftPrice <= 0) revert NftMarketError.InvalidPrice();
        if (salesDeadline <= block.timestamp) revert NftMarketError.ListingExpired();
        if (nftAddress == address(0)) revert NftMarketError.InvalidTokenAddress();
        if (nftListings[nftAddress][tokenId].listingStatus) revert NftMarketError.ListingExists();
        if (IERC721(nftAddress).ownerOf(tokenId) != msg.sender) revert NftMarketError.NotNftOwner();
        if (IERC721(nftAddress).getApproved(tokenId) != address(this)) revert NftMarketError.MarketPlaceNotApprovedToSpend();

        nftListings[nftAddress][tokenId] = Listing(msg.sender, nftPrice, salesDeadline, true);
        emit NftMarketEvent.ListingCreated(msg.sender, nftAddress, tokenId, nftPrice, salesDeadline);
    }

    function updateListingForSale(address nftAddress, uint256 tokenId, uint256 nftPrice, uint256 salesDeadline) external {
        Listing storage listing = nftListings[nftAddress][tokenId];

        if (listing.sellerAddress != msg.sender) revert NftMarketError.NotListingOwner();
        if (!listing.listingStatus) revert NftMarketError.ListingNotActive();
        if (nftPrice <= 0) revert NftMarketError.InvalidPrice();
        if (salesDeadline <= block.timestamp) revert NftMarketError.ListingExpired();

        listing.nftPrice = nftPrice;
        listing.salesDeadline = salesDeadline;

        emit NftMarketEvent.UpdatedListing(nftAddress, tokenId, nftPrice, salesDeadline);
    }

    function cancelListingForSale(address nftAddress, uint256 tokenId) external {
        Listing storage listing = nftListings[nftAddress][tokenId];

        if (listing.sellerAddress != msg.sender) revert NftMarketError.NotListingOwner();
        if (!listing.listingStatus) revert NftMarketError.ListingNotActive();

        delete nftListings[nftAddress][tokenId];
        emit NftMarketEvent.CancelListing(nftAddress, tokenId);
    }

    function buyNft(address nftAddress, uint256 tokenId) external payable nonReentrant {
        Listing storage listing = nftListings[nftAddress][tokenId];

        if (!listing.listingStatus) revert NftMarketError.ListingNotActive();
        if (listing.salesDeadline < block.timestamp) revert NftMarketError.ListingExpired();
        if (msg.value < listing.nftPrice) revert NftMarketError.InvalidPrice();

        address sellerAddress = listing.sellerAddress;
        uint256 marketplaceFee = (msg.value * 3) / 100;
        uint256 sellerAmount = msg.value - marketplaceFee;

        sellerBalances[sellerAddress] += sellerAmount;
        withdrawableByOwner += marketplaceFee;

        delete nftListings[nftAddress][tokenId];
        IERC721(nftAddress).safeTransferFrom(sellerAddress, msg.sender, tokenId);

        emit NftMarketEvent.BoughtNft(msg.sender, msg.value, nftAddress, tokenId);
    }

    function sellerWithdraw() external nonReentrant {
        uint256 amount = sellerBalances[msg.sender];
        if (amount == 0) revert NftMarketError.NotFundsToWithdraw();

        sellerBalances[msg.sender] = 0;

        (bool success, ) = payable(msg.sender).call{ value: amount }("");
        if (!success) revert NftMarketError.WithdrawFailed(msg.sender, amount);

        emit NftMarketEvent.SellerWithdraw(msg.sender, amount);
    }
}
