const { loadFixture } = require('@nomicfoundation/hardhat-network-helpers');
const { expect } = require('chai');
const hre = require('hardhat');
const { default: CONTRACTS } = require('../configs/contracts.js');

describe('Marketplace', function () {
  const _metadata = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
  const _tokenId = 0;

  async function deploy() {
    const [owner, otherAddress] = await hre.ethers.getSigners();
    const Marketplace = await hre.ethers.getContractFactory(CONTRACTS.NAMES[1]);
    const marketplace = await Marketplace.deploy();

    const NonReceiverMarketplace = await hre.ethers.getContractFactory(
      CONTRACTS.NAMES[2],
    );
    const nonReceiverMarketplace = await NonReceiverMarketplace.deploy();

    const NFT = await hre.ethers.getContractFactory(CONTRACTS.NAMES[0]);
    const nft = await NFT.deploy(CONTRACTS.NFT_NAME, CONTRACTS.NFT_SYMBOL);

    return { nft, marketplace, nonReceiverMarketplace, owner, otherAddress };
  }

  describe('Statements', function () {
    it('Marketplace should be able to receive AssetNFTs - transferFrom', async function () {
      const { nft, owner, marketplace } = await loadFixture(deploy);

      await nft.createAsset(owner.address, _tokenId, _metadata);

      expect(await nft.ownerOf(_tokenId)).to.equal(owner.address);

      await nft.transferFrom(owner.address, marketplace.address, _tokenId);

      expect(await nft.ownerOf(_tokenId)).to.equal(marketplace.address);
    });

    it('Marketplace should be able to receive AssetNFTs - safeTransferFrom', async function () {
      const { nft, owner, marketplace } = await loadFixture(deploy);

      await nft.createAsset(owner.address, _tokenId, _metadata);

      expect(await nft.ownerOf(_tokenId)).to.equal(owner.address);

      // This is the syntax of calling overloaded functions
      await nft['safeTransferFrom(address,address,uint256)'](
        owner.address,
        marketplace.address,
        _tokenId,
      );

      expect(await nft.ownerOf(_tokenId)).to.equal(marketplace.address);
    });

    it('Non receiver marketplace should be able to receive AssetNFTs - transferFrom', async function () {
      const { nft, owner, nonReceiverMarketplace } = await loadFixture(deploy);

      await nft.createAsset(owner.address, _tokenId, _metadata);

      expect(await nft.ownerOf(_tokenId)).to.equal(owner.address);

      // This is the syntax of calling overloaded functions
      await nft.transferFrom(
        owner.address,
        nonReceiverMarketplace.address,
        _tokenId,
      );

      expect(await nft.ownerOf(_tokenId)).to.equal(
        nonReceiverMarketplace.address,
      );
    });
  });

  describe('Failed', function () {
    it('Safe transfer AssetNFT to non-receiver address', async function () {
      const { nft, owner, nonReceiverMarketplace } = await loadFixture(deploy);

      await nft.createAsset(owner.address, _tokenId, _metadata);

      expect(await nft.ownerOf(_tokenId)).to.equal(owner.address);

      await expect(
        nft['safeTransferFrom(address,address,uint256)'](
          owner.address,
          nonReceiverMarketplace.address,
          _tokenId,
        ),
      ).to.be.rejectedWith(
        'ERC721: transfer to non ERC721Receiver implementer',
      );
    });
  });
});
