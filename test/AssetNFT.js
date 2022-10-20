/* eslint-disable no-unused-vars */
const { loadFixture } = require('@nomicfoundation/hardhat-network-helpers');
const { expect } = require('chai');
const hre = require('hardhat');
const { default: CONTRACTS } = require('../configs/contracts.js');
const { default: CONSTANTS } = require('../configs/constants.js');
const { getCase } = require('../configs/data.js');

describe('AssetNFT', function () {
  const _criticalCaseNumber = 10;

  const _assetNumber = 0;
  const _tokenIndex = 0;
  const _wrongTokenIndex = 1;
  const _zeroAddress = '0x0000000000000000000000000000000000000000';

  async function deploy() {
    const [owner, otherAddress] = await hre.ethers.getSigners();

    const NFT = await hre.ethers.getContractFactory(CONTRACTS.NAMES[0]);
    const nft = await NFT.deploy(CONSTANTS.NFT_NAME, CONSTANTS.NFT_SYMBOL);

    return { nft, owner, otherAddress };
  }

  describe('Deployment', function () {
    it('NFT deployment test', async function () {
      const { nft } = await loadFixture(deploy);

      expect(await nft.name()).to.equal(CONSTANTS.NFT_NAME);
      expect(await nft.symbol()).to.equal(CONSTANTS.NFT_SYMBOL);
    });
  });

  for (let index = 0; index <= 10; index++) {
    const _caseNumber = index;
    const _metadata = [
      getCase(_caseNumber).factoringFee,
      getCase(_caseNumber).discountFee,
      getCase(_caseNumber).lateFee,
      getCase(_caseNumber).bankChargesFee,
      getCase(_caseNumber).gracePeriod,
      getCase(_caseNumber).advanceRatio,
      getCase(_caseNumber).dueDate,
      getCase(_caseNumber).invoiceDate,
      getCase(_caseNumber).fundsAdvancedDate,
      getCase(_caseNumber).invoiceAmount,
      getCase(_caseNumber).invoiceLimit,
    ];
    describe(`Statement for test case N#${_caseNumber + 1}`, function () {
      it('Minting a new AssetNFT to the owner - Check balance of the owner', async function () {
        const { nft, owner } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _metadata),
          ).to.be.rejectedWith('Asset cannot be due within less than 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _metadata);
          expect(await nft.balanceOf(owner.address)).to.equal(1);
        }
      });

      it('Minting a new AssetNFT to the owner - Check the ownership of the new NFT', async function () {
        const { nft, owner } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _metadata),
          ).to.be.rejectedWith('Asset cannot be due within less than 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _metadata);
          expect(await nft.ownerOf(_assetNumber)).to.equal(owner.address);
        }
      });

      it('Minting a new AssetNFT to the owner - Check the metadata', async function () {
        const { nft, owner } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _metadata),
          ).to.be.rejectedWith('Asset cannot be due within less than 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _metadata);

          const metadata = await nft.metadata(_assetNumber);

          expect(metadata.initialMetadata.factoringFee).to.equal(_metadata[0]);
          expect(metadata.initialMetadata.discountFee).to.equal(_metadata[1]);
          expect(metadata.initialMetadata.lateFee).to.equal(_metadata[2]);
          expect(metadata.initialMetadata.bankChargesFee).to.equal(
            _metadata[3],
          );
          expect(metadata.initialMetadata.gracePeriod).to.equal(
            Number(_metadata[4]),
          );
          expect(metadata.initialMetadata.advanceRatio).to.equal(_metadata[5]);
          expect(metadata.initialMetadata.dueDate).to.equal(_metadata[6]);
          expect(metadata.initialMetadata.invoiceDate).to.equal(_metadata[7]);
          expect(metadata.initialMetadata.fundsAdvancedDate).to.equal(
            _metadata[8],
          );
          expect(metadata.initialMetadata.invoiceAmount).to.equal(_metadata[9]);
          expect(metadata.initialMetadata.invoiceLimit).to.equal(_metadata[10]);
        }
      });

      it('Minting a new AssetNFT to the other address - Check the token by index', async function () {
        const { nft, otherAddress } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(otherAddress.address, _assetNumber, _metadata),
          ).to.be.rejectedWith('Asset cannot be due within less than 20 days');
        } else {
          await nft.createAsset(otherAddress.address, _assetNumber, _metadata);
          expect(await nft.tokenByIndex(_tokenIndex)).to.equal(_assetNumber);
        }
      });

      it('Minting a new AssetNFT to the other address - Check the token of owner by index', async function () {
        const { nft, otherAddress } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(otherAddress.address, _assetNumber, _metadata),
          ).to.be.rejectedWith('Asset cannot be due within less than 20 days');
        } else {
          await nft.createAsset(otherAddress.address, _assetNumber, _metadata);

          expect(
            await nft.tokenOfOwnerByIndex(otherAddress.address, _tokenIndex),
          ).to.equal(_assetNumber);
        }
      });
    });

    describe(`Failed for test case N#${_caseNumber + 1}`, function () {
      it('Minting a new AssetNFT with the same asset number twice', async function () {
        const { nft, owner } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _metadata),
          ).to.be.rejectedWith('Asset cannot be due within less than 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _metadata);

          await expect(
            nft.createAsset(owner.address, _assetNumber, _metadata),
          ).to.be.revertedWith('ERC721: token already minted');
        }
      });

      it('Minting a new AssetNFT by another address than the owner', async function () {
        const { nft, otherAddress } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(otherAddress.address, _assetNumber, _metadata),
          ).to.be.rejectedWith('Asset cannot be due within less than 20 days');
        } else {
          await expect(
            nft
              .connect(otherAddress)
              .createAsset(otherAddress.address, _assetNumber, _metadata),
          ).to.be.rejectedWith('Ownable: caller is not the owner');
        }
      });

      it('Minting a new AssetNFT to another address and check the token index', async function () {
        const { nft, otherAddress } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(otherAddress.address, _assetNumber, _metadata),
          ).to.be.rejectedWith('Asset cannot be due within less than 20 days');
        } else {
          await nft.createAsset(otherAddress.address, _assetNumber, _metadata);

          await expect(nft.tokenByIndex(_wrongTokenIndex)).to.be.rejectedWith(
            'ERC721Enumerable: global index out of bounds',
          );
        }
      });

      it('Minting a new AssetNFT to another address and check the token index by owner', async function () {
        const { nft, otherAddress } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(otherAddress.address, _assetNumber, _metadata),
          ).to.be.rejectedWith('Asset cannot be due within less than 20 days');
        } else {
          await nft.createAsset(otherAddress.address, _assetNumber, _metadata);

          await expect(
            nft.tokenOfOwnerByIndex(otherAddress.address, _wrongTokenIndex),
          ).to.be.rejectedWith('ERC721Enumerable: owner index out of bounds');
        }
      });

      it('Minting a new AssetNFT that due within less than 20 days', async function () {
        const { nft, otherAddress } = await loadFixture(deploy);
        const _criticalMetadata = [
          getCase(_criticalCaseNumber).factoringFee,
          getCase(_criticalCaseNumber).discountFee,
          getCase(_criticalCaseNumber).lateFee,
          getCase(_criticalCaseNumber).bankChargesFee,
          getCase(_criticalCaseNumber).gracePeriod,
          getCase(_criticalCaseNumber).advanceRatio,
          getCase(_criticalCaseNumber).dueDate,
          getCase(_criticalCaseNumber).invoiceDate,
          getCase(_criticalCaseNumber).fundsAdvancedDate,
          getCase(_criticalCaseNumber).invoiceAmount,
          getCase(_criticalCaseNumber).invoiceLimit,
        ];

        await expect(
          nft.createAsset(
            otherAddress.address,
            _assetNumber,
            _criticalMetadata,
          ),
        ).to.be.rejectedWith('Asset cannot be due within less than 20 days');
      });

      it('Minting a new AssetNFT to the zero address', async function () {
        const { nft } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(_zeroAddress, _assetNumber, _metadata),
          ).to.be.rejectedWith('Asset cannot be due within less than 20 days');
        } else {
          await expect(
            nft.createAsset(_zeroAddress, _assetNumber, _metadata),
          ).to.be.rejectedWith('ERC721: mint to the zero address');
        }
      });
    });
  }
});
