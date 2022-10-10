/* eslint-disable no-unused-vars */
const { loadFixture } = require('@nomicfoundation/hardhat-network-helpers');
const { expect } = require('chai');
const hre = require('hardhat');
const { default: CONTRACTS } = require('../configs/contracts.js');

describe('Marketplace', function () {
  const _metadata = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  const _tokenId = 0;

  async function deploy() {
    const Marketplace = await hre.ethers.getContractFactory(CONTRACTS.NAMES[1]);
    const marketplace = await Marketplace.deploy();

    return { marketplace };
  }

  async function deployToken() {
    const [owner, otherAddress] = await hre.ethers.getSigners();

    const NFT = await hre.ethers.getContractFactory(CONTRACTS.NAMES[0]);
    const nft = await NFT.deploy(CONTRACTS.NFT_NAME, CONTRACTS.NFT_SYMBOL);

    return { nft, owner, otherAddress };
  }

  describe('Deployment', function () {
    it('Marketplace should be able to receive AssetNFTs', async function () {
      const { marketplace } = await loadFixture(deploy);
      const { nft, owner } = await loadFixture(deployToken);

      await nft.createAsset(owner.address, _tokenId, _metadata);

      expect(await nft.ownerOf(_tokenId)).to.equal(owner.address);

      await nft.transferFrom(owner.address, marketplace.address, _tokenId);

      expect(await nft.ownerOf(_tokenId)).to.equal(marketplace.address);
    });
  });
});
