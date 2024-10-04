const { ethers } = require("hardhat");

async function main() {
// Deploy the NFT Marketplace contract
const nftMarket = await ethers.deployContract("NftMarket"); 
await nftMarket.waitForDeployment();

console.log("NFTMarket Contract Deployed at: " + nftMarket.target);

// Deploy the NFT  contract
const myNFT = await ethers.deployContract("MyNFT"); 
await myNFT.waitForDeployment();

console.log("MyNFT Contract Deployed at: " + myNFT.target); 


  // Deploy the SaveERC20 contract
  // Specify the ERC20 token address you want to save
  const TokenAddress = "0x2CEBF8118Ac12C68B4a9fe6A589790d34eB10190";
  const saveERC20 = await ethers.deployContract("SaveERC20", [TokenAddress]);
  await saveERC20.waitForDeployment();

  console.log("SaveERC20 Contract Deployed at: " + saveERC20.target);
}

// Execute the deployment script
main().catch((error) => {
  console.error(error);
  process.exitCode = 1; // Exit with failure code
});
