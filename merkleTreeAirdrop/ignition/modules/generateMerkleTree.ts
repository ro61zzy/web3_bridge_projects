import { MerkleTree } from 'merkletreejs';
import keccak256 from 'keccak256';



// Define the addresses and amounts you want to include in the Merkle tree
const elements = [
  { address: "0x1234567890abcdef1234567890abcdef12345678", amount: 100 },
  { address: "0xabcdefabcdefabcdefabcdefabcdefabcdefabcdef", amount: 200 },
  { address: "0x567890abcdef1234567890abcdef1234567890ab", amount: 300 },
];

// Create leaves by hashing the address and amount
const leaves = elements.map(element => 
  keccak256(`${element.address}${element.amount}`)
);

// Generate the Merkle Tree
const tree = new MerkleTree(leaves, keccak256, { sortPairs: true });

// Get the Merkle Root
const merkleRoot = tree.getRoot().toString('hex');

console.log('Merkle Root:', merkleRoot);
