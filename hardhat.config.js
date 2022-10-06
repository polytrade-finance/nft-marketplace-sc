require('@nomicfoundation/hardhat-toolbox');
require('dotenv').config();
require('./tasks/deploy.js');

const MUMBAI_RPC_URL = process.env.MUMBAI_RPC_URL;
const ACCOUNT_PRIVATE_KEY = process.env.ACCOUNT_PRIVATE_KEY;
const MUMBAI_API_KEY = process.env.MUMBAI_API_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: '0.8.17',
  networks: {
    mumbai: {
      url: MUMBAI_RPC_URL,
      accounts: [`0x${ACCOUNT_PRIVATE_KEY}`],
    },
  },
  etherscan: {
    apiKey: {
      polygonMumbai: MUMBAI_API_KEY,
    },
  },
};
