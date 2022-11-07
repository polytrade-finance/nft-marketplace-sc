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
     * @param factoringFee is a uint24 will have 2 decimals
     * @param discountFee is a uint24 will have 2 decimals
     * @param lateFee is a uint24 will have 2 decimals
     * @param bankChargesFee is a uint24 will have 2 decimals
     * @param additionalFee is a uint24 will have 2 decimals
     * @param gracePeriod is a uint16 will have 2 decimals
     * @param advanceRatio is a uint16 will have 2 decimals
     * @param dueDate is a uint48 will have 2 decimals
     * @param invoiceDate is a uint48 will have 2 decimals
     * @param fundsAdvancedDate is a uint48 will have 2 decimals
     * @param invoiceAmount is a uint will have 2 decimals
     * @param invoiceLimit is a uint will have 2 decimals
     */
    struct InitialMetadata {
        uint24 factoringFee;
        uint24 discountFee;
        uint24 lateFee;
        uint24 bankChargesFee;
        uint24 additionalFee;
        uint16 gracePeriod;
        uint16 advanceRatio;
        uint48 dueDate;
        uint48 invoiceDate;
        uint48 fundsAdvancedDate;
        uint invoiceAmount;
        uint invoiceLimit;
    }

    /**
     * @title A new struct to define the metadata structure
     * @dev Defining a new type of struct called Metadata to store the asset metadata
     * @param paymentReceiptDate is a uint48 will have 2 decimals
     * @param paymentReserveDate is a uint48 will have 2 decimals
     * @param buyerAmountReceived is a uint will have 2 decimals
     * @param supplierAmountReceived is a uint will have 2 decimals
     * @param supplierAmountReserved is a uint will have 2 decimals
     * @param reservePaymentTransactionId is a uint will have 2 decimals
     * @param initialMetadata is a InitialMetadata will hold all mandatory needed metadate to mint the AssetNFT
     */
    struct Metadata {
        uint48 paymentReceiptDate;
        uint48 paymentReserveDate;
        uint buyerAmountReceived;
        uint supplierAmountReceived;
        uint supplierAmountReserved;
        uint reservePaymentTransactionId;
        InitialMetadata initialMetadata;
    }

    /**
     * @dev Emitted when `assetNumber` token with `metadata` is minted from the `creator` to the `receiver`
     * @param creator The address of the contract that minted this token
     * @param receiver The address of the receiver of this token
     * @param assetNumber The uint id of the newly minted token
     */
    event AssetCreate(
        address indexed creator,
        address indexed receiver,
        uint assetNumber
    );

    /**
     * @dev Emitted when `newFormulas` contract address is set to the AssetNFT instead of `oldFormulas`
     * @param oldFormulas The address of the old formulad smart contract
     * @param newFormulas The address of the new formulad smart contract
     */
    event FormulasSet(address oldFormulas, address newFormulas);

    /**
     * @dev Emitted when `paymentReceiptDate` & `buyerAmountReceived` & `supplierAmountReceived`
     * is set to the AssetNFT number `assetNumber`
     * @param assetNumber The uint of the asset NFT
     * @param buyerAmountReceived The uint represent the amount received from the buyer
     * @param supplierAmountReceived The uint represent the amount received from the supplier
     * @param paymentReceiptDate The uint48 represent the date
     */
    event AdditionalMetadataSet(
        uint assetNumber,
        uint buyerAmountReceived,
        uint supplierAmountReceived,
        uint48 paymentReceiptDate
    );

    /**
     * @dev Emitted when `supplierAmountReserved` & `reservePaymentTransactionId` & `paymentReserveDate`
     * is set to the AssetNFT number `assetNumber`
     * @param assetNumber The uint of the asset NFT
     * @param supplierAmountReserved The uint value of the reserved amount sent to supplier
     * @param reservePaymentTransactionId The uint value of the payment transaction ID
     * @param paymentReserveDate The uint48 value of the reserve payment date
     */
    event AssetSettledMetadataSet(
        uint assetNumber,
        uint supplierAmountReserved,
        uint reservePaymentTransactionId,
        uint48 paymentReserveDate
    );

    /**
     * @dev Emitted when `newURI` is set to the AssetNFT instead of `oldURI` by `assetNumber`
     * @param oldAssetBaseURI The old URI for the asset NFT
     * @param newAssetBaseURI The new URI for the asset NFT
     */
    event AssetBaseURISet(string oldAssetBaseURI, string newAssetBaseURI);

    /**
     * @dev Implementation of a mint function that uses the predefined _mint() function from ERC721 standard
     * @param receiver The receiver address of the newly minted NFT
     * @param assetNumber The unique uint Asset Number of the NFT
     * @param initialMetadata Struct of asset initial metadata
     */
    function createAsset(
        address receiver,
        uint assetNumber,
        InitialMetadata memory initialMetadata
    ) external;

    /**
     * @dev Implementation of a setter for the formulas contract
     * @param formulasAddress The address of the formulas calculation contract
     */
    function setFormulas(address formulasAddress) external;

    /**
     * @dev Implementation of a setter for the asset base URI
     * @param newBaseURI The string of the asset base URI
     */
    function setBaseURI(string memory newBaseURI) external;

    /**
     * @dev Implementation of a setter for
     * payment receipt date & amount received from buyer & amout received from supplier
     * @param assetNumber The unique uint Asset Number of the NFT
     * @param buyerAmountReceived The uint value of the amount received from buyer
     * @param supplierAmountReceived The uint value of the amount received from supplier
     * @param paymentReceiptDate The uint48 value of the payment receipt date
     */
    function setAdditionalMetadata(
        uint assetNumber,
        uint buyerAmountReceived,
        uint supplierAmountReceived,
        uint48 paymentReceiptDate
    ) external;

    /**
     * @dev Implementation of a setter for
     * reserved payment date & amount sent to supplier & the payment transaction ID
     * @param assetNumber The unique uint Asset Number of the NFT
     * @param supplierAmountReserved The uint value of the reserved amount sent to supplier
     * @param reservePaymentTransactionId The uint value of the payment transaction ID
     * @param paymentReserveDate The uint48 value of the reserve payment date
     */
    function setAssetSettledMetadata(
        uint assetNumber,
        uint supplierAmountReserved,
        uint reservePaymentTransactionId,
        uint48 paymentReserveDate
    ) external;

    /**
     * @dev Implementation of a getter for asset metadata
     * @return Metadata The metadata related to a specific asset
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function getAsset(uint assetNumber) external view returns (Metadata memory);

    /**
     * @dev Calculate the number of late days
     * @return uint16 Number of Late Days
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function calculateLateDays(uint assetNumber) external view returns (uint16);

    /**
     * @dev Calculate the discount amount
     * @return uint Amount of the Discount
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function calculateDiscountAmount(uint assetNumber)
        external
        view
        returns (uint);

    /**
     * @dev Calculate the late amount
     * @return uint Late Amount
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function calculateLateAmount(uint assetNumber) external view returns (uint);

    /**
     * @dev Calculate the advanced amount
     * @return uint Advanced Amount
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function calculateAdvancedAmount(uint assetNumber)
        external
        view
        returns (uint);

    /**
     * @dev Calculate the factoring amount
     * @return uint Factoring Amount
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function calculateFactoringAmount(uint assetNumber)
        external
        view
        returns (uint);

    /**
     * @dev Calculate the invoice tenure
     * @return uint24 Invoice Tenure
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function calculateInvoiceTenure(uint assetNumber)
        external
        view
        returns (uint24);

    /**
     * @dev Calculate the reserve amount
     * @return uint Reserve Amount
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function calculateReserveAmount(uint assetNumber)
        external
        view
        returns (uint);

    /**
     * @dev Calculate the finance tenure
     * @return uint24 Finance Tenure
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function calculateFinanceTenure(uint assetNumber)
        external
        view
        returns (uint24);

    /**
     * @dev Calculate the total fees amount
     * @return uint Total Amount
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function calculateTotalFees(uint assetNumber) external view returns (uint);

    /**
     * @dev Calculate the net amount payable to the client
     * @return uint Net Amount Payable to the Client
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function calculateNetAmountPayableToClient(uint assetNumber)
        external
        view
        returns (int);

    /**
     * @dev Calculate the total amount received
     * @return uint Total Received Amount
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function calculateTotalAmountReceived(uint assetNumber)
        external
        view
        returns (uint);
}
