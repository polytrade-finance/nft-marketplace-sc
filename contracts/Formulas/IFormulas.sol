// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

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
     * @param _discountFee, uint input from user
     * @param _financeTenure, uint input from user
     * @param _lateDays, uint calculated based on user inputs
     * @param _advancedAmount, uint calculated based on user inputs
     */

    function discountAmountCalculation(
        uint _discountFee,
        uint _financeTenure,
        uint _lateDays,
        uint _advancedAmount
    ) external pure returns (uint);

    /**
     * @dev Calculate the advanced amount: (Invoice Limit * Advance Ratio)
     * @return uint Advanced Amount
     * @param _invoiceLimit, uint input from user
     * @param _advanceRatio, uint input from user
     */
    function advancedAmountCalculation(uint _invoiceLimit, uint _advanceRatio)
        external
        pure
        returns (uint);

    /**
     * @dev Calculate the factoring amount: (Invoice Amount * Factoring Fee)
     * @return uint Factoring Amount
     * @param _invoiceAmount, uint input from user
     * @param _factoringFee, uint input from user
     */
    function factoringAmountCalculation(uint _invoiceAmount, uint _factoringFee)
        external
        pure
        returns (uint);

    /**
     * @dev Calculate the late amount: (Late Fee (%) * (Advanced Amount / 365) * Late Days)
     * @return uint Late Amount
     * @param _lateFee, uint input from user
     * @param _lateDays, uint calculated based on user inputs
     * @param _advancedAmount, uint calculated based on user inputs
     */
    function lateAmountCalculation(
        uint _lateFee,
        uint _lateDays,
        uint _advancedAmount
    ) external pure returns (uint);

    /**
     * @dev Calculate the number of late days: (Payment Receipt Date - Due Date - Grace Period)
     * @notice Number of late days will never be less than ‘0’
     * @return uint Number of Late Days
     * @param _paymentReceiptDate, uint input from user or can be set automatically
     * @param _dueDate, uint input from user
     * @param _gracePeriod, uint input from user
     */
    function lateDaysCalculation(
        uint _paymentReceiptDate,
        uint _dueDate,
        uint _gracePeriod
    ) external pure returns (uint);

    /**
     * @dev Calculate the invoice tenure: (Due Date - Invoice Date)
     * @return uint Invoice Tenure
     * @param _dueDate, uint input from user
     * @param _invoiceDate, uint4 input from user
     */
    function invoiceTenureCalculation(uint _dueDate, uint _invoiceDate)
        external
        pure
        returns (uint);

    /**
     * @dev Calculate the reserve amount: (Invoice Amount - Advanced Amount)
     * @return uint Reserve Amount
     * @param _invoiceAmount, uint input from user
     * @param _advancedAmount, uint calculated based on user inputs
     */
    function reserveAmountCalculation(uint _invoiceAmount, uint _advancedAmount)
        external
        pure
        returns (uint);

    /**
     * @dev Calculate the finance tenure: (Payment Receipt Date - Date of Funds Advanced)
     * @return uint Finance Tenure
     * @param _paymentReceiptDate, uint input from user
     * @param _fundsAdvancedDate, uint input from user
     */
    function financeTenureCalculation(
        uint _paymentReceiptDate,
        uint _fundsAdvancedDate
    ) external pure returns (uint);

    /**
     * @dev Calculate the total fees amount:
     * (Factoring Amount + Discount Amount + Additional Fee + Bank Charges Fee)
     * @return uint Total Amount
     * @param _factoringAmount, uint input from user
     * @param _discountAmount, uint input from user
     * @param _additionalFee, uint input from user
     * @param _bankChargesFee, uint input from user
     */
    function totalFeesCalculation(
        uint _factoringAmount,
        uint _discountAmount,
        uint _additionalFee,
        uint _bankChargesFee
    ) external pure returns (uint);

    /**
     * @dev Calculate the net amount payable to the client:
     * (Total amount received – Advanced amount – Total Fees)
     * @return uint Net Amount Payable to the Client
     * @param _totalAmountReceived, uint calculated based on user inputs
     * @param _advancedAmount, uint calculated based on user inputs
     * @param _totalFees, uint calculated based on user inputs
     */
    function netAmountPayableToClientCalculation(
        uint _totalAmountReceived,
        uint _advancedAmount,
        uint _totalFees
    ) external pure returns (int);

    /**
     * @dev Calculate the total amount received:
     * (Amount Received from Buyer + Amount Received from Supplier)
     * @return uint Total Received Amount
     * @param _buyerAmountReceived, uint input from user
     * @param _supplierAmountReceived, uint input from user
     */
    function totalAmountReceivedCalculation(
        uint _buyerAmountReceived,
        uint _supplierAmountReceived
    ) external pure returns (uint);
}
