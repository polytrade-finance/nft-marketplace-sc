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
     * @param reservePaidToSupplier is a uint will have 2 decimals
     * @param reservePaymentTransactionId is a uint will have 2 decimals
     * @param amountSentToLender is a uint will have 2 decimals
     * @param initialMetadata is a InitialMetadata will hold all mandatory needed metadata to mint the AssetNFT
     */
    struct Metadata {
        uint48 paymentReceiptDate;
        uint48 paymentReserveDate;
        uint buyerAmountReceived;
        uint supplierAmountReceived;
        uint reservePaidToSupplier;
        uint reservePaymentTransactionId;
        uint amountSentToLender;
        InitialMetadata initialMetadata;
    }

    /**
     * @dev Emitted when `assetNumber` token with `metadata` is minted from the `creator` to the `receiver`
     * @param creator Address of the contract that minted this token
     * @param receiver Address of the receiver of this token
     * @param assetNumber Uint id of the newly minted token
     */
    event AssetCreate(
        address indexed creator,
        address indexed receiver,
        uint assetNumber
    );

    /**
     * @dev Emitted when `newFormulas` contract address is set to the AssetNFT instead of `oldFormulas`
     * @param oldFormulas Address of the old formulas smart contract
     * @param newFormulas Address of the new formulas smart contract
     */
    event FormulasSet(address oldFormulas, address newFormulas);

    /**
     * @dev Emitted when `paymentReceiptDate` & `buyerAmountReceived` & `supplierAmountReceived`
     * is set to the AssetNFT number `assetNumber`
     * @param assetNumber Uint of the asset NFT
     * @param buyerAmountReceived Uint represent the amount received from the buyer
     * @param supplierAmountReceived Uint represent the amount received from the supplier
     * @param paymentReceiptDate Uint represent the date
     */
    event AdditionalMetadataSet(
        uint assetNumber,
        uint buyerAmountReceived,
        uint supplierAmountReceived,
        uint paymentReceiptDate
    );

    /**
     * @dev Emitted when `reservePaidToSupplier` & `reservePaymentTransactionId`
     * & `paymentReserveDate` & `amountSentToLender`
     * is set to the AssetNFT number `assetNumber`
     * @param assetNumber Uint of the asset NFT
     * @param reservePaidToSupplier Uint value of the reserved amount sent to supplier
     * @param reservePaymentTransactionId Uint value of the payment transaction ID
     * @param paymentReserveDate Uint value of the reserve payment date
     * @param amountSentToLender Uint value of the amount sent to the lender
     */
    event AssetSettledMetadataSet(
        uint assetNumber,
        uint reservePaidToSupplier,
        uint reservePaymentTransactionId,
        uint paymentReserveDate,
        uint amountSentToLender
    );

    /**
     * @dev Emitted when `newURI` is set to the AssetNFT instead of `oldURI` by `assetNumber`
     * @param oldAssetBaseURI Old URI for the asset NFT
     * @param newAssetBaseURI New URI for the asset NFT
     */
    event AssetBaseURISet(string oldAssetBaseURI, string newAssetBaseURI);

    /**
     * @dev Implementation of a mint function that uses the predefined _mint() function from ERC721 standard
     * @param receiver Receiver address of the newly minted NFT
     * @param assetNumber Unique uint Asset Number of the NFT
     * @param initialMetadata Struct of asset initial metadata
     */
    function createAsset(
        address receiver,
        uint assetNumber,
        InitialMetadata memory initialMetadata
    ) external;

    /**
     * @dev Implementation of a setter for the formulas contract
     * @param formulasAddress Address of the formulas calculation contract
     */
    function setFormulas(address formulasAddress) external;

    /**
     * @dev Implementation of a setter for the asset base URI
     * @param newBaseURI String of the asset base URI
     */
    function setBaseURI(string calldata newBaseURI) external;

    /**
     * @dev Implementation of a setter for
     * Payment receipt date & amount paid by buyer & amount paid by supplier
     * @param assetNumber Unique uint Asset Number of the NFT
     * @param buyerAmountReceived Uint value of the amount received from buyer
     * @param supplierAmountReceived Uint value of the amount received from supplier
     * @param paymentReceiptDate Uint value of the payment receipt date
     */
    function setAdditionalMetadata(
        uint assetNumber,
        uint buyerAmountReceived,
        uint supplierAmountReceived,
        uint paymentReceiptDate
    ) external;

    /**
     * @dev Implementation of a setter for
     * reserved payment date & amount sent to supplier & the payment transaction ID & amount sent to lender
     * @param assetNumber Unique uint Asset Number of the NFT
     * @param reservePaidToSupplier Uint value of the reserved amount sent to supplier
     * @param reservePaymentTransactionId Uint value of the payment transaction ID
     * @param paymentReserveDate Uint value of the reserve payment date
     * @param amountSentToLender Uint value of the amount sent to the lender
     */
    function setAssetSettledMetadata(
        uint assetNumber,
        uint reservePaidToSupplier,
        uint reservePaymentTransactionId,
        uint paymentReserveDate,
        uint amountSentToLender
    ) external;

    /**
     * @dev Implementation of a getter for asset metadata
     * @return Metadata Metadata related to a specific asset
     * @param assetNumber Unique uint Asset Number of the NFT
     */
    function getAsset(uint assetNumber) external view returns (Metadata memory);

    /**
     * @dev Calculate the number of late days
     * @return uint Number of Late Days
     * @param assetNumber Unique uint Asset Number of the NFT
     */
    function calculateLateDays(uint assetNumber) external view returns (uint);

    /**
     * @dev Calculate the discount amount
     * @return uint Amount of the Discount
     * @param assetNumber Unique uint Asset Number of the NFT
     */
    function calculateDiscountAmount(uint assetNumber)
        external
        view
        returns (uint);

    /**
     * @dev Calculate the late amount
     * @return uint Late Amount
     * @param assetNumber Unique uint Asset Number of the NFT
     */
    function calculateLateAmount(uint assetNumber) external view returns (uint);

    /**
     * @dev Calculate the advanced amount
     * @return uint Advanced Amount
     * @param assetNumber Unique uint Asset Number of the NFT
     */
    function calculateAdvancedAmount(uint assetNumber)
        external
        view
        returns (uint);

    /**
     * @dev Calculate the factoring amount
     * @return uint Factoring Amount
     * @param assetNumber Unique uint Asset Number of the NFT
     */
    function calculateFactoringAmount(uint assetNumber)
        external
        view
        returns (uint);

    /**
     * @dev Calculate the invoice tenure
     * @return uint Invoice Tenure
     * @param assetNumber Unique uint Asset Number of the NFT
     */
    function calculateInvoiceTenure(uint assetNumber)
        external
        view
        returns (uint);

    /**
     * @dev Calculate the reserve amount
     * @return uint Reserve Amount
     * @param assetNumber Unique uint Asset Number of the NFT
     */
    function calculateReserveAmount(uint assetNumber)
        external
        view
        returns (uint);

    /**
     * @dev Calculate the finance tenure
     * @return uint Finance Tenure
     * @param assetNumber Unique uint Asset Number of the NFT
     */
    function calculateFinanceTenure(uint assetNumber)
        external
        view
        returns (uint);

    /**
     * @dev Calculate the total fees amount
     * @return uint Total Amount
     * @param assetNumber Unique uint Asset Number of the NFT
     */
    function calculateTotalFees(uint assetNumber) external view returns (uint);

    /**
     * @dev Calculate the net amount payable to the client
     * @return uint Net Amount Payable to the Client
     * @param assetNumber Unique uint Asset Number of the NFT
     */
    function calculateNetAmountPayableToClient(uint assetNumber)
        external
        view
        returns (int);

    /**
     * @dev Calculate the total amount received
     * @return uint Total Received Amount
     * @param assetNumber Unique uint Asset Number of the NFT
     */
    function calculateTotalAmountReceived(uint assetNumber)
        external
        view
        returns (uint);
}
