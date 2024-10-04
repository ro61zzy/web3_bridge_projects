import { ethers } from 'hardhat';

async function main() {
    // Define initial supply (1 million tokens in this example)
    const initialSupply = ethers.parseEther('1000000');

    // Deploy the RozzyToken contract
    const rozzyToken = await ethers.deployContract('RozzyToken', [initialSupply]);

    // Wait for the contract to be deployed
    await rozzyToken.waitForDeployment();

    // Output the address of the deployed contract
    console.log('RozzyToken Contract Deployed at: ' + rozzyToken.target);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
