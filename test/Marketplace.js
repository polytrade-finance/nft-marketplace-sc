const { loadFixture } = require('@nomicfoundation/hardhat-network-helpers');
const { expect } = require('chai');
const hre = require('hardhat');
const { default: CONTRACTS } = require('../configs/contracts.js');
const { default: CONSTANTS } = require('../configs/constants.js');
const { getCase } = require('../configs/data.js');

describe('Marketplace', function () {
  const _criticalCaseNumber = 10;
  const _assetNumber = 0;

  const _totalSupply = 1000000;

  async function deploy() {
    const [owner, otherAddress] = await hre.ethers.getSigners();

    const Formulas = await hre.ethers.getContractFactory(CONTRACTS.NAMES[3]);
    const formulas = await Formulas.deploy();

    const NFT = await hre.ethers.getContractFactory(CONTRACTS.NAMES[0]);
    const nft = await NFT.deploy(
      CONSTANTS.NFT_NAME,
      CONSTANTS.NFT_SYMBOL,
      CONSTANTS.NFT_BASE_URI,
      formulas.address,
    );

    const USDT = await hre.ethers.getContractFactory(CONTRACTS.NAMES[4]);
    const usdt = await USDT.deploy(
      CONSTANTS.TOKEN_NAME,
      CONSTANTS.TOKEN_SYMBOL,
      otherAddress.address,
      _totalSupply,
    );

    const Marketplace = await hre.ethers.getContractFactory(CONTRACTS.NAMES[1]);
    const marketplace = await Marketplace.deploy(nft.address, usdt.address);

    const NonReceiverMarketplace = await hre.ethers.getContractFactory(
      CONTRACTS.NAMES[2],
    );
    const nonReceiverMarketplace = await NonReceiverMarketplace.deploy();

    return {
      nft,
      usdt,
      marketplace,
      nonReceiverMarketplace,
      owner,
      otherAddress,
    };
  }

  for (let index = 0; index <= 10; index++) {
    const _caseNumber = index;
    const _initialMetadata = [
      getCase(_caseNumber).factoringFee,
      getCase(_caseNumber).discountFee,
      getCase(_caseNumber).lateFee,
      getCase(_caseNumber).bankChargesFee,
      getCase(_caseNumber).additionalFee,
      getCase(_caseNumber).gracePeriod,
      getCase(_caseNumber).advanceRatio,
      getCase(_caseNumber).dueDate,
      getCase(_caseNumber).invoiceDate,
      getCase(_caseNumber).fundsAdvancedDate,
      getCase(_caseNumber).invoiceAmount,
      getCase(_caseNumber).invoiceLimit,
    ];

    describe(`Statement for test case N#${_caseNumber + 1}`, function () {
      it('Marketplace should be able to receive AssetNFTs - transferFrom', async function () {
        const { nft, owner, marketplace } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due less than 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);

          expect(await nft.ownerOf(_assetNumber)).to.equal(owner.address);

          await nft.transferFrom(
            owner.address,
            marketplace.address,
            _assetNumber,
          );

          expect(await nft.ownerOf(_assetNumber)).to.equal(marketplace.address);
        }
      });

      it('Marketplace should be able to receive AssetNFTs - safeTransferFrom', async function () {
        const { nft, owner, marketplace } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due less than 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);

          expect(await nft.ownerOf(_assetNumber)).to.equal(owner.address);

          // This is the syntax of calling overloaded functions
          await nft['safeTransferFrom(address,address,uint256)'](
            owner.address,
            marketplace.address,
            _assetNumber,
          );

          expect(await nft.ownerOf(_assetNumber)).to.equal(marketplace.address);
        }
      });

      it('Non receiver marketplace should be able to receive AssetNFTs - transferFrom', async function () {
        const { nft, owner, nonReceiverMarketplace } = await loadFixture(
          deploy,
        );

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due less than 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);

          expect(await nft.ownerOf(_assetNumber)).to.equal(owner.address);

          // This is the syntax of calling overloaded functions
          await nft.transferFrom(
            owner.address,
            nonReceiverMarketplace.address,
            _assetNumber,
          );

          expect(await nft.ownerOf(_assetNumber)).to.equal(
            nonReceiverMarketplace.address,
          );
        }
      });

      it('Buy an asset from marketplace', async function () {
        const { nft, owner, usdt, otherAddress, marketplace } =
          await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due less than 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);
          await nft.approve(marketplace.address, _assetNumber);

          expect(await nft.ownerOf(_assetNumber)).to.equal(owner.address);

          const _amount = nft.calculateReserveAmount(_assetNumber);

          await usdt
            .connect(otherAddress)
            .approve(marketplace.address, _amount);

          await marketplace.connect(otherAddress).buy(_assetNumber);

          expect(await nft.ownerOf(_assetNumber)).to.equal(
            otherAddress.address,
          );
        }
      });

      it('Disburse money for an asset NFT', async function () {
        const { nft, owner, marketplace } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due less than 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);

          expect(await marketplace.disburse(_assetNumber)).to.equal(
            await nft.calculateNetAmountPayableToClient(_assetNumber),
          );
        }
      });
    });

    describe(`Failed for test case N#${_caseNumber + 1}`, function () {
      it('Safe transfer AssetNFT to non-receiver address', async function () {
        const { nft, owner, nonReceiverMarketplace } = await loadFixture(
          deploy,
        );

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due less than 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);

          expect(await nft.ownerOf(_assetNumber)).to.equal(owner.address);

          await expect(
            nft['safeTransferFrom(address,address,uint256)'](
              owner.address,
              nonReceiverMarketplace.address,
              _assetNumber,
            ),
          ).to.be.rejectedWith(
            'ERC721: transfer to non ERC721Receiver implementer',
          );
        }
      });

      it('Buy an asset from marketplace without been set for sale', async function () {
        const { nft, owner, otherAddress, marketplace } = await loadFixture(
          deploy,
        );

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due less than 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);

          expect(await nft.ownerOf(_assetNumber)).to.equal(owner.address);

          await expect(
            marketplace.connect(otherAddress).buy(_assetNumber),
          ).to.be.rejectedWith(
            'ERC721: caller is not token owner nor approved',
          );
        }
      });
    });
  }
});
