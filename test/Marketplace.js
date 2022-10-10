/* eslint-disable no-unused-vars */
const { loadFixture } = require('@nomicfoundation/hardhat-network-helpers');
const { expect } = require('chai');
const hre = require('hardhat');
const { default: CONTRACTS } = require('../configs/contracts.js');

describe('Marketplace', function () {
  async function deploy() {
    const Marketplace = await hre.ethers.getContractFactory(CONTRACTS.NAMES[1]);
    const marketplace = await Marketplace.deploy();

    return { marketplace };
  }

  describe('Deployment', function () {
    it('Marketplace deployment test', async function () {
      const { marketplace } = await loadFixture(deploy);
    });
  });
});
