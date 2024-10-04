const { ethers } = require("hardhat");

async function main() {
  // Deploy the NFT Marketplace contract
  const nftMarket = await ethers.deployContract("NftMarket"); // Deploy the contract

  // Wait for deployment (optional, depending on your setup)
  await nftMarket.waitForDeployment();

  console.log("NFTMarket Contract Deployed at: " + nftMarket.target); // Log the deployed address

  // Deploy the NFT  contract
  const myNFT = await ethers.deployContract("MyNFT"); // Deploy the contract

  // Wait for deployment (optional, depending on your setup)
  await myNFT.waitForDeployment();

  console.log("MyNFT Contract Deployed at: " + myNFT.target); // Log the deployed address
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1; // Exit with failure code
});
