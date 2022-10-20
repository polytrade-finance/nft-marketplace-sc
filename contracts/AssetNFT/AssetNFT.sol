// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IAssetNFT.sol";
import "../Formulas/IFormulas.sol";

/**
 * @title A simple ERC721 token
 * @author Polytrade.Finance
 * @dev Implementation of Non-Fungible Token Standard, including the Metadata extension
 * @custom:access Accessible only by the owner
 * @custom:indexing Enumerable token can be indexed
 */
contract AssetNFT is ERC721Enumerable, IAssetNFT, Ownable {
    IFormulas private _formulas;

    /**
     * @dev Mapping will be indexing the metadata for each AssetNFT by its Asset Number
     */
    mapping(uint => Metadata) public metadata;

    /**
     * @dev Constructor will call the parent one to create an ERC721 with specific name and symbol
     * @param _name String defining the name of the new ERC721 token
     * @param _symbol String defining the symbol of the new ERC721 token
     */
    constructor(string memory _name, string memory _symbol)
        ERC721(_name, _symbol)
    {
        _name;
    }

    /**
     * @dev Implementation of a mint function that uses the predefined _mint() function from ERC721 standard
     * @param _receiver The receiver address of the newly minted NFT
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     * @param _initialMetadata Struct of type InitialMetadata contains add initial metadata need to be verified
     */
    function createAsset(
        address _receiver,
        uint _assetNumber,
        InitialMetadata memory _initialMetadata
    ) external onlyOwner {
        require(
            ((_initialMetadata.dueDate - _initialMetadata.fundsAdvancedDate) /
                1 days) >= 20,
            "Asset cannot be due within less than 20 days"
        );
        metadata[_assetNumber].initialMetadata = _initialMetadata;

        emit AssetCreate(msg.sender, _receiver, _assetNumber);

        _mint(_receiver, _assetNumber);
    }

    /**
     * @dev Implementation of a getter for asset metadata
     * @return Metadata The metadata related to a specific asset
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     */
    function getAsset(uint _assetNumber)
        external
        view
        returns (Metadata memory)
    {
        return metadata[_assetNumber];
    }

    /**
     * @dev Calculate the number of late days
     * @return uint16 Number of Late Days
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     */
    function calculateLateDate(uint _assetNumber)
        external
        view
        returns (uint16)
    {
        Metadata memory assetMetadata = this.getAsset(_assetNumber);

        return
            _formulas.lateDays(
                assetMetadata.paymentReceiptDate,
                assetMetadata.initialMetadata.dueDate,
                assetMetadata.initialMetadata.gracePeriod
            );
    }

    /**
     * @dev Calculate the discount amount
     * @return uint Amount of the Discount
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     */
    function calculateDiscountAmount(uint _assetNumber)
        external
        view
        returns (uint)
    {
        Metadata memory assetMetadata = this.getAsset(_assetNumber);

        uint16 financeTenure = _formulas.financeTenure(
            assetMetadata.paymentReceiptDate,
            assetMetadata.initialMetadata.fundsAdvancedDate
        );

        uint16 lateDays = _formulas.lateDays(
            assetMetadata.paymentReceiptDate,
            assetMetadata.initialMetadata.dueDate,
            assetMetadata.initialMetadata.gracePeriod
        );

        uint advancedAmount = _formulas.advancedAmount(
            assetMetadata.initialMetadata.invoiceLimit,
            assetMetadata.initialMetadata.advanceRatio
        );

        return
            _formulas.discountAmount(
                assetMetadata.initialMetadata.discountFee,
                financeTenure,
                lateDays,
                advancedAmount
            );
    }

    /**
     * @dev Calculate the late amount
     * @return uint Late Amount
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     */
    function calculateLateAmount(uint _assetNumber)
        external
        view
        returns (uint)
    {
        Metadata memory assetMetadata = this.getAsset(_assetNumber);

        uint16 lateDays = _formulas.lateDays(
            assetMetadata.paymentReceiptDate,
            assetMetadata.initialMetadata.dueDate,
            assetMetadata.initialMetadata.gracePeriod
        );

        uint advancedAmount = _formulas.advancedAmount(
            assetMetadata.initialMetadata.invoiceLimit,
            assetMetadata.initialMetadata.advanceRatio
        );

        return
            _formulas.lateAmount(
                assetMetadata.initialMetadata.lateFee,
                lateDays,
                advancedAmount
            );
    }

    /**
     * @dev Calculate the advanced amount
     * @return uint Advanced Amount
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     */
    function calculateAdvancedAmount(uint _assetNumber)
        external
        view
        returns (uint)
    {
        Metadata memory assetMetadata = this.getAsset(_assetNumber);

        return
            _formulas.advancedAmount(
                assetMetadata.initialMetadata.invoiceLimit,
                assetMetadata.initialMetadata.advanceRatio
            );
    }

    /**
     * @dev Calculate the factoring amount
     * @return uint Factoring Amount
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     */
    function calculateFactoringAmount(uint _assetNumber)
        external
        view
        returns (uint)
    {
        Metadata memory assetMetadata = this.getAsset(_assetNumber);

        return
            _formulas.factoringAmount(
                assetMetadata.initialMetadata.invoiceAmount,
                assetMetadata.initialMetadata.factoringFee
            );
    }

    /**
     * @dev Calculate the invoice tenure
     * @return uint24 Invoice Tenure
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     */
    function calculateInvoiceTenure(uint _assetNumber)
        external
        view
        returns (uint24)
    {
        Metadata memory assetMetadata = this.getAsset(_assetNumber);

        return
            _formulas.invoiceTenure(
                assetMetadata.initialMetadata.dueDate,
                assetMetadata.initialMetadata.invoiceDate
            );
    }

    /**
     * @dev Calculate the reserve amount
     * @return uint Reserve Amount
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     */
    function calculateReserveAmount(uint _assetNumber)
        external
        view
        returns (uint)
    {
        Metadata memory assetMetadata = this.getAsset(_assetNumber);

        uint advancedAmount = _formulas.advancedAmount(
            assetMetadata.initialMetadata.invoiceLimit,
            assetMetadata.initialMetadata.advanceRatio
        );

        return
            _formulas.reserveAmount(
                assetMetadata.initialMetadata.invoiceAmount,
                advancedAmount
            );
    }

    /**
     * @dev Calculate the finance tenure
     * @return uint24 Finance Tenure
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     */
    function calculateFinanceTenure(uint _assetNumber)
        external
        view
        returns (uint24)
    {
        Metadata memory assetMetadata = this.getAsset(_assetNumber);

        return
            _formulas.financeTenure(
                assetMetadata.paymentReceiptDate,
                assetMetadata.initialMetadata.fundsAdvancedDate
            );
    }

    /**
     * @dev Calculate the total fees amount
     * @return uint Total Amount
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     */
    function calculateTotalFees(uint _assetNumber)
        external
        view
        returns (uint)
    {
        Metadata memory assetMetadata = this.getAsset(_assetNumber);

        return
            _formulas.totalFees(
                assetMetadata.initialMetadata.factoringFee,
                assetMetadata.initialMetadata.discountFee,
                assetMetadata.initialMetadata.lateFee,
                assetMetadata.initialMetadata.bankChargesFee
            );
    }

    /**
     * @dev Calculate the net amount payable to the client
     * @return uint Net Amount Payable to the Client
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     */
    function calculateNetAmountPayaleToClient(uint _assetNumber)
        external
        view
        returns (int)
    {
        Metadata memory assetMetadata = this.getAsset(_assetNumber);

        uint totalAmountReceived = _formulas.totalAmountReceived(
            assetMetadata.buyerAmountReceived,
            assetMetadata.supplierAmountReceived
        );

        uint advancedAmount = _formulas.advancedAmount(
            assetMetadata.initialMetadata.invoiceLimit,
            assetMetadata.initialMetadata.advanceRatio
        );

        uint totalFees = _formulas.totalFees(
            assetMetadata.initialMetadata.factoringFee,
            assetMetadata.initialMetadata.discountFee,
            assetMetadata.initialMetadata.lateFee,
            assetMetadata.initialMetadata.bankChargesFee
        );

        return
            _formulas.netAmountPayableToClient(
                totalAmountReceived,
                advancedAmount,
                totalFees
            );
    }

    /**
     * @dev Calculate the total amount received
     * @return uint Total Received Amount
     * @param _assetNumber The unique uint Asset Number of the newly minted NFT
     */
    function calculateTotalAmountReceived(uint _assetNumber)
        external
        view
        returns (uint)
    {
        Metadata memory assetMetadata = this.getAsset(_assetNumber);

        return
            _formulas.totalAmountReceived(
                assetMetadata.buyerAmountReceived,
                assetMetadata.supplierAmountReceived
            );
    }
}
