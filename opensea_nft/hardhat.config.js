require("dotenv").config();
require("@nomiclabs/hardhat-ethers"); // Ensure this is the correct package
const { ALCHEMy_RPC_URL, PRIVATE_KEY } = process.env;

module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.24",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        version: "0.8.20",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  defaultNetwork: "sepolia",
  networks: {
    hardhat: {},
    sepolia: {
      url: ALCHEMy_RPC_URL,
      accounts: [`0x${PRIVATE_KEY}`],
    },
  },
};