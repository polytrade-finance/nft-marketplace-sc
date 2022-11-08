/* eslint-disable no-unused-vars */
const { loadFixture } = require('@nomicfoundation/hardhat-network-helpers');
const { expect } = require('chai');
const hre = require('hardhat');
const { default: CONTRACTS } = require('../configs/contracts.js');
const { default: CONSTANTS } = require('../configs/constants.js');
const { getCase, getValues } = require('../configs/data.js');

describe('AssetNFT', function () {
  const _criticalCaseNumber = 10;
  const _precision = 2;

  const _assetNumber = 0;
  const _tokenIndex = 0;
  const _wrongTokenIndex = 1;
  const _zeroAddress = hre.ethers.constants.AddressZero;

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

    const _metadata = [
      _initialMetadata,
      getCase(_caseNumber).paymentReceiptDate,
      getCase(_caseNumber).buyerAmountReceived,
      getCase(_caseNumber).supplierAmountReceived,
      getCase(_caseNumber).paymentReserveDate,
      getCase(_caseNumber).supplierAmountReserved,
      getCase(_caseNumber).reservePaymentTransactionId,
    ];

    describe(`Statement for test case N#${_caseNumber + 1}`, function () {
      it('Minting a new AssetNFT to the owner - Check balance of the owner', async function () {
        const { nft, owner } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);
          expect(await nft.balanceOf(owner.address)).to.equal(1);
        }
      });

      it('Minting a new AssetNFT to the owner - Check the ownership of the new NFT', async function () {
        const { nft, owner } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);
          expect(await nft.ownerOf(_assetNumber)).to.equal(owner.address);
        }
      });

      it('Minting a new AssetNFT to the owner - Check the initial metadata', async function () {
        const { nft, owner } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);

          const metadata = await nft.getAsset(_assetNumber);

          expect(metadata.initialMetadata.factoringFee).to.equal(
            _initialMetadata[0],
          );
          expect(metadata.initialMetadata.discountFee).to.equal(
            _initialMetadata[1],
          );
          expect(metadata.initialMetadata.lateFee).to.equal(
            _initialMetadata[2],
          );
          expect(metadata.initialMetadata.bankChargesFee).to.equal(
            _initialMetadata[3],
          );
          expect(metadata.initialMetadata.additionalFee).to.equal(
            _initialMetadata[4],
          );
          expect(metadata.initialMetadata.gracePeriod).to.equal(
            Number(_initialMetadata[5]),
          );
          expect(metadata.initialMetadata.advanceRatio).to.equal(
            _initialMetadata[6],
          );
          expect(metadata.initialMetadata.dueDate).to.equal(
            _initialMetadata[7],
          );
          expect(metadata.initialMetadata.invoiceDate).to.equal(
            _initialMetadata[8],
          );
          expect(metadata.initialMetadata.fundsAdvancedDate).to.equal(
            _initialMetadata[9],
          );
          expect(metadata.initialMetadata.invoiceAmount).to.equal(
            _initialMetadata[10],
          );
          expect(metadata.initialMetadata.invoiceLimit).to.equal(
            _initialMetadata[11],
          );
        }
      });

      it('Minting a new AssetNFT to the other address - Check the token by index', async function () {
        const { nft, otherAddress } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(
              otherAddress.address,
              _assetNumber,
              _initialMetadata,
            ),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(
            otherAddress.address,
            _assetNumber,
            _initialMetadata,
          );
          expect(await nft.tokenByIndex(_tokenIndex)).to.equal(_assetNumber);
        }
      });

      it('Minting a new AssetNFT to the other address - Check the token of owner by index', async function () {
        const { nft, otherAddress } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(
              otherAddress.address,
              _assetNumber,
              _initialMetadata,
            ),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(
            otherAddress.address,
            _assetNumber,
            _initialMetadata,
          );

          expect(
            await nft.tokenOfOwnerByIndex(otherAddress.address, _tokenIndex),
          ).to.equal(_assetNumber);
        }
      });

      it('Set the rest of metadata - Check all the metadata', async function () {
        const { nft, owner } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);

          await nft.setAdditionalMetadata(
            _assetNumber,
            _metadata[2],
            _metadata[3],
            _metadata[1],
          );

          const metadata = await nft.getAsset(_assetNumber);

          expect(metadata.paymentReceiptDate).to.equal(_metadata[1]);
          expect(metadata.buyerAmountReceived).to.equal(_metadata[2]);
          expect(metadata.supplierAmountReceived).to.equal(_metadata[3]);
        }
      });
    });

    describe(`Formulas calculation from the AssetNFT for test case N#${
      _caseNumber + 1
    }`, function () {
      it('Calculate late days', async function () {
        const { nft, owner } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);

          await nft.setAdditionalMetadata(
            _assetNumber,
            _metadata[2],
            _metadata[3],
            _metadata[1],
          );

          const lateDays = await nft.calculateLateDays(_assetNumber);

          expect(lateDays).to.equal(
            Number(getValues(_caseNumber).numberOfLateDays),
          );
        }
      });

      it('Calculate discount amount', async function () {
        const { nft, owner } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);

          await nft.setAdditionalMetadata(
            _assetNumber,
            _metadata[2],
            _metadata[3],
            _metadata[1],
          );

          const discountAmount = hre.ethers.utils.formatUnits(
            await nft.calculateDiscountAmount(_assetNumber),
            _precision,
          );

          expect(discountAmount).to.equal(
            getValues(_caseNumber).discountAmount,
          );
        }
      });

      it('Calculate late amount', async function () {
        const { nft, owner } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);

          await nft.setAdditionalMetadata(
            _assetNumber,
            _metadata[2],
            _metadata[3],
            _metadata[1],
          );

          const lateAmount = hre.ethers.utils.formatUnits(
            await nft.calculateLateAmount(_assetNumber),
            _precision,
          );

          expect(lateAmount).to.equal(getValues(_caseNumber).lateAmount);
        }
      });

      it('Calculate advanced amount', async function () {
        const { nft, owner } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);

          await nft.setAdditionalMetadata(
            _assetNumber,
            _metadata[2],
            _metadata[3],
            _metadata[1],
          );

          const advancedAmount = hre.ethers.utils.formatUnits(
            await nft.calculateAdvancedAmount(_assetNumber),
            _precision,
          );

          expect(advancedAmount).to.equal(
            getValues(_caseNumber).advancedAmount,
          );
        }
      });

      it('Calculate factoring amount', async function () {
        const { nft, owner } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);

          await nft.setAdditionalMetadata(
            _assetNumber,
            _metadata[2],
            _metadata[3],
            _metadata[1],
          );

          const factoringAmount = hre.ethers.utils.formatUnits(
            await nft.calculateFactoringAmount(_assetNumber),
            _precision,
          );

          expect(factoringAmount).to.equal(
            getValues(_caseNumber).factoringAmount,
          );
        }
      });

      it('Calculate invoice tenure', async function () {
        const { nft, owner } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);

          await nft.setAdditionalMetadata(
            _assetNumber,
            _metadata[2],
            _metadata[3],
            _metadata[1],
          );

          const invoiceTenure = await nft.calculateInvoiceTenure(_assetNumber);

          expect(invoiceTenure).to.equal(
            Number(getValues(_caseNumber).invoiceTenure),
          );
        }
      });

      it('Calculate reserve amount', async function () {
        const { nft, owner } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);

          await nft.setAdditionalMetadata(
            _assetNumber,
            _metadata[2],
            _metadata[3],
            _metadata[1],
          );

          const reserveAmount = hre.ethers.utils.formatUnits(
            await nft.calculateReserveAmount(_assetNumber),
            _precision,
          );

          expect(reserveAmount).to.equal(getValues(_caseNumber).reserveAmount);
        }
      });

      it('Calculate finance tenure', async function () {
        const { nft, owner } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);

          await nft.setAdditionalMetadata(
            _assetNumber,
            _metadata[2],
            _metadata[3],
            _metadata[1],
          );

          const financeTenure = await nft.calculateFinanceTenure(_assetNumber);

          expect(financeTenure).to.equal(
            Number(getValues(_caseNumber).financeTenure),
          );
        }
      });

      it('Calculate total fees', async function () {
        const { nft, owner } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);

          await nft.setAdditionalMetadata(
            _assetNumber,
            _metadata[2],
            _metadata[3],
            _metadata[1],
          );

          const totalFees = hre.ethers.utils.formatUnits(
            await nft.calculateTotalFees(_assetNumber),
            _precision,
          );

          expect(totalFees).to.equal(getValues(_caseNumber).totalFee);
        }
      });

      it('Calculate net amount payable to the client', async function () {
        const { nft, owner } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);

          await nft.setAdditionalMetadata(
            _assetNumber,
            _metadata[2],
            _metadata[3],
            _metadata[1],
          );

          const netAmountPayableToClient = hre.ethers.utils.formatUnits(
            await nft.calculateNetAmountPayableToClient(_assetNumber),
            _precision,
          );

          expect(netAmountPayableToClient).to.equal(
            getValues(_caseNumber).netAmountPayableToClient,
          );
        }
      });

      it('Calculate total amount received', async function () {
        const { nft, owner } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);

          await nft.setAdditionalMetadata(
            _assetNumber,
            _metadata[2],
            _metadata[3],
            _metadata[1],
          );

          const totalAmountReceived = hre.ethers.utils.formatUnits(
            await nft.calculateTotalAmountReceived(_assetNumber),
            _precision,
          );

          expect(totalAmountReceived).to.equal(
            getValues(_caseNumber).totalAmountReceived,
          );
        }
      });

      it('Calculate late days without set the payment receipt date', async function () {
        const { nft, owner } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);

          await nft.setAdditionalMetadata(
            _assetNumber,
            _metadata[2],
            _metadata[3],
            0,
          );

          expect(await nft.calculateLateDays(_assetNumber)).to.equal(0);
        }
      });

      it('Calculate finance tenure without set the payment receipt date', async function () {
        const { nft, owner } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);

          await nft.setAdditionalMetadata(
            _assetNumber,
            _metadata[2],
            _metadata[3],
            0,
          );

          const financeTenure = await nft.calculateFinanceTenure(_assetNumber);
          const invoiceTenure = await nft.calculateInvoiceTenure(_assetNumber);

          expect(financeTenure).to.equal(invoiceTenure);
        }
      });

      it('Set asset URI', async function () {
        const { nft, owner } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);

          await nft.setBaseURI(CONSTANTS.NFT_BASE_URI);

          const assetURI = await nft.tokenURI(_assetNumber);

          expect(assetURI).to.equal(`${CONSTANTS.NFT_BASE_URI}${_assetNumber}`);
        }
      });
    });

    describe(`Failed for test case N#${_caseNumber + 1}`, function () {
      it('Minting a new AssetNFT with the same asset number twice', async function () {
        const { nft, owner } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);

          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.revertedWith('ERC721: token already minted');
        }
      });

      it('Minting a new AssetNFT by another address than the owner', async function () {
        const { nft, otherAddress } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(
              otherAddress.address,
              _assetNumber,
              _initialMetadata,
            ),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await expect(
            nft
              .connect(otherAddress)
              .createAsset(
                otherAddress.address,
                _assetNumber,
                _initialMetadata,
              ),
          ).to.be.rejectedWith('Ownable: caller is not the owner');
        }
      });

      it('Minting a new AssetNFT to another address and check the token index', async function () {
        const { nft, otherAddress } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(
              otherAddress.address,
              _assetNumber,
              _initialMetadata,
            ),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(
            otherAddress.address,
            _assetNumber,
            _initialMetadata,
          );

          await expect(nft.tokenByIndex(_wrongTokenIndex)).to.be.rejectedWith(
            'ERC721Enumerable: global index out of bounds',
          );
        }
      });

      it('Minting a new AssetNFT to another address and check the token index by owner', async function () {
        const { nft, otherAddress } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(
              otherAddress.address,
              _assetNumber,
              _initialMetadata,
            ),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(
            otherAddress.address,
            _assetNumber,
            _initialMetadata,
          );

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
          getCase(_criticalCaseNumber).additionalFee,
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
        ).to.be.rejectedWith('Asset due within 20 days');
      });

      it('Minting a new AssetNFT to the zero address', async function () {
        const { nft } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(_zeroAddress, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await expect(
            nft.createAsset(_zeroAddress, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('ERC721: mint to the zero address');
        }
      });

      it('Set the additional metadata by other address than the owner', async function () {
        const { nft, otherAddress } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(
              otherAddress.address,
              _assetNumber,
              _initialMetadata,
            ),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await expect(
            nft
              .connect(otherAddress)
              .setAdditionalMetadata(
                _assetNumber,
                _metadata[2],
                _metadata[3],
                _metadata[1],
              ),
          ).to.be.rejectedWith('Ownable: caller is not the owner');
        }
      });

      it('Settle an asset by other address than the owner', async function () {
        const { nft, otherAddress } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(
              otherAddress.address,
              _assetNumber,
              _initialMetadata,
            ),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await expect(
            nft
              .connect(otherAddress)
              .setAssetSettledMetadata(
                _assetNumber,
                _metadata[5],
                _metadata[6],
                _metadata[4],
              ),
          ).to.be.rejectedWith('Ownable: caller is not the owner');
        }
      });

      it('Set the additional metadata for a settled Asset', async function () {
        const { nft, owner } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);

          await nft.setAssetSettledMetadata(
            _assetNumber,
            _metadata[5],
            _metadata[6],
            _metadata[4],
          );

          await expect(
            nft.setAdditionalMetadata(
              _assetNumber,
              _metadata[2],
              _metadata[3],
              _metadata[1],
            ),
          ).to.be.rejectedWith('Asset is already settled');
        }
      });

      it('Settle an asset is already settled', async function () {
        const { nft, owner } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);

          await nft.setAssetSettledMetadata(
            _assetNumber,
            _metadata[5],
            _metadata[6],
            _metadata[4],
          );

          await expect(
            nft.setAssetSettledMetadata(
              _assetNumber,
              _metadata[5],
              _metadata[6],
              _metadata[4],
            ),
          ).to.be.rejectedWith('Asset is already settled');
        }
      });
    });
  }
});
