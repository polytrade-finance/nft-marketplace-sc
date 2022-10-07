// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

/**
 * @title An interface for the asset NFT
 * @author Polytrade.Finance
 * @dev This interface will hold the main functions, events and data types for the new asset NFT contract
 */
contract IAssetNFT {
    /**
     * @title A new struct to define the metadata structure
     * @dev Defining a new type of struct called Metadata to store the asset metadata
     */
    struct Metadata {
        uint16 factoringFee;
        uint16 discountingFee;
        uint16 financedTenure;
        uint16 advancedPercentage;
        uint16 reservePercentage;
        uint16 gracePeriod;
        uint16 lateFeePercentage;
        uint invoiceAmount;
        uint availableAmount;
        uint bankCharges;
    }
}
