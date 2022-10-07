/* eslint-disable no-unused-vars */
const { loadFixture } = require('@nomicfoundation/hardhat-network-helpers');
const { expect } = require('chai');
const hre = require('hardhat');
const { default: CONTRACTS } = require('../configs/contracts.js');

describe('NFT', function () {
  const _metadata = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  async function deploy() {
    const [owner, otherAddress] = await hre.ethers.getSigners();

    const NFT = await hre.ethers.getContractFactory(CONTRACTS.NAMES[0]);
    const nft = await NFT.deploy(CONTRACTS.NFT_NAME, CONTRACTS.NFT_SYMBOL);

    return { nft, owner, otherAddress };
  }

  describe('Deployment', function () {
    it('NFT deployment test', async function () {
      const { nft } = await loadFixture(deploy);

      expect(await nft.name()).to.equal(CONTRACTS.NFT_NAME);
      expect(await nft.symbol()).to.equal(CONTRACTS.NFT_SYMBOL);
    });
  });

  describe('Mint', function () {
    it('Minting a new NFT with to the owner - Check balance of the owner', async function () {
      const { nft, owner } = await loadFixture(deploy);

      await nft.mint(owner.address, 0, _metadata);

      expect(await nft.balanceOf(owner.address)).to.equal(1);
    });

    it('Minting a new NFT with to the owner - Check the ownership of the new NFT', async function () {
      const { nft, owner } = await loadFixture(deploy);

      await nft.mint(owner.address, 0, _metadata);

      expect(await nft.ownerOf(0)).to.equal(owner.address);
    });

    it('Minting a new NFT with to the owner - Check the metadata', async function () {
      const { nft, owner } = await loadFixture(deploy);

      await nft.mint(owner.address, 0, _metadata);

      const metadata = await nft.metadata();

      expect(metadata.factoringFee).to.equal(_metadata[0]);
      expect(metadata.discountingFee).to.equal(_metadata[1]);
      expect(metadata.financedTenure).to.equal(_metadata[2]);
      expect(metadata.advancedPercentage).to.equal(_metadata[3]);
      expect(metadata.reservePercentage).to.equal(_metadata[4]);
      expect(metadata.gracePeriod).to.equal(_metadata[5]);
      expect(metadata.lateFeePercentage).to.equal(_metadata[6]);
      expect(metadata.invoiceAmount).to.equal(_metadata[7]);
      expect(metadata.availableAmount).to.equal(_metadata[8]);
      expect(metadata.bankCharges).to.equal(_metadata[9]);
    });

    it('Minting NFT with the same token id twice will revert', async function () {
      const { nft, owner } = await loadFixture(deploy);

      await nft.mint(owner.address, 0, _metadata);

      await expect(nft.mint(owner.address, 0, _metadata)).to.be.revertedWith(
        'ERC721: token already minted',
      );
    });
  });
});
