import { MerkleTree } from "merkletreejs";
import keccak256 from "keccak256";
import { ethers } from "ethers";

const airdropList = [
  { address: "0x123...", amount: ethers.utils.parseEther("100") },
  { address: "0x456...", amount: ethers.utils.parseEther("50") },
  // Add more addresses and amounts here
];

function generateLeaf(address: string, amount: ethers.BigNumber): Buffer {
  return Buffer.from(
    ethers.utils.solidityKeccak256(["address", "uint256"], [address, amount]).slice(2),
    "hex"
  );
}

const leaves = airdropList.map(item => generateLeaf(item.address, item.amount));
const merkleTree = new MerkleTree(leaves, keccak256, { sortPairs: true });
const root = merkleTree.getRoot().toString("hex");

console.log("Merkle Root:", root);

// To generate a proof for an address and amount
const proof = merkleTree.getHexProof(generateLeaf("0x123...", ethers.utils.parseEther("100")));
console.log("Merkle Proof:", proof);
