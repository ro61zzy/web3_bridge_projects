const { ethers } = require("hardhat");

async function main() {
    // Deploy the NFT contract
    const NFTContract = await ethers.getContractFactory("MyNFT");
    const nft = await NFTContract.deploy();
    await nft.deployed();
    console.log("MyNFT deployed to:", nft.address);

    // Deploy the NFT marketplace contract
    const MarketplaceContract = await ethers.getContractFactory("NftMarket");
    const marketplace = await MarketplaceContract.deploy();
    await marketplace.deployed();
    console.log("NftMarket deployed to:", marketplace.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

    