import { ethers } from 'hardhat';

async function main() {
    // Deploy the NFT Marketplace contract
    const NftMarket = await ethers.getContractFactory('NftMarket'); // Use getContractFactory to get the contract
    const nftMarket = await NftMarket.deploy(); // Deploy the contract
    await nftMarket.deployed(); // Wait for deployment to finish

    console.log('NFTMarket Contract Deployed at: ' + nftMarket.address); // Log the deployed address
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
