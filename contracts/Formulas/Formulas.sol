// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title The common marketplace for the AssetNFTs
 * @author Polytrade.Finance
 * @dev Collection of functions related to Asset NFT formulas
 */
contract Formulas {
    /**
     * @dev Calculate the number of late days: (Payment Receipt Date - Due Date - Grace Period)
     * @notice Number of late days will never be less than ‘0’
     * @return uint24 Number of Late Days
     * @param _paymentReceiptDate uint24 input from user or can be set automatically
     * @param _dueDate uint24 input from user
     * @param _gracePeriod uint24 input from user
     */
    function lateDays(
        uint24 _paymentReceiptDate,
        uint24 _dueDate,
        uint24 _gracePeriod
    ) external pure returns (uint24) {
        return uint24(_paymentReceiptDate - _dueDate - _gracePeriod) / 1 days;
    }

    /**
     * @dev Calculate the discount amount:
     * (Discount Fee (%) * (Advanced Amount / 365) * (Finance Tenure - Late Days))
     * @return uint Amount of the Discount
     * @param _discountFee uint16 input from user
     * @param _financeTenure uint16 input from user
     * @param _lateDays uint24 calculated based on user inputs
     * @param _advancedAmount uint calculated based on user inputs
     */
    function discountAmount(
        uint16 _discountFee,
        uint16 _financeTenure,
        uint24 _lateDays,
        uint _advancedAmount
    ) external pure returns (uint) {
        return
            _discountFee *
            (_advancedAmount / 365) *
            (_financeTenure * _lateDays);
    }

    /**
     * @dev Calculate the late amount: (Late Fee (%) * (Advanced Amount / 365) * Late Days)
     * @return uint Late Amount
     * @param _lateFee uint16 input from user
     * @param _lateDays uint24 calculated based on user inputs
     * @param _advancedAmount uint calculated based on user inputs
     */
    function lateAmount(
        uint16 _lateFee,
        uint24 _lateDays,
        uint _advancedAmount
    ) external pure returns (uint) {
        return _lateFee * (_advancedAmount / 365) * _lateDays;
    }

    /**
     * @dev Calculate the advanced amount: (Invoice Limit * Advance Ratio)
     * @return uint Advanced Amount
     * @param _invoiceLimit uint input from user
     * @param _advanceRatio uint16 input from user
     */
    function advancedAmount(uint _invoiceLimit, uint16 _advanceRatio)
        external
        pure
        returns (uint)
    {
        return _invoiceLimit * _advanceRatio;
    }

    /**
     * @dev Calculate the factoring amount: (Invoice Amount * Factoring Fee)
     * @return uint Factoring Amount
     * @param _invoiceAmount uint input from user
     * @param _factoringFee uint16 input from user
     */
    function factoringAmount(uint _invoiceAmount, uint16 _factoringFee)
        external
        pure
        returns (uint)
    {
        return _invoiceAmount * _factoringFee;
    }

    /**
     * @dev Calculate the invoice tenure: (Due Date - Invoice Date)
     * @return uint24 Invoice Tenure
     * @param _dueDate uint24 input from user
     * @param _invoiceDate uint24 input from user
     */
    function invoiceTenure(uint24 _dueDate, uint24 _invoiceDate)
        external
        pure
        returns (uint24)
    {
        return uint24(_dueDate - _invoiceDate);
    }

    /**
     * @dev Calculate the reserve amount: (Invoice Amount - Advanced Amount)
     * @return uint Reserve Amount
     * @param _invoiceAmount uint input from user
     * @param _advancedAmount uint calculated based on user inputs
     */
    function reserveAmount(uint _invoiceAmount, uint _advancedAmount)
        external
        pure
        returns (uint)
    {
        return _invoiceAmount - _advancedAmount;
    }

    /**
     * @dev Calculate the finance tenure: (Payment Receipt Date - Date of Funds Advanced)
     * @return uint24 Finance Tenure
     * @param _paymentReceiptDate uint24 input from user
     * @param _fundsAdvancedDate uint24 input from user
     */
    function financeTenure(
        uint24 _paymentReceiptDate,
        uint24 _fundsAdvancedDate
    ) external pure returns (uint24) {
        return uint24(_paymentReceiptDate - _fundsAdvancedDate);
    }

    /**
     * @dev Calculate the total amount: (Factoring Fee + Discount Fee + Late Fee + Bank Charges Additional Fee)
     * @return uint Total Amount
     * @param _factoringFee uint16 input from user
     * @param _discountFee uint16 input from user
     * @param _lateFee uint16 input from user
     * @param _bankChargesAdditionalFee uint16 input from user
     */
    function totalAmount(
        uint16 _factoringFee,
        uint16 _discountFee,
        uint16 _lateFee,
        uint16 _bankChargesAdditionalFee
    ) external pure returns (uint) {
        return
            _factoringFee + _discountFee + _lateFee + _bankChargesAdditionalFee;
    }

    /**
     * @dev Calculate the net amount payable to the client:
     * (Total amount received – Advanced amount – Total Fees)
     * @return uint Net Amount Payable to the Client
     * @param _totalAmountReceived uint calculated based on user inputs
     * @param _advancedAmount uint calculated based on user inputs
     * @param _totalFees uint calculated based on user inputs
     */
    function netAmountPayaleToClient(
        uint _totalAmountReceived,
        uint _advancedAmount,
        uint _totalFees
    ) external pure returns (uint) {
        return _totalAmountReceived - _advancedAmount - _totalFees;
    }

    /**
     * @dev Calculate the total amount received:
     * (Amount Received from Buyer + Amount Received from Supplier)
     * @return uint Total Received Amount
     * @param _buyerAmountReceived uint input from user
     * @param _supplierAmountReceived uint input from user
     */
    function totalAmountReceived(
        uint _buyerAmountReceived,
        uint _supplierAmountReceived
    ) external pure returns (uint) {
        return _buyerAmountReceived + _supplierAmountReceived;
    }
}
