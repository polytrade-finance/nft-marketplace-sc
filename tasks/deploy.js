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
        contract = await Contract.deploy(NAME, SYMBOL);
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
