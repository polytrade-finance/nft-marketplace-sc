// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./IFormulas.sol";

/**
 * @title The implementation of IFormulas interface
 * @author Polytrade.Finance
 * @dev Implementation of all functions related to Asset NFT formulas
 */
contract Formulas is IFormulas {
    uint private constant _PRECISION = 1E4;

    /**
     * @dev Calculate the discount amount:
     * (Discount Fee (%) * (Advanced Amount / 365) * (Finance Tenure - Late Days))
     * @return uint Amount of the Discount
     * @param discountFee uint24 input from user
     * @param financeTenure uint16 input from user
     * @param lateDays uint16 calculated based on user inputs
     * @param advancedAmount uint calculated based on user inputs
     */
    function discountAmountCalculation(
        uint24 discountFee,
        uint16 financeTenure,
        uint16 lateDays,
        uint advancedAmount
    ) external pure returns (uint) {
        return
            (((discountFee * advancedAmount) * (financeTenure - lateDays)) /
                365) / _PRECISION;
    }

    /**
     * @dev Calculate the advanced amount: (Invoice Limit * Advance Ratio)
     * @return uint Advanced Amount
     * @param invoiceLimit uint input from user
     * @param advanceRatio uint16 input from user
     */
    function advancedAmountCalculation(uint invoiceLimit, uint16 advanceRatio)
        external
        pure
        returns (uint)
    {
        return (invoiceLimit * advanceRatio) / _PRECISION;
    }

    /**
     * @dev Calculate the factoring amount: (Invoice Amount * Factoring Fee)
     * @return uint Factoring Amount
     * @param invoiceAmount uint input from user
     * @param factoringFee uint24 input from user
     */
    function factoringAmountCalculation(uint invoiceAmount, uint24 factoringFee)
        external
        pure
        returns (uint)
    {
        return (invoiceAmount * factoringFee) / _PRECISION;
    }

    /**
     * @dev Calculate the late amount: (Late Fee (%) * (Advanced Amount / 365) * Late Days)
     * @return uint Late Amount
     * @param lateFee uint24 input from user
     * @param lateDays uint16 calculated based on user inputs
     * @param advancedAmount uint calculated based on user inputs
     */
    function lateAmountCalculation(
        uint24 lateFee,
        uint16 lateDays,
        uint advancedAmount
    ) external pure returns (uint) {
        return ((lateFee * (advancedAmount) * lateDays) / 365) / _PRECISION;
    }

    /**
     * @dev Calculate the number of late days: (Payment Receipt Date - Due Date - Grace Period)
     * @notice Number of late days will never be less than ‘0’
     * @return uint16 Number of Late Days
     * @param paymentReceiptDate uint48 input from user or can be set automatically
     * @param dueDate uint48 input from user
     * @param gracePeriod uint16 input from user
     */
    function lateDaysCalculation(
        uint48 paymentReceiptDate,
        uint48 dueDate,
        uint16 gracePeriod
    ) external pure returns (uint16) {
        if (paymentReceiptDate < dueDate) return 0;

        return uint16(((paymentReceiptDate - dueDate) / 1 days) - gracePeriod);
    }

    /**
     * @dev Calculate the invoice tenure: (Due Date - Invoice Date)
     * @return uint16 Invoice Tenure
     * @param dueDate uint48 input from user
     * @param invoiceDate uint48 input from user
     */
    function invoiceTenureCalculation(uint48 dueDate, uint48 invoiceDate)
        external
        pure
        returns (uint16)
    {
        return uint16((dueDate - invoiceDate) / 1 days);
    }

    /**
     * @dev Calculate the reserve amount: (Invoice Amount - Advanced Amount)
     * @return uint Reserve Amount
     * @param invoiceAmount uint input from user
     * @param advancedAmount uint calculated based on user inputs
     */
    function reserveAmountCalculation(uint invoiceAmount, uint advancedAmount)
        external
        pure
        returns (uint)
    {
        return invoiceAmount - advancedAmount;
    }

    /**
     * @dev Calculate the finance tenure: (Payment Receipt Date - Date of Funds Advanced)
     * @return uint16 Finance Tenure
     * @param paymentReceiptDate uint48 input from user
     * @param fundsAdvancedDate uint48 input from user
     */
    function financeTenureCalculation(
        uint48 paymentReceiptDate,
        uint48 fundsAdvancedDate
    ) external pure returns (uint16) {
        return uint16((paymentReceiptDate - fundsAdvancedDate) / 1 days);
    }

    /**
     * @dev Calculate the total fees amount:
     * (Factoring Amount + Discount Amount + Additional Fee + Bank Charges Fee)
     * @return uint Total Amount
     * @param factoringAmount uint input from user
     * @param discountAmount uint input from user
     * @param additionalFee uint input from user
     * @param bankChargesFee uint input from user
     */
    function totalFeesCalculation(
        uint factoringAmount,
        uint discountAmount,
        uint additionalFee,
        uint bankChargesFee
    ) external pure returns (uint) {
        return
            factoringAmount + discountAmount + additionalFee + bankChargesFee;
    }

    /**
     * @dev Calculate the net amount payable to the client:
     * (Total amount received – Advanced amount – Total Fees)
     * @return uint Net Amount Payable to the Client
     * @param totalAmountReceived uint calculated based on user inputs
     * @param advancedAmount uint calculated based on user inputs
     * @param totalFees uint24 calculated based on user inputs
     */
    function netAmountPayableToClientCalculation(
        uint totalAmountReceived,
        uint advancedAmount,
        uint totalFees
    ) external pure returns (int) {
        return int(totalAmountReceived) - int(advancedAmount) - int(totalFees);
    }

    /**
     * @dev Calculate the total amount received:
     * (Amount Received from Buyer + Amount Received from Supplier)
     * @return uint Total Received Amount
     * @param buyerAmountReceived uint input from user
     * @param supplierAmountReceived uint input from user
     */
    function totalAmountReceivedCalculation(
        uint buyerAmountReceived,
        uint supplierAmountReceived
    ) external pure returns (uint) {
        return buyerAmountReceived + supplierAmountReceived;
    }
}
