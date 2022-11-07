// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title The main interface to calculate all formulas related to Asset NFT
 * @author Polytrade.Finance
 * @dev Collection of all functions related to Asset NFT formulas
 */
interface IFormulas {
    /**
     * @dev Calculate the discount amount:
     * (Discount Fee (%) * (Advanced Amount / 365) * (Finance Tenure - Late Days))
     * @return uint Amount of the Discount
     * @param _discountFee uint16 input from user
     * @param _financeTenure uint16 input from user
     * @param _lateDays uint16 calculated based on user inputs
     * @param _advancedAmount uint calculated based on user inputs
     */

    function discountAmountCalculation(
        uint24 _discountFee,
        uint16 _financeTenure,
        uint16 _lateDays,
        uint _advancedAmount
    ) external pure returns (uint);

    /**
     * @dev Calculate the advanced amount: (Invoice Limit * Advance Ratio)
     * @return uint Advanced Amount
     * @param _invoiceLimit uint input from user
     * @param _advanceRatio uint16 input from user
     */
    function advancedAmountCalculation(uint _invoiceLimit, uint16 _advanceRatio)
        external
        pure
        returns (uint);

    /**
     * @dev Calculate the factoring amount: (Invoice Amount * Factoring Fee)
     * @return uint Factoring Amount
     * @param _invoiceAmount uint input from user
     * @param _factoringFee uint24 input from user
     */
    function factoringAmountCalculation(
        uint _invoiceAmount,
        uint24 _factoringFee
    ) external pure returns (uint);

    /**
     * @dev Calculate the late amount: (Late Fee (%) * (Advanced Amount / 365) * Late Days)
     * @return uint Late Amount
     * @param _lateFee uint24 input from user
     * @param _lateDays uint16 calculated based on user inputs
     * @param _advancedAmount uint calculated based on user inputs
     */
    function lateAmountCalculation(
        uint24 _lateFee,
        uint16 _lateDays,
        uint _advancedAmount
    ) external pure returns (uint);

    /**
     * @dev Calculate the net amount payable to the client:
     * (Total amount received – Advanced amount – Total Fees)
     * @return uint Net Amount Payable to the Client
     * @param _totalAmountReceived uint calculated based on user inputs
     * @param _advancedAmount uint calculated based on user inputs
     * @param _totalFees uint24 calculated based on user inputs
     */
    function netAmountPayableToClientCalculation(
        uint _totalAmountReceived,
        uint _advancedAmount,
        uint _totalFees
    ) external pure returns (int);

    /**
     * @dev Calculate the number of late days: (Payment Receipt Date - Due Date - Grace Period)
     * @notice Number of late days will never be less than ‘0’
     * @return uint16 Number of Late Days
     * @param _paymentReceiptDate uint48 input from user or can be set automatically
     * @param _dueDate uint48 input from user
     * @param _gracePeriod uint16 input from user
     */
    function lateDaysCalculation(
        uint48 _paymentReceiptDate,
        uint48 _dueDate,
        uint16 _gracePeriod
    ) external pure returns (uint16);

    /**
     * @dev Calculate the invoice tenure: (Due Date - Invoice Date)
     * @return uint16 Invoice Tenure
     * @param _dueDate uint48 input from user
     * @param _invoiceDate uint48 input from user
     */
    function invoiceTenureCalculation(uint48 _dueDate, uint48 _invoiceDate)
        external
        pure
        returns (uint16);

    /**
     * @dev Calculate the reserve amount: (Invoice Amount - Advanced Amount)
     * @return uint Reserve Amount
     * @param _invoiceAmount uint input from user
     * @param _advancedAmount uint calculated based on user inputs
     */
    function reserveAmountCalculation(uint _invoiceAmount, uint _advancedAmount)
        external
        pure
        returns (uint);

    /**
     * @dev Calculate the finance tenure: (Payment Receipt Date - Date of Funds Advanced)
     * @return uint16 Finance Tenure
     * @param _paymentReceiptDate uint48 input from user
     * @param _fundsAdvancedDate uint48 input from user
     */
    function financeTenureCalculation(
        uint48 _paymentReceiptDate,
        uint48 _fundsAdvancedDate
    ) external pure returns (uint16);

    /**
     * @dev Calculate the total fees amount:
     * (Factoring Amount + Discount Amount + Additional Fee + Bank Charges Fee)
     * @return uint Total Amount
     * @param _factoringAmount uint input from user
     * @param _discountAmount uint input from user
     * @param _additionalFee uint input from user
     * @param _bankChargesFee uint input from user
     */
    function totalFeesCalculation(
        uint _factoringAmount,
        uint _discountAmount,
        uint _additionalFee,
        uint _bankChargesFee
    ) external pure returns (uint);

    /**
     * @dev Calculate the total amount received:
     * (Amount Received from Buyer + Amount Received from Supplier)
     * @return uint Total Received Amount
     * @param _buyerAmountReceived uint input from user
     * @param _supplierAmountReceived uint input from user
     */
    function totalAmountReceivedCalculation(
        uint _buyerAmountReceived,
        uint _supplierAmountReceived
    ) external pure returns (uint);
}
