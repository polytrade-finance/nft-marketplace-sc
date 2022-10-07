// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/**
 * @title An interface for the asset NFT
 * @author Polytrade.Finance
 * @dev This interface will hold the main functions, events and data types for the new asset NFT contract
 */
interface IAssetNFT is IERC721 {
    /**
     * @title A new struct to define the metadata structure
     * @dev Defining a new type of struct called Metadata to store the asset metadata
     * @param factoringFee is a uint16 will have 2 decimals
     * @param discountingFee is a uint16 will have 2 decimals
     * @param financedTenure is a uint16 will be without decimals
     * @param advancedPercentage is a uint16 will have 2 decimals
     * @param reservePercentage is a uint16 will have 2 decimals
     * @param gracePeriod is a uint16 will have 2 decimals
     * @param lateFeePercentage is a uint16 will have 2 decimals
     * @param invoiceAmount is a uint will have 6 decimals
     * @param availableAmount is a uint will have 6 decimals
     * @param bankCharges is a uint will have 6 decimals
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

    /**
     * @dev Mint a new AssetNFT token
     */
    function mint(
        address _receiver,
        uint _tokenId,
        Metadata memory _metadata
    ) external;
}
