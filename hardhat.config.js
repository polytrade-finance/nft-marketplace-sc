require('@nomicfoundation/hardhat-toolbox');
require('dotenv').config();
require('./tasks/deploy.js');

const { default: CONSTANTS } = require('./configs/constants.js');

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: '0.8.17',
  networks: {
    mumbai: {
      url: CONSTANTS.MUMBAI_RPC_URL,
      accounts: [`0x${CONSTANTS.ACCOUNT_PRIVATE_KEY}`],
    },
  },
  etherscan: {
    apiKey: {
      polygonMumbai: CONSTANTS.MUMBAI_API_KEY,
    },
  },
};
