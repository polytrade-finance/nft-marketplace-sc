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
     * @dev Emitted when `_assetNumber` token with `_metadata` is minted from the `_creator` to the `_receiver`
     * @param _creator The address of the contract that minted this token
     * @param _receiver The address of the receiver of this token
     * @param _assetNumber The uint id of the newly minted token
     */
    event AssetCreate(
        address indexed _creator,
        address indexed _receiver,
        uint _assetNumber
    );

    /**
     * @dev Emitted when `_newFormulas` contract address is set to the AssetNFT instead of `_oldFormulas`
     * @param _oldFormulas The address of the old formulad smart contract
     * @param _newFormulas The address of the new formulad smart contract
     */
    event FormulasSet(address _oldFormulas, address _newFormulas);

    /**
     * @dev Emitted when `_paymentReceiptDate` & `_buyerAmountReceived` & `_supplierAmountReceived`
     * is set to the AssetNFT number `_assetNumber`
     * @param _assetNumber The uint of the asset NFT
     * @param _buyerAmountReceived The uint represent the amount received from the buyer
     * @param _supplierAmountReceived The uint represent the amount received from the supplier
     * @param _paymentReceiptDate The uint48 represent the date
     */
    event AdditionalMetadataSet(
        uint _assetNumber,
        uint _buyerAmountReceived,
        uint _supplierAmountReceived,
        uint48 _paymentReceiptDate
    );

    /**
     * @dev Emitted when `_supplierAmountReserved` & `_reservePaymentTransactionId` & `_paymentReserveDate`
     * is set to the AssetNFT number `_assetNumber`
     * @param _assetNumber The uint of the asset NFT
     * @param _supplierAmountReserved The uint value of the reserved amount sent to supplier
     * @param _reservePaymentTransactionId The uint value of the payment transaction ID
     * @param _paymentReserveDate The uint48 value of the reserve payment date
     */
    event AssetSettledMetadataSet(
        uint _assetNumber,
        uint _supplierAmountReserved,
        uint _reservePaymentTransactionId,
        uint48 _paymentReserveDate
    );

    /**
     * @dev Emitted when `_newURI` is set to the AssetNFT instead of `_oldURI` by `_assetNumber`
     * @param _oldAssetBaseURI The old URI for the asset NFT
     * @param _newAssetBaseURI The new URI for the asset NFT
     */
    event AssetBaseURISet(string _oldAssetBaseURI, string _newAssetBaseURI);

    /**
     * @dev Implementation of a mint function that uses the predefined _mint() function from ERC721 standard
     * @param _receiver The receiver address of the newly minted NFT
     * @param _assetNumber The unique uint Asset Number of the NFT
     * @param _initialMetadata Struct of asset initial metadata
     */
    function createAsset(
        address _receiver,
        uint _assetNumber,
        InitialMetadata memory _initialMetadata
    ) external;

    /**
     * @dev Implementation of a setter for the formulas contract
     * @param _formulasAddress The address of the formulas calculation contract
     */
    function setFormulas(address _formulasAddress) external;

    /**
     * @dev Implementation of a setter for the asset base URI
     * @param _newAssetBaseURI The string of the asset base URI
     */
    function setAssetBaseURI(string memory _newAssetBaseURI) external;

    /**
     * @dev Implementation of a setter for
     * payment receipt date & amount received from buyer & amout received from supplier
     * @param _assetNumber The unique uint Asset Number of the NFT
     * @param _buyerAmountReceived The uint value of the amount received from buyer
     * @param _supplierAmountReceived The uint value of the amount received from supplier
     * @param _paymentReceiptDate The uint48 value of the payment receipt date
     */
    function setAdditionalMetadata(
        uint _assetNumber,
        uint _buyerAmountReceived,
        uint _supplierAmountReceived,
        uint48 _paymentReceiptDate
    ) external;

    /**
     * @dev Implementation of a setter for
     * reserved payment date & amount sent to supplier & the payment transaction ID
     * @param _assetNumber The unique uint Asset Number of the NFT
     * @param _supplierAmountReserved The uint value of the reserved amount sent to supplier
     * @param _reservePaymentTransactionId The uint value of the payment transaction ID
     * @param _paymentReserveDate The uint48 value of the reserve payment date
     */
    function setAssetSettledMetadata(
        uint _assetNumber,
        uint _supplierAmountReserved,
        uint _reservePaymentTransactionId,
        uint48 _paymentReserveDate
    ) external;

    /**
     * @dev Implementation of a getter for asset metadata
     * @return Metadata The metadata related to a specific asset
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function getAsset(uint _assetNumber)
        external
        view
        returns (Metadata memory);

    /**
     * @dev Implementation of a getter for asset NFT URI
     * @return string The URI for the asset NFT
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function assetURI(uint _assetNumber) external view returns (string memory);

    /**
     * @dev Calculate the number of late days
     * @return uint16 Number of Late Days
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function calculateLateDays(uint _assetNumber)
        external
        view
        returns (uint16);

    /**
     * @dev Calculate the discount amount
     * @return uint Amount of the Discount
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function calculateDiscountAmount(uint _assetNumber)
        external
        view
        returns (uint);

    /**
     * @dev Calculate the late amount
     * @return uint Late Amount
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function calculateLateAmount(uint _assetNumber)
        external
        view
        returns (uint);

    /**
     * @dev Calculate the advanced amount
     * @return uint Advanced Amount
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function calculateAdvancedAmount(uint _assetNumber)
        external
        view
        returns (uint);

    /**
     * @dev Calculate the factoring amount
     * @return uint Factoring Amount
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function calculateFactoringAmount(uint _assetNumber)
        external
        view
        returns (uint);

    /**
     * @dev Calculate the invoice tenure
     * @return uint24 Invoice Tenure
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function calculateInvoiceTenure(uint _assetNumber)
        external
        view
        returns (uint24);

    /**
     * @dev Calculate the reserve amount
     * @return uint Reserve Amount
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function calculateReserveAmount(uint _assetNumber)
        external
        view
        returns (uint);

    /**
     * @dev Calculate the finance tenure
     * @return uint24 Finance Tenure
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function calculateFinanceTenure(uint _assetNumber)
        external
        view
        returns (uint24);

    /**
     * @dev Calculate the total fees amount
     * @return uint Total Amount
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function calculateTotalFees(uint _assetNumber) external view returns (uint);

    /**
     * @dev Calculate the net amount payable to the client
     * @return uint Net Amount Payable to the Client
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function calculateNetAmountPayableToClient(uint _assetNumber)
        external
        view
        returns (int);

    /**
     * @dev Calculate the total amount received
     * @return uint Total Received Amount
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function calculateTotalAmountReceived(uint _assetNumber)
        external
        view
        returns (uint);
}
