const { loadFixture } = require('@nomicfoundation/hardhat-network-helpers');
const { expect } = require('chai');
const hre = require('hardhat');
const { default: CONTRACTS } = require('../configs/contracts.js');
const { default: CONSTANTS } = require('../configs/constants.js');
const { getCase } = require('../configs/data.js');

describe('Marketplace', function () {
  const _criticalCaseNumber = 10;
  const _assetNumber = 0;
  const _assetNumber_1 = 1;
  const _assetNumber_2 = 2;
  const _assetNumber_3 = 3;
  const _invalidAssetNumber = 999;

  const _totalSupply = 1000000000;

  async function deploy() {
    const [owner, otherAddress, otherAddress_1] = await hre.ethers.getSigners();

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
      otherAddress_1,
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
          ).to.be.rejectedWith('Asset due within 20 days');
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
          ).to.be.rejectedWith('Asset due within 20 days');
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
          ).to.be.rejectedWith('Asset due within 20 days');
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
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);
          await nft.approve(marketplace.address, _assetNumber);

          expect(await nft.ownerOf(_assetNumber)).to.equal(owner.address);

          const _amount = Number(
            await nft.calculateReserveAmount(_assetNumber),
          );

          await usdt
            .connect(otherAddress)
            .approve(marketplace.address, _amount);

          await marketplace.connect(otherAddress).buy(_assetNumber);

          expect(await nft.ownerOf(_assetNumber)).to.equal(
            otherAddress.address,
          );
        }
      });

      it('Buy multiple assets from marketplace', async function () {
        const { nft, owner, usdt, otherAddress, marketplace } =
          await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          // Create, approve and calculate amount the 1st asset
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);
          await nft.approve(marketplace.address, _assetNumber);
          const _amount = Number(
            await nft.calculateReserveAmount(_assetNumber),
          );

          // Create, approve and calculate amount the 2nd asset
          await nft.createAsset(
            owner.address,
            _assetNumber_1,
            _initialMetadata,
          );
          await nft.approve(marketplace.address, _assetNumber_1);
          const _amount_1 = Number(
            await nft.calculateReserveAmount(_assetNumber_1),
          );

          // Create, approve and calculate amount the 3rd asset
          await nft.createAsset(
            owner.address,
            _assetNumber_2,
            _initialMetadata,
          );
          await nft.approve(marketplace.address, _assetNumber_2);
          const _amount_2 = Number(
            await nft.calculateReserveAmount(_assetNumber_2),
          );

          // Create, approve and calculate amount the 4th asset
          await nft.createAsset(
            owner.address,
            _assetNumber_3,
            _initialMetadata,
          );
          await nft.approve(marketplace.address, _assetNumber_3);
          const _amount_3 = Number(
            await nft.calculateReserveAmount(_assetNumber_3),
          );

          // Approve the total amount for all invoices
          const _totalAmount = _amount + _amount_1 + _amount_2 + _amount_3;
          await usdt
            .connect(otherAddress)
            .approve(marketplace.address, _totalAmount);

          const _assetNumbers = [
            _assetNumber,
            _assetNumber_1,
            _assetNumber_2,
            _assetNumber_3,
          ];

          await marketplace.connect(otherAddress).batchBuy(_assetNumbers);

          expect(await nft.ownerOf(_assetNumber)).to.equal(
            otherAddress.address,
          );
          expect(await nft.ownerOf(_assetNumber_1)).to.equal(
            otherAddress.address,
          );
          expect(await nft.ownerOf(_assetNumber_2)).to.equal(
            otherAddress.address,
          );
          expect(await nft.ownerOf(_assetNumber_3)).to.equal(
            otherAddress.address,
          );
        }
      });

      it('Disburse money for an asset NFT', async function () {
        const { nft, owner, marketplace } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);

          const disbursedAmount = await marketplace.disburse(_assetNumber);

          expect(disbursedAmount).to.equal(
            await nft.calculateNetAmountPayableToClient(_assetNumber),
          );
        }
      });

      it('Set asset NFT address', async function () {
        const { nft, marketplace } = await loadFixture(deploy);

        await marketplace.setAssetNFT(nft.address);

        const assetNFTAddress = await marketplace.getAssetNFT();

        expect(assetNFTAddress).to.equal(nft.address);
      });

      it('Set stable token address', async function () {
        const { usdt, marketplace } = await loadFixture(deploy);

        await marketplace.setStableToken(usdt.address);

        const stableTokenAddress = await marketplace.getStableCoin();

        expect(stableTokenAddress).to.equal(usdt.address);
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
          ).to.be.rejectedWith('Asset due within 20 days');
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
          ).to.be.rejectedWith('Asset due within 20 days');
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

      it('Set asset NFT address', async function () {
        const { otherAddress, nft, marketplace } = await loadFixture(deploy);

        await expect(
          marketplace.connect(otherAddress).setAssetNFT(nft.address),
        ).to.be.rejectedWith('Ownable: caller is not the owner');
      });

      it('Set stable token address', async function () {
        const { otherAddress, usdt, marketplace } = await loadFixture(deploy);

        await expect(
          marketplace.connect(otherAddress).setStableToken(usdt.address),
        ).to.be.rejectedWith('Ownable: caller is not the owner');
      });

      it('Buy an asset NFT that not minted', async function () {
        const { nft, owner, marketplace } = await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await expect(marketplace.buy(_invalidAssetNumber)).to.be.rejectedWith(
            'ERC721: invalid token ID',
          );
        }
      });

      it('Buy an asset with no stable coin allowance', async function () {
        const { nft, owner, otherAddress, marketplace } = await loadFixture(
          deploy,
        );

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);
          await nft.approve(marketplace.address, _assetNumber);

          await expect(
            marketplace.connect(otherAddress).buy(_assetNumber),
          ).to.be.rejectedWith('ERC20: insufficient allowance');
        }
      });

      it('Buy an asset with no enough stable coin allowance', async function () {
        const { nft, usdt, owner, otherAddress, marketplace } =
          await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);
          await nft.approve(marketplace.address, _assetNumber);

          await usdt.connect(otherAddress).approve(marketplace.address, 1);

          await expect(
            marketplace.connect(otherAddress).buy(_assetNumber),
          ).to.be.rejectedWith('ERC20: insufficient allowance');
        }
      });

      it('Buy multiple assets with invalid asset number', async function () {
        const { nft, owner, usdt, otherAddress, marketplace } =
          await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          // Create, approve and calculate amount the 1st asset
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);
          await nft.approve(marketplace.address, _assetNumber);
          const _amount = Number(
            await nft.calculateReserveAmount(_assetNumber),
          );

          // Create, approve and calculate amount the 2nd asset
          await nft.createAsset(
            owner.address,
            _assetNumber_1,
            _initialMetadata,
          );
          await nft.approve(marketplace.address, _assetNumber_1);
          const _amount_1 = Number(
            await nft.calculateReserveAmount(_assetNumber_1),
          );

          // Create, approve and calculate amount the 3rd asset
          await nft.createAsset(
            owner.address,
            _assetNumber_2,
            _initialMetadata,
          );
          await nft.approve(marketplace.address, _assetNumber_2);
          const _amount_2 = Number(
            await nft.calculateReserveAmount(_assetNumber_2),
          );

          // Create, approve the 4th asset
          await nft.createAsset(
            owner.address,
            _assetNumber_3,
            _initialMetadata,
          );
          await nft.approve(marketplace.address, _assetNumber_3);
          const _amount_3 = Number(
            await nft.calculateReserveAmount(_assetNumber_3),
          );

          // Approve the total amount for all invoices
          const _totalAmount = _amount + _amount_1 + _amount_2 + _amount_3;

          await usdt
            .connect(otherAddress)
            .approve(marketplace.address, _totalAmount);

          const _assetNumbers = [
            _assetNumber,
            _assetNumber_1,
            _assetNumber_2,
            _invalidAssetNumber,
          ];

          await expect(
            marketplace.connect(otherAddress).batchBuy(_assetNumbers),
          ).to.be.rejectedWith('ERC721: invalid token ID');
        }
      });

      it('Buy multiple assets without enough allowance', async function () {
        const { nft, owner, usdt, otherAddress, marketplace } =
          await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          // Create, approve and calculate amount the 1st asset
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);
          await nft.approve(marketplace.address, _assetNumber);
          const _amount = Number(
            await nft.calculateReserveAmount(_assetNumber),
          );

          // Create, approve and calculate amount the 2nd asset
          await nft.createAsset(
            owner.address,
            _assetNumber_1,
            _initialMetadata,
          );
          await nft.approve(marketplace.address, _assetNumber_1);
          const _amount_1 = Number(
            await nft.calculateReserveAmount(_assetNumber_1),
          );

          // Create, approve and calculate amount the 3rd asset
          await nft.createAsset(
            owner.address,
            _assetNumber_2,
            _initialMetadata,
          );
          await nft.approve(marketplace.address, _assetNumber_2);
          const _amount_2 = Number(
            await nft.calculateReserveAmount(_assetNumber_2),
          );

          // Create, approve the 4th asset
          await nft.createAsset(
            owner.address,
            _assetNumber_3,
            _initialMetadata,
          );
          await nft.approve(marketplace.address, _assetNumber_3);

          // Approve the total amount for all invoices
          const _totalAmount = _amount + _amount_1 + _amount_2;

          await usdt
            .connect(otherAddress)
            .approve(marketplace.address, _totalAmount);

          const _assetNumbers = [
            _assetNumber,
            _assetNumber_1,
            _assetNumber_2,
            _assetNumber_3,
          ];

          await expect(
            marketplace.connect(otherAddress).batchBuy(_assetNumbers),
          ).to.be.rejectedWith('ERC20: insufficient allowance');
        }
      });

      it('Buy multiple assets without enough balance', async function () {
        const { nft, owner, usdt, otherAddress_1, marketplace } =
          await loadFixture(deploy);

        if (_caseNumber === _criticalCaseNumber) {
          await expect(
            nft.createAsset(owner.address, _assetNumber, _initialMetadata),
          ).to.be.rejectedWith('Asset due within 20 days');
        } else {
          // Create, approve and calculate amount the 1st asset
          await nft.createAsset(owner.address, _assetNumber, _initialMetadata);
          await nft.approve(marketplace.address, _assetNumber);
          const _amount = Number(
            await nft.calculateReserveAmount(_assetNumber),
          );

          // Create, approve and calculate amount the 2nd asset
          await nft.createAsset(
            owner.address,
            _assetNumber_1,
            _initialMetadata,
          );
          await nft.approve(marketplace.address, _assetNumber_1);
          const _amount_1 = Number(
            await nft.calculateReserveAmount(_assetNumber_1),
          );

          // Create, approve and calculate amount the 3rd asset
          await nft.createAsset(
            owner.address,
            _assetNumber_2,
            _initialMetadata,
          );
          await nft.approve(marketplace.address, _assetNumber_2);
          const _amount_2 = Number(
            await nft.calculateReserveAmount(_assetNumber_2),
          );

          // Create, approve the 4th asset
          await nft.createAsset(
            owner.address,
            _assetNumber_3,
            _initialMetadata,
          );
          await nft.approve(marketplace.address, _assetNumber_3);
          const _amount_3 = Number(
            await nft.calculateReserveAmount(_assetNumber_3),
          );

          // Approve the total amount for all invoices
          const _totalAmount = _amount + _amount_1 + _amount_2 + _amount_3;

          await usdt
            .connect(otherAddress_1)
            .approve(marketplace.address, _totalAmount);

          const _assetNumbers = [
            _assetNumber,
            _assetNumber_1,
            _assetNumber_2,
            _assetNumber_3,
          ];

          await expect(
            marketplace.connect(otherAddress_1).batchBuy(_assetNumbers),
          ).to.be.rejectedWith('ERC20: transfer amount exceeds balance');
        }
      });
    });
  }

  describe('Standalone batch buy', function () {
    const _timeout = 100000000;
    const _assetNumbers = [];
    let _totalAmount = 0;
    const _numberOfAssets = 100;

    this.timeout(_timeout);

    const _initialMetadata = [
      getCase(0).factoringFee,
      getCase(0).discountFee,
      getCase(0).lateFee,
      getCase(0).bankChargesFee,
      getCase(0).additionalFee,
      getCase(0).gracePeriod,
      getCase(0).advanceRatio,
      getCase(0).dueDate,
      getCase(0).invoiceDate,
      getCase(0).fundsAdvancedDate,
      getCase(0).invoiceAmount,
      getCase(0).invoiceLimit,
    ];

    it('Buy multiple assets', async function () {
      this.timeout(_timeout);
      const { nft, owner, usdt, otherAddress, marketplace } = await loadFixture(
        deploy,
      );

      for (let i = 0; i < _numberOfAssets; i++) {
        await nft.createAsset(owner.address, i, _initialMetadata);
        await nft.approve(marketplace.address, i);
        const _amount = Number(await nft.calculateReserveAmount(i));
        _assetNumbers.push(i);
        _totalAmount += _amount;
      }

      await usdt
        .connect(otherAddress)
        .approve(marketplace.address, _totalAmount);

      for (let i = 0; i < _numberOfAssets; i++) {
        expect(await nft.ownerOf(i)).to.equal(owner.address);
      }

      await marketplace.connect(otherAddress).batchBuy(_assetNumbers);

      for (let i = 0; i < _numberOfAssets; i++) {
        expect(await nft.ownerOf(i)).to.equal(otherAddress.address);
      }
    });
  });
});
