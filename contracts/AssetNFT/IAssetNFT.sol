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
     * @param gracePeriod is a uint16 will have 2 decimals
     * @param advanceRatio is a uint16 will have 2 decimals
     * @param dueDate is a uint48 will have 2 decimals
     * @param invoiceDate is a uint48 will have 2 decimals
     * @param fundsAdvancedDate is a uint48 will have 2 decimals
     * @param invoiceAmount is a uint will have 6 decimals
     * @param invoiceLimit is a uint will have 6 decimals
     */
    struct InitialMetadata {
        uint24 factoringFee;
        uint24 discountFee;
        uint24 lateFee;
        uint24 bankChargesFee;
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
     * @param initialMetadata is a InitialMetadata will hold all mandatory needed metadate to mint the AssetNFT
     * @param paymentReceiptDate is a uint48 will have 2 decimals
     * @param buyerAmountReceived is a uint will have 6 decimals
     * @param supplierAmountReceived is a uint will have 6 decimals
     */
    struct Metadata {
        InitialMetadata initialMetadata;
        uint48 paymentReceiptDate;
        uint buyerAmountReceived;
        uint supplierAmountReceived;
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
     * @dev Implementation of a mint function that uses the predefined _mint() function from ERC721 standard
     * @param _receiver The receiver address of the newly minted NFT
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     * @param _initialMetadata Struct of asset initial metadata
     */
    function createAsset(
        address _receiver,
        uint _assetNumber,
        InitialMetadata memory _initialMetadata
    ) external;

    /**
     * @dev Implementation of a setter for formulas calculation instance
     * @param _formulasAddress The address of the formulas calculation contract
     */
    function setFormulasContract(address _formulasAddress) external;

    /**
     * @dev Implementation of a setter for payment receipt date
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     * @param _paymentReceiptDate The uint48 value of the payment receipt date
     */
    function setPaymentReceiptDate(
        uint _assetNumber,
        uint48 _paymentReceiptDate
    ) external;

    /**
     * @dev Implementation of a setter for amount received from buyer
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     * @param _buyerAmountReceived The uint value of the amount received from buyer
     */
    function setBuyerAmountReceived(
        uint _assetNumber,
        uint _buyerAmountReceived
    ) external;

    /**
     * @dev Implementation of a setter for amount received from supplier
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     * @param _supplierAmountReceived The uint value of the amount received from supplier
     */
    function setSupplierAmountReceived(
        uint _assetNumber,
        uint _supplierAmountReceived
    ) external;

    /**
     * @dev Implementation of a getter for asset metadata
     * @return Metadata The metadata related to a specific asset
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     */
    function getAsset(uint _assetNumber)
        external
        view
        returns (Metadata memory);

    /**
     * @dev Calculate the number of late days
     * @return uint16 Number of Late Days
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     */
    function calculateLateDays(uint _assetNumber)
        external
        view
        returns (uint16);

    /**
     * @dev Calculate the discount amount
     * @return uint Amount of the Discount
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     */
    function calculateDiscountAmount(uint _assetNumber)
        external
        view
        returns (uint);

    /**
     * @dev Calculate the late amount
     * @return uint Late Amount
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     */
    function calculateLateAmount(uint _assetNumber)
        external
        view
        returns (uint);

    /**
     * @dev Calculate the advanced amount
     * @return uint Advanced Amount
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     */
    function calculateAdvancedAmount(uint _assetNumber)
        external
        view
        returns (uint);

    /**
     * @dev Calculate the factoring amount
     * @return uint Factoring Amount
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     */
    function calculateFactoringAmount(uint _assetNumber)
        external
        view
        returns (uint);

    /**
     * @dev Calculate the invoice tenure
     * @return uint24 Invoice Tenure
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     */
    function calculateInvoiceTenure(uint _assetNumber)
        external
        view
        returns (uint24);

    /**
     * @dev Calculate the reserve amount
     * @return uint Reserve Amount
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     */
    function calculateReserveAmount(uint _assetNumber)
        external
        view
        returns (uint);

    /**
     * @dev Calculate the finance tenure
     * @return uint24 Finance Tenure
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     */
    function calculateFinanceTenure(uint _assetNumber)
        external
        view
        returns (uint24);

    /**
     * @dev Calculate the total fees amount
     * @return uint Total Amount
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     */
    function calculateTotalFees(uint _assetNumber) external view returns (uint);

    /**
     * @dev Calculate the net amount payable to the client
     * @return uint Net Amount Payable to the Client
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     */
    function calculateNetAmountPayableToClient(uint _assetNumber)
        external
        view
        returns (int);

    /**
     * @dev Calculate the total amount received
     * @return uint Total Received Amount
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     */
    function calculateTotalAmountReceived(uint _assetNumber)
        external
        view
        returns (uint);
}
