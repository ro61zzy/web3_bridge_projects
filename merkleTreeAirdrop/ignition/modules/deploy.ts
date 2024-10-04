import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();
  const tokenAddress = "<YOUR_ERC20_TOKEN_ADDRESS>";  // Replace this with your ERC20 token address
  const merkleRoot = "<YOUR_MERKLE_ROOT>";  // Replace this with your Merkle Root

  console.log("Deploying contracts with account:", deployer.address);

  const MerkleAirdrop = await ethers.getContractFactory("MerkleAirdrop");
  const merkleAirdrop = await MerkleAirdrop.deploy(tokenAddress, merkleRoot);

  console.log("Merkle Airdrop deployed to:", merkleAirdrop.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
