/* eslint-disable no-unused-vars */
const { loadFixture } = require('@nomicfoundation/hardhat-network-helpers');
const { expect } = require('chai');
const hre = require('hardhat');
const { default: CONTRACTS } = require('../configs/contracts.js');
const { getCase, getValues } = require('../configs/data.js');

describe('Formulas', function () {
  const _precision = 2;

  async function deploy() {
    const Formulas = await hre.ethers.getContractFactory(CONTRACTS.NAMES[3]);
    const formulas = await Formulas.deploy();

    return { formulas };
  }

  for (let index = 0; index <= 9; index++) {
    describe(`Values calculation for test case N#${index + 1}`, function () {
      it('Discount amount', async function () {
        const { formulas } = await loadFixture(deploy);

        const scDiscountAmount = hre.ethers.utils.formatUnits(
          await formulas.discountAmount(
            getCase(index).discountFee,
            getCase(index).financeTenure,
            getCase(index).numberOfLateDays,
            getCase(index).advancedAmount,
          ),
          _precision,
        );

        expect(scDiscountAmount).to.equal(getValues(index).discountAmount);
      });

      it('Late days', async function () {
        const { formulas } = await loadFixture(deploy);

        const scLateDays = hre.ethers.utils.formatUnits(
          await formulas.lateDays(
            getCase(index).paymentReceiptDate,
            getCase(index).dueDate,
            getCase(index).gracePeriod,
          ),
          0,
        );

        expect(scLateDays).to.equal(getValues(index).numberOfLateDays);
      });

      it('Late days without set the payment receipt date', async function () {
        const { formulas } = await loadFixture(deploy);

        const paymentReceiptDate = 0;
        const lateDays = '0';

        const scLateDays = hre.ethers.utils.formatUnits(
          await formulas.lateDays(
            paymentReceiptDate,
            getCase(index).dueDate,
            getCase(index).gracePeriod,
          ),
          0,
        );

        expect(scLateDays).to.equal(lateDays);
      });

      it('Late amount', async function () {
        const { formulas } = await loadFixture(deploy);

        const scLateAmount = hre.ethers.utils.formatUnits(
          await formulas.lateAmount(
            getCase(index).lateFee,
            getCase(index).numberOfLateDays,
            getCase(index).advancedAmount,
          ),
          _precision,
        );

        expect(scLateAmount).to.equal(getValues(index).lateAmount);
      });

      it('Advanced amount', async function () {
        const { formulas } = await loadFixture(deploy);

        const scAdvancedAmount = hre.ethers.utils.formatUnits(
          await formulas.advancedAmount(
            getCase(index).invoiceLimit,
            getCase(index).advanceRatio,
          ),
          _precision,
        );

        expect(scAdvancedAmount).to.equal(getValues(index).advancedAmount);
      });

      it('Factoring amount', async function () {
        const { formulas } = await loadFixture(deploy);

        const scFactoringAmount = hre.ethers.utils.formatUnits(
          await formulas.factoringAmount(
            getCase(index).invoiceAmount,
            getCase(index).factoringFee,
          ),
          _precision,
        );

        expect(scFactoringAmount).to.equal(getValues(index).factoringAmount);
      });

      it('Invoice tenure', async function () {
        const { formulas } = await loadFixture(deploy);

        const scInvoiceTenure = hre.ethers.utils.formatUnits(
          await formulas.invoiceTenure(
            getCase(index).dueDate,
            getCase(index).invoiceDate,
          ),
          0,
        );

        expect(scInvoiceTenure).to.equal(getValues(index).invoiceTenure);
      });

      it('Reserve amount', async function () {
        const { formulas } = await loadFixture(deploy);

        const scReserveAmount = hre.ethers.utils.formatUnits(
          await formulas.reserveAmount(
            getCase(index).invoiceAmount,
            getCase(index).advancedAmount,
          ),
          _precision,
        );

        expect(scReserveAmount).to.equal(getValues(index).reserveAmount);
      });

      it('Finance tenure', async function () {
        const { formulas } = await loadFixture(deploy);

        const scFinanceTenure = hre.ethers.utils.formatUnits(
          await formulas.financeTenure(
            getCase(index).paymentReceiptDate,
            getCase(index).fundsAdvancedDate,
          ),
          0,
        );

        expect(scFinanceTenure).to.equal(getValues(index).financeTenure);
      });

      it('Total fees', async function () {
        const { formulas } = await loadFixture(deploy);

        const scTotalFees = hre.ethers.utils.formatUnits(
          await formulas.totalFees(
            getCase(index).factoringAmount,
            getCase(index).discountAmount,
            getCase(index).additionalFee,
            getCase(index).bankChargesFee,
          ),
          _precision,
        );

        expect(scTotalFees).to.equal(getValues(index).totalFee);
      });

      it('Net amount payable to the client', async function () {
        const { formulas } = await loadFixture(deploy);

        const scNetAmountPayableToClient = hre.ethers.utils.formatUnits(
          await formulas.netAmountPayableToClient(
            getCase(index).totalAmountReceived,
            getCase(index).advancedAmount,
            getCase(index).totalFee,
          ),
          _precision,
        );

        expect(scNetAmountPayableToClient).to.equal(
          getValues(index).netAmountPayableToClient,
        );
      });

      it('Total amount received', async function () {
        const { formulas } = await loadFixture(deploy);

        const scTotalAmountReceived = hre.ethers.utils.formatUnits(
          await formulas.totalAmountReceived(
            getCase(index).buyerAmountReceived,
            getCase(index).supplierAmountReceived,
          ),
          _precision,
        );

        expect(scTotalAmountReceived).to.equal(
          getValues(index).totalAmountReceived,
        );
      });
    });
  }
});
