// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFTMarketplace is ERC721, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Structure for listed NFTs
    struct Listing {
        uint256 price;
        address seller;
        bool isListed;
    }

    // Mapping of token IDs to their listing
    mapping(uint256 => Listing) private _listings;

    // Events for the marketplace
    event NFTMinted(uint256 tokenId, address owner);
    event NFTListed(uint256 tokenId, uint256 price, address seller);
    event NFTSold(uint256 tokenId, uint256 price, address seller, address buyer);
    event NFTDelisted(uint256 tokenId, address seller);

    constructor() ERC721("NFT Marketplace Token", "NFTM") {}

    /**
     * @notice Mint a new NFT and assign it to the owner (contract owner or authorized minter)
     * @dev Only the contract owner or authorized users can mint
     * @param recipient The address of the recipient for the newly minted NFT
     */
    function mintNFT(address recipient) public onlyOwner returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(recipient, newItemId);

        emit NFTMinted(newItemId, recipient);
        return newItemId;
    }

    /**
     * @notice List an NFT for sale
     * @param tokenId The token ID of the NFT to list
     * @param price The price (in Wei) at which the NFT is being listed
     */
    function listNFT(uint256 tokenId, uint256 price) public {
        require(ownerOf(tokenId) == msg.sender, "You do not own this NFT.");
        require(price > 0, "Price must be greater than zero.");

        _listings[tokenId] = Listing(price, msg.sender, true);

        emit NFTListed(tokenId, price, msg.sender);
    }

    /**
     * @notice Delist an NFT (remove it from sale)
     * @param tokenId The token ID of the NFT to delist
     */
    function delistNFT(uint256 tokenId) public {
        Listing memory listing = _listings[tokenId];
        require(listing.seller == msg.sender, "You are not the seller.");
        require(listing.isListed == true, "NFT is not listed.");

        delete _listings[tokenId];

        emit NFTDelisted(tokenId, msg.sender);
    }

    /**
     * @notice Buy an NFT that is listed for sale
     * @param tokenId The token ID of the NFT to purchase
     */
    function buyNFT(uint256 tokenId) public payable nonReentrant {
        Listing memory listing = _listings[tokenId];
        require(listing.isListed == true, "This NFT is not for sale.");
        require(msg.value >= listing.price, "Insufficient funds to purchase NFT.");

        address seller = listing.seller;
        address buyer = msg.sender;
        uint256 price = listing.price;

        // Transfer ownership of the NFT from seller to buyer
        _transfer(seller, buyer, tokenId);

      
        payable(seller).transfer(price);

     
        delete _listings[tokenId];

        emit NFTSold(tokenId, price, seller, buyer);
    }


    function getListing(uint256 tokenId) public view returns (uint256 price, address seller, bool isListed) {
        Listing memory listing = _listings[tokenId];
        return (listing.price, listing.seller, listing.isListed);
    }
}
