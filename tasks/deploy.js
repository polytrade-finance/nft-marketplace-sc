const { task } = require('hardhat/config');
const moment = require('moment');
const fs = require('fs');
require('dotenv').config();

const { default: CONSTANTS } = require('../configs/constants.js');
const { default: CONTRACTS } = require('../configs/contracts.js');

task('deploy', 'Deploy a new contract')
  .addPositionalParam('param1')
  .setAction(async taskArgs => {
    try {
      const contractNameIndex = taskArgs.param1;
      const contractName = CONTRACTS.NAMES[contractNameIndex];
      // eslint-disable-next-line no-undef
      const Contract = await ethers.getContractFactory(contractName);
      let contract = null;
      if (contractName === CONTRACTS.NAMES[0]) {
        const NAME = CONSTANTS.NFT_NAME;
        const SYMBOL = CONSTANTS.NFT_SYMBOL;
        const NFT_BASE_URI = CONSTANTS.NFT_BASE_URI;
        const NFT_FORMULAS_CONTRACT_ADDRESS =
          CONSTANTS.NFT_FORMULAS_CONTRACT_ADDRESS;
        contract = await Contract.deploy(
          NAME,
          SYMBOL,
          NFT_BASE_URI,
          NFT_FORMULAS_CONTRACT_ADDRESS,
        );
      } else if (contractName === CONTRACTS.NAMES[1]) {
        contract = await Contract.deploy(
          CONSTANTS.NFT_CONTRACT_ADDRESS,
          CONSTANTS.STABLE_COIN_ADDRESS,
        );
      } else if (contractName === CONTRACTS.NAMES[4]) {
        const _totalSupply = '1000000';
        const _receiver = '0x936e928babc957f670ba75daf78255bffe3172ab';
        contract = await Contract.deploy(
          CONSTANTS.TOKEN_NAME,
          CONSTANTS.TOKEN_SYMBOL,
          _receiver,
          _totalSupply,
        );
      } else {
        contract = await Contract.deploy();
      }

      // QUESTION: Why is the following statement?
      await contract.deployed();
      const data = {
        address: contract.address,
        network: CONSTANTS.NETWORK,
        date: moment(new Date()).format('DD-MMM-YYYY'),
      };

      // eslint-disable-next-line no-console
      console.log(`Smart Contract address: ${data.address}`);
      fs.writeFileSync(`data/${contractName}.json`, JSON.stringify(data));
    } catch (error) {
      // eslint-disable-next-line no-console
      console.error(error);
      process.exitCode = 1;
    }
  });
