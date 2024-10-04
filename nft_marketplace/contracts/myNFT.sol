// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract MyNFT is ERC721 {
    using Address for address;

    uint256 private nextTokenId;

    constructor() ERC721("MyNFT", "NFT") {}

    function mintNFT(address recipient) external {
        require(recipient != address(0), "Invalid recipient address");
        uint256 tokenId = nextTokenId;
        nextTokenId++;
        _mint(recipient, tokenId);
    }
}
