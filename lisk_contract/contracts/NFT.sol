// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    uint256 public currentTokenId;

    constructor() ERC721("NFT Name", "NFT") {}

    function mint(address recipient) public returns (uint256) {
        uint256 newItemId = ++currentTokenId;
        _safeMint(recipient, newItemId);
        return newItemId;
    }
}

// npx hardhat compile
// Generating typings for: 14 artifacts in dir: typechain-types for target: ethers-v6
// Successfully generated 50 typings!
// Compiled 12 Solidity files successfully (evm target: paris).
// npx hardhat run ignition/modules/deploy.ts --network lisk-sepolia
// NFT Contract Deployed at 0x2a4b1F6FED41f83b7fbcfD47c430eb5fcD315cE0