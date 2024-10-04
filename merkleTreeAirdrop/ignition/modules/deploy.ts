import { ethers } from 'hardhat';

async function main() {
  const tokenAddress = "0x2CEBF8118Ac12C68B4a9fe6A589790d34eB10190";  
  const merkleRoot = "0x8f8f4207f4a5c7f77a3acfa0e7c999c2bc7c0d9a7eae8cfc98e246881d21b485"; 


  console.log("Deploying MerkleAirdrop contract...");

  // Get the contract factory
  const MerkleAirdropFactory = await ethers.getContractFactory("MerkleAirdrop");
  
  // Deploy the contract
  const merkleAirdrop = await MerkleAirdropFactory.deploy(tokenAddress, merkleRoot);

  // Wait for deployment to finish
  await merkleAirdrop.waitForDeployment();

  console.log('Merkle Airdrop Contract Deployed at:', merkleAirdrop.target);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
