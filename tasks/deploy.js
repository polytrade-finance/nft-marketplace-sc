const { task } = require('hardhat/config');
const fs = require('fs');
require('dotenv').config();

const { default: CONFIGS } = require('../configs');

task('deploy', 'Deploy a new contract')
  .addPositionalParam('param1')
  .setAction(async taskArgs => {
    try {
      const contractNameIndex = taskArgs.param1;
      const contractName = CONFIGS.CONTRACT_NAMES[contractNameIndex];
      // eslint-disable-next-line no-undef
      const Contract = await ethers.getContractFactory(contractName);
      let contract = null;
      if (contractName === CONFIGS.CONTRACT_NAMES[0]) {
        const NAME = CONFIGS.NFT_NAME;
        const SYMBOL = CONFIGS.NFT_SYMBOL;
        contract = await Contract.deploy(NAME, SYMBOL);
      }

      // QUESTION: Why is the following statement?
      await contract.deployed();
      const data = {
        address: contract.address,
      };

      console.log(`Smart Contract address: ${data.address}`);
      fs.writeFileSync(`data/${contractName}.json`, JSON.stringify(data));
    } catch (error) {
      console.error(error);
      process.exitCode = 1;
    }
  });
