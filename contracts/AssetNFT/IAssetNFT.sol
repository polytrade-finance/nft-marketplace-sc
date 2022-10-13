// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

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
     * @param discountFee is a uint16 will have 2 decimals
     * @param lateFee is a uint16 will have 2 decimals
     * @param bankChargesAdditionalFee is a uint16 will have 2 decimals
     * @param gracePeriod is a uint16 will have 2 decimals
     * @param advanceRatio is a uint16 will have 2 decimals
     * @param dueDate is a uint24 will have 2 decimals
     * @param invoiceDate is a uint24 will have 2 decimals
     * @param fundsAdvancedDate is a uint24 will have 2 decimals
     * @param invoiceAmount is a uint will have 6 decimals
     * @param invoiceLimit is a uint will have 6 decimals
     */
    struct InitialMetadata {
        uint16 factoringFee;
        uint16 discountFee;
        uint16 lateFee;
        uint16 bankChargesAdditionalFee;
        uint16 gracePeriod;
        uint16 advanceRatio;
        uint24 dueDate;
        uint24 invoiceDate;
        uint24 fundsAdvancedDate;
        uint invoiceAmount;
        uint invoiceLimit;
    }

    /**
     * @title A new struct to define the metadata structure
     * @dev Defining a new type of struct called Metadata to store the asset metadata
     * @param initialMetadata is a InitialMetadata will hold all mandatory needed metadate to mint the AssetNFT
     * @param paymentReceiptDate is a uint24 will have 2 decimals
     * @param buyerAmountReceived is a uint will have 6 decimals
     * @param supplierAmountReceived is a uint will have 6 decimals
     */
    struct Metadata {
        InitialMetadata initialMetadata;
        uint24 paymentReceiptDate;
        uint buyerAmountReceived;
        uint supplierAmountReceived;
    }

    /**
     * @dev Emitted when `_tokenId` token with `_metadata` is minted from the `_creator` to the `_receiver`
     * @param _creator The address of the contract that minted this token
     * @param _receiver The address of the receiver of this token
     * @param _tokenId The uint id of the newly minted token
     */
    event AssetCreate(
        address indexed _creator,
        address indexed _receiver,
        uint _tokenId
    );

    /**
     * @dev Implementation of a mint function that uses the predefined _mint() function from ERC721 standard
     * @param _receiver The receiver address of the newly minted NFT
     * @param _tokenId The unique uint token ID of the newly minted NFT
     * @param _initialMetadata Struct of asset initial metadata
     */
    function createAsset(
        address _receiver,
        uint _tokenId,
        InitialMetadata memory _initialMetadata
    ) external;
}
