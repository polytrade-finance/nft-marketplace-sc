/* eslint-disable no-unused-vars */
const { loadFixture } = require('@nomicfoundation/hardhat-network-helpers');
const { expect } = require('chai');
const hre = require('hardhat');
const { default: CONTRACTS } = require('../configs/contracts.js');

describe('NFT', function () {
  async function deploy() {
    const NFT = await hre.ethers.getContractFactory(CONTRACTS.NAMES[0]);
    const nft = await NFT.deploy(CONTRACTS.NFT_NAME, CONTRACTS.NFT_SYMBOL);

    return { nft };
  }

  describe('Deployment', function () {
    it('NFT deployment test', async function () {
      const { nft } = await loadFixture(deploy);

      expect(await nft.name()).to.equal(CONTRACTS.NFT_NAME);
      expect(await nft.symbol()).to.equal(CONTRACTS.NFT_SYMBOL);
    });
  });
});
