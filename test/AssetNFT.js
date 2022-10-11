/* eslint-disable no-unused-vars */
const { loadFixture } = require('@nomicfoundation/hardhat-network-helpers');
const { expect } = require('chai');
const hre = require('hardhat');
const { default: CONTRACTS } = require('../configs/contracts.js');

describe('AssetNFT', function () {
  const _metadata = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  const _tokenId = 0;
  const _tokenIndex = 0;
  const _wrongTokenIndex = 1;

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

  describe('Statement', function () {
    it('Minting a new AssetNFT to the owner - Check balance of the owner', async function () {
      const { nft, owner } = await loadFixture(deploy);

      await nft.createAsset(owner.address, _tokenId, _metadata);

      expect(await nft.balanceOf(owner.address)).to.equal(1);
    });

    it('Minting a new AssetNFT to the owner - Check the ownership of the new NFT', async function () {
      const { nft, owner } = await loadFixture(deploy);

      await nft.createAsset(owner.address, _tokenId, _metadata);

      expect(await nft.ownerOf(_tokenId)).to.equal(owner.address);
    });

    it('Minting a new AssetNFT to the owner - Check the metadata', async function () {
      const { nft, owner } = await loadFixture(deploy);

      await nft.createAsset(owner.address, _tokenId, _metadata);

      const metadata = await nft.metadata(_tokenId);

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

    it('Minting a new AssetNFT to the other address - Check the token by index', async function () {
      const { nft, otherAddress } = await loadFixture(deploy);

      await nft.createAsset(otherAddress.address, _tokenId, _metadata);

      expect(await nft.tokenByIndex(_tokenIndex)).to.equal(_tokenId);
    });

    it('Minting a new AssetNFT to the other address - Check the token of owner by index', async function () {
      const { nft, otherAddress } = await loadFixture(deploy);

      await nft.createAsset(otherAddress.address, _tokenId, _metadata);

      expect(
        await nft.tokenOfOwnerByIndex(otherAddress.address, _tokenIndex),
      ).to.equal(_tokenId);
    });
  });

  describe('Failed', function () {
    it('Minting a new AssetNFT with the same token id twice', async function () {
      const { nft, owner } = await loadFixture(deploy);

      await nft.createAsset(owner.address, _tokenId, _metadata);

      await expect(
        nft.createAsset(owner.address, _tokenId, _metadata),
      ).to.be.revertedWith('ERC721: token already minted');
    });

    it('Minting a new AssetNFT by another address than the owner', async function () {
      const { nft, otherAddress } = await loadFixture(deploy);

      await expect(
        nft
          .connect(otherAddress)
          .createAsset(otherAddress.address, _tokenId, _metadata),
      ).to.be.revertedWith('Ownable: caller is not the owner');
    });

    it('Minting a new AssetNFT to another address and check the token index', async function () {
      const { nft, otherAddress } = await loadFixture(deploy);

      await nft.createAsset(otherAddress.address, _tokenId, _metadata);

      await expect(nft.tokenByIndex(_wrongTokenIndex)).to.be.revertedWith(
        'ERC721Enumerable: global index out of bounds',
      );
    });

    it('Minting a new AssetNFT to another address and check the token index by owner', async function () {
      const { nft, otherAddress } = await loadFixture(deploy);

      await nft.createAsset(otherAddress.address, _tokenId, _metadata);

      await expect(
        nft.tokenOfOwnerByIndex(otherAddress.address, _wrongTokenIndex),
      ).to.be.revertedWith('ERC721Enumerable: owner index out of bounds');
    });
  });
});
