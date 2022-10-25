const hre = require('hardhat');

const _decimals = 2;

// Start of initial Metadata for AssetNFT
const _factoringFee = [
  '0.50',
  '0.75',
  '1.00',
  '1.50',
  '2.00',
  '1.75',
  '2.27',
  '2.27',
  '2.27',
  '2.27',
  '0.50', // Error test case value
];
const _discountFee = [
  '5.00',
  '5.00',
  '5.00',
  '5.50',
  '6.00',
  '5.00',
  '7.50',
  '7.50',
  '7.50',
  '7.50',
  '5.00', // Error test case value
];
const _lateFee = [
  '18.00',
  '18.00',
  '18.00',
  '18.00',
  '18.00',
  '18.00',
  '18.00',
  '18.00',
  '18.00',
  '18.00',
  '18.00', // Error test case value
];
const _bankChargesFee = [
  '10',
  '10',
  '10',
  '10',
  '10',
  '10',
  '10',
  '10',
  '10',
  '0',
  '10', // Error test case value
];
const _gracePeriod = [
  '3',
  '5',
  '3',
  '3',
  '3',
  '3',
  '3',
  '3',
  '3',
  '3',
  '3', // Error test case value
];
const _advanceRatio = [
  '85.00',
  '80.00',
  '75.00',
  '80.00',
  '85.00',
  '90.00',
  '80.00',
  '87.00',
  '70.00',
  '90.00',
  '90.00',
];
const _dueDate = [
  '2022-11-12',
  '2022-12-15',
  '2023-01-23',
  '2023-01-30',
  '2023-01-25',
  '2023-02-01',
  '2023-02-15',
  '2023-02-10',
  '2023-01-10',
  '2023-01-10',
  '2022-12-10',
];
const _invoiceDate = [
  '2022-10-10',
  '2022-10-11',
  '2022-10-12',
  '2022-10-13',
  '2022-10-14',
  '2022-10-13',
  '2022-10-14',
  '2022-10-01',
  '2022-10-01',
  '2022-10-01',
  '2022-10-01',
];
const _fundsAdvancedDate = [
  '2022-10-13',
  '2022-10-25',
  '2022-11-05',
  '2022-11-06',
  '2022-11-07',
  '2022-11-15',
  '2022-11-30',
  '2022-11-01',
  '2022-11-01',
  '2022-11-01',
  '2022-12-01',
];
const _invoiceAmount = [
  '10000',
  '10000',
  '10000',
  '10000',
  '10000',
  '10000',
  '10000',
  '10000',
  '10000',
  '10000',
  '10000',
];
const _invoiceLimit = [
  '10000',
  '9000',
  '8000',
  '8000',
  '7000',
  '10000',
  '8500',
  '5000',
  '8000',
  '8000',
  '7560',
];
// End of initial Metadata for AssetNFT

const _invoiceTenure = [
  '33',
  '65',
  '103',
  '109',
  '103',
  '111',
  '124',
  '132',
  '101',
  '101',
  '70',
];
const _advancedAmount = [
  '8500.0',
  '7200.0',
  '6000.0',
  '6400.0',
  '5950.0',
  '9000.0',
  '6800.0',
  '4350.0',
  '5600.0',
  '7200.0',
  '6804.0',
];
const _reserveAmount = [
  '1500.0',
  '2800.0',
  '4000.0',
  '3600.0',
  '4050.0',
  '1000.0',
  '3200.0',
  '5650.0',
  '4400.0',
  '2800.0',
  '3196.0',
];
const _paymentReceiptDate = [
  '2022-11-15',
  '2022-12-22',
  '2023-01-20',
  '2023-02-02',
  '2023-01-21',
  '2023-02-05',
  '2023-02-10',
  '2023-03-10',
  '2023-03-10',
  '2023-02-10',
  '2023-02-10', // Error test case value
];
const _numberOfLateDays = [
  '0',
  '2',
  '0',
  '0',
  '0',
  '1',
  '0',
  '25',
  '56',
  '28',
  '28', // Error test case value
];
const _financeTenure = [
  '33',
  '58',
  '76',
  '88',
  '75',
  '82',
  '72',
  '129',
  '129',
  '101',
  '101', // Error test case value
];
const _lateAmount = [
  '0.0',
  '7.1',
  '0.0',
  '0.0',
  '0.0',
  '4.43',
  '0.0',
  '53.63',
  '154.65',
  '99.41',
  '99.41', // Error test case value
];
const _discountAmount = [
  '38.42',
  '55.23',
  '62.46',
  '84.86',
  '73.35',
  '99.86',
  '100.6',
  '92.95',
  '84.0',
  '108.0',
  '108.0', // Error test case value
];
const _factoringAmount = [
  '50.0',
  '75.0',
  '100.0',
  '150.0',
  '200.0',
  '175.0',
  '227.0',
  '227.0',
  '227.0',
  '227.0',
  '227.0', // Error test case value
];
const _additionalFee = [
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0', // Error test case value
];
const _totalFee = [
  '98.42',
  '140.23',
  '172.46',
  '244.86',
  '283.35',
  '284.86',
  '337.6',
  '329.95',
  '321.0',
  '335.0',
  '335.0', // Error test case value
];
const _netAmountPayableToClient = [
  '1401.58',
  '1659.77',
  '3827.54',
  '1355.14',
  '3766.65',
  '1715.14',
  '3862.4',
  '-679.95',
  '0.0',
  '-335.0',
  '0.0', // Error test case value
];
const _buyerAmountReceived = [
  '10000.0',
  '9000.0',
  '8000.0',
  '6000.0',
  '5000.0',
  '11000.0',
  '11000.0',
  '3500.0',
  '0.0',
  '0.0',
  '0.0', // Error test case value
];
const _supplierAmountReceived = [
  '0.0',
  '0.0',
  '2000.0',
  '2000.0',
  '5000.0',
  '0.0',
  '0.0',
  '500.0',
  '5921.0',
  '7200.0',
  '7200.0', // Error test case value
];
const _totalAmountReceived = [
  '10000.0',
  '9000.0',
  '10000.0',
  '8000.0',
  '10000.0',
  '11000.0',
  '11000.0',
  '4000.0',
  '5921.0',
  '7200.0',
  '7200.0', // Error test case value
];
const _shortExcessPaymentReceived = [
  '0',
  '-1000',
  '0',
  '-2000',
  '0',
  '1000',
  '1000',
  '-6000',
  '-4079',
  '-2800',
  '1000', // Error test case value
];

exports.getCase = function getCase(caseNumber) {
  const testCase = {
    invoiceDate: new Date(_invoiceDate[caseNumber]).getTime() / 1000,
    fundsAdvancedDate:
      new Date(_fundsAdvancedDate[caseNumber]).getTime() / 1000,
    dueDate: new Date(_dueDate[caseNumber]).getTime() / 1000,
    paymentReceiptDate:
      new Date(_paymentReceiptDate[caseNumber]).getTime() / 1000,
    gracePeriod: _gracePeriod[caseNumber],
    invoiceAmount: hre.ethers.utils.parseUnits(
      _invoiceAmount[caseNumber],
      _decimals,
    ),
    invoiceLimit: hre.ethers.utils.parseUnits(
      _invoiceLimit[caseNumber],
      _decimals,
    ),
    invoiceTenure: _invoiceTenure[caseNumber],
    advanceRatio: hre.ethers.utils.parseUnits(
      _advanceRatio[caseNumber],
      _decimals,
    ),
    advancedAmount: hre.ethers.utils.parseUnits(
      _advancedAmount[caseNumber],
      _decimals,
    ),
    reserveAmount: hre.ethers.utils.parseUnits(
      _reserveAmount[caseNumber],
      _decimals,
    ),
    numberOfLateDays: _numberOfLateDays[caseNumber],
    financeTenure: _financeTenure[caseNumber],
    lateFee: hre.ethers.utils.parseUnits(_lateFee[caseNumber], _decimals),
    _lateAmount: hre.ethers.utils.parseUnits(
      _lateAmount[caseNumber],
      _decimals,
    ),
    discountFee: hre.ethers.utils.parseUnits(
      _discountFee[caseNumber],
      _decimals,
    ),
    factoringFee: hre.ethers.utils.parseUnits(
      _factoringFee[caseNumber],
      _decimals,
    ),
    discountAmount: hre.ethers.utils.parseUnits(
      _discountAmount[caseNumber],
      _decimals,
    ),
    factoringAmount: hre.ethers.utils.parseUnits(
      _factoringAmount[caseNumber],
      _decimals,
    ),
    additionalFee: hre.ethers.utils.parseUnits(
      _additionalFee[caseNumber],
      _decimals,
    ),
    bankChargesFee: hre.ethers.utils.parseUnits(
      _bankChargesFee[caseNumber],
      _decimals,
    ),
    totalFee: hre.ethers.utils.parseUnits(_totalFee[caseNumber], _decimals),
    netAmountPayableToClient: hre.ethers.utils.parseUnits(
      _netAmountPayableToClient[caseNumber],
      _decimals,
    ),
    buyerAmountReceived: hre.ethers.utils.parseUnits(
      _buyerAmountReceived[caseNumber],
      _decimals,
    ),
    supplierAmountReceived: hre.ethers.utils.parseUnits(
      _supplierAmountReceived[caseNumber],
      _decimals,
    ),
    totalAmountReceived: hre.ethers.utils.parseUnits(
      _totalAmountReceived[caseNumber],
      _decimals,
    ),
    shortExcessPaymentReceived: hre.ethers.utils.parseUnits(
      _shortExcessPaymentReceived[caseNumber],
      _decimals,
    ),
  };

  return testCase;
};

exports.getValues = function getValues(caseNumber) {
  const testValues = {
    invoiceDate: _invoiceDate[caseNumber],
    fundsAdvancedDate: _fundsAdvancedDate[caseNumber],
    dueDate: _dueDate[caseNumber],
    paymentReceiptDate: _paymentReceiptDate[caseNumber],
    gracePeriod: _gracePeriod[caseNumber],

    invoiceAmount: _invoiceAmount[caseNumber],

    invoiceLimit: _invoiceLimit[caseNumber],

    invoiceTenure: _invoiceTenure[caseNumber],

    advanceRatio: _advanceRatio[caseNumber],

    advancedAmount: _advancedAmount[caseNumber],

    reserveAmount: _reserveAmount[caseNumber],

    numberOfLateDays: _numberOfLateDays[caseNumber],

    financeTenure: _financeTenure[caseNumber],

    lateFee: _lateFee[caseNumber],
    lateAmount: _lateAmount[caseNumber],

    discountFee: _discountFee[caseNumber],

    factoringFee: _factoringFee[caseNumber],

    discountAmount: _discountAmount[caseNumber],

    factoringAmount: _factoringAmount[caseNumber],

    additionalFee: _additionalFee[caseNumber],

    bankChargesFee: _bankChargesFee[caseNumber],

    totalFee: _totalFee[caseNumber],
    netAmountPayableToClient: _netAmountPayableToClient[caseNumber],

    buyerAmountReceived: _buyerAmountReceived[caseNumber],

    supplierAmountReceived: _supplierAmountReceived[caseNumber],

    totalAmountReceived: _totalAmountReceived[caseNumber],

    shortExcessPaymentReceived: _shortExcessPaymentReceived[caseNumber],
  };

  return testValues;
};
