// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFTMarketplace is Ownable, ERC721Enumerable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    struct NFT {
        uint256 id;
        address creator;
        string uri;
        uint256 price;
        bool isListed;
    }

    mapping(uint256 => NFT) public nfts;
    mapping(uint256 => address) public nftToOwner;
    
    event NFTMinted(uint256 indexed tokenId, address indexed creator, string uri);
    event NFTListed(uint256 indexed tokenId, uint256 price);
    event NFTSold(uint256 indexed tokenId, address indexed buyer, uint256 price);

    constructor() ERC721("NFTMarketplace", "NFTM") {}

    // Mint a new NFT
    function mintNFT(string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _mint(msg.sender, tokenId);
        _tokenIdCounter.increment();

        nfts[tokenId] = NFT({
            id: tokenId,
            creator: msg.sender,
            uri: uri,
            price: 0,
            isListed: false
        });

        emit NFTMinted(tokenId, msg.sender, uri);
    }

    // List an NFT for sale
    function listNFT(uint256 tokenId, uint256 price) public {
        require(ownerOf(tokenId) == msg.sender, "Not the owner");
        require(price > 0, "Price must be greater than zero");

        nfts[tokenId].price = price;
        nfts[tokenId].isListed = true;
        emit NFTListed(tokenId, price);
    }

    // Buy an NFT
    function buyNFT(uint256 tokenId) public payable {
        require(nfts[tokenId].isListed, "NFT not for sale");
        require(msg.value >= nfts[tokenId].price, "Insufficient payment");
        
        address seller = ownerOf(tokenId);
        require(seller != msg.sender, "Cannot buy your own NFT");

        // Transfer the NFT to the buyer
        _transfer(seller, msg.sender, tokenId);

        // Update ownership mapping
        nftToOwner[tokenId] = msg.sender;

        // Transfer payment to seller
        payable(seller).transfer(nfts[tokenId].price);

        // Mark NFT as no longer listed
        nfts[tokenId].isListed = false;

        emit NFTSold(tokenId, msg.sender, nfts[tokenId].price);
    }

    // Get NFT details
    function getNFTDetails(uint256 tokenId) public view returns (NFT memory) {
        return nfts[tokenId];
    }
}
