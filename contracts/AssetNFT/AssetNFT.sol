// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
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
    string private _assetBaseURI = "https://ipfs.io/ipfs";

    /**
     * @dev Mapping will be indexing the metadata for each AssetNFT by its Asset Number
     */
    mapping(uint => Metadata) private _metadata;

    /**
     * @dev Constructor will call the parent one to create an ERC721 with specific name and symbol
     * @param name_ String defining the name of the new ERC721 token
     * @param symbol_ String defining the symbol of the new ERC721 token
     * @param baseURI_ The string of the asset base URI
     * @param formulasAddress_ The address of the formulas calculation contract
     */
    constructor(
        string memory name_,
        string memory symbol_,
        string memory baseURI_,
        address formulasAddress_
    ) ERC721(name_, symbol_) {
        _setBaseURI(baseURI_);
        _setFormulas(formulasAddress_);
    }

    /**
     * @dev Implementation of a mint function that uses the predefined _mint() function from ERC721 standard
     * @param receiver The receiver address of the newly minted NFT
     * @param assetNumber The unique uint Asset Number of the NFT
     * @param initialMetadata Struct of type InitialMetadata contains initial metadata need to be verified
     */
    function createAsset(
        address receiver,
        uint assetNumber,
        InitialMetadata calldata initialMetadata
    ) external onlyOwner {
        require(
            ((initialMetadata.dueDate - initialMetadata.fundsAdvancedDate) /
                1 days) >= 20,
            "Asset due less than 20 days"
        );
        _metadata[assetNumber].initialMetadata = initialMetadata;
        _mint(receiver, assetNumber);
        emit AssetCreate(msg.sender, receiver, assetNumber);
    }

    /**
     * @dev Implementation of a setter for the formulas contract
     * @param formulasAddress The address of the formulas calculation contract
     */
    function setFormulas(address formulasAddress) external onlyOwner {
        _setFormulas(formulasAddress);
    }

    /**
     * @dev Implementation of a setter for the asset base URI
     * @param newBaseURI The string of the asset base URI
     */
    function setBaseURI(string memory newBaseURI) external onlyOwner {
        _setBaseURI(newBaseURI);
    }

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
    ) external onlyOwner {
        _setAdditionalMetadata(
            assetNumber,
            buyerAmountReceived,
            supplierAmountReceived,
            paymentReceiptDate
        );
    }

    /**
     * @dev Implementation of a setter for
     * payment receipt date & amount received from buyer & amout received from supplier
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
    ) external onlyOwner {
        _setAssetSettledMetadata(
            assetNumber,
            supplierAmountReserved,
            reservePaymentTransactionId,
            paymentReserveDate
        );
    }

    /**
     * @dev Implementation of a getter for asset metadata
     * @return Metadata The metadata related to a specific asset
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function getAsset(uint assetNumber)
        external
        view
        returns (Metadata memory)
    {
        return _getAsset(assetNumber);
    }

    /**
     * @dev Implementation of a getter for the Formulas conract adress
     * @return string Formulas contract address used in the asset NFT
     */
    function getFormulas() external view returns (address) {
        return address(_formulas);
    }

    /**
     * @dev Implementation of a getter for the base URI
     * @return string Base URI used in asset NFT
     */
    function getBaseURI() external view returns (string memory) {
        return _assetBaseURI;
    }

    /**
     * @dev Calculate the number of late days
     * @return uint16 Number of Late Days
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function calculateLateDays(uint assetNumber)
        external
        view
        returns (uint16)
    {
        return _calculateLateDays(assetNumber);
    }

    /**
     * @dev Calculate the discount amount
     * @return uint Amount of the Discount
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function calculateDiscountAmount(uint assetNumber)
        external
        view
        returns (uint)
    {
        return _calculateDiscountAmount(assetNumber);
    }

    /**
     * @dev Calculate the late amount
     * @return uint Late Amount
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function calculateLateAmount(uint assetNumber)
        external
        view
        returns (uint)
    {
        Metadata memory assetMetadata = _getAsset(assetNumber);
        uint16 lateDays = _calculateLateDays(assetNumber);
        uint advancedAmount = _calculateAdvancedAmount(assetNumber);
        return
            _formulas.lateAmountCalculation(
                assetMetadata.initialMetadata.lateFee,
                lateDays,
                advancedAmount
            );
    }

    /**
     * @dev Calculate the advanced amount
     * @return uint Advanced Amount
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function calculateAdvancedAmount(uint assetNumber)
        external
        view
        returns (uint)
    {
        return _calculateAdvancedAmount(assetNumber);
    }

    /**
     * @dev Calculate the factoring amount
     * @return uint Factoring Amount
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function calculateFactoringAmount(uint assetNumber)
        external
        view
        returns (uint)
    {
        return _calculateFactoringAmount(assetNumber);
    }

    /**
     * @dev Calculate the invoice tenure
     * @return uint24 Invoice Tenure
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function calculateInvoiceTenure(uint assetNumber)
        external
        view
        returns (uint24)
    {
        Metadata memory assetMetadata = _getAsset(assetNumber);
        return
            _formulas.invoiceTenureCalculation(
                assetMetadata.initialMetadata.dueDate,
                assetMetadata.initialMetadata.invoiceDate
            );
    }

    /**
     * @dev Calculate the reserve amount
     * @return uint Reserve Amount
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function calculateReserveAmount(uint assetNumber)
        external
        view
        returns (uint)
    {
        Metadata memory assetMetadata = _getAsset(assetNumber);
        uint advancedAmount = _calculateAdvancedAmount(assetNumber);
        return
            _formulas.reserveAmountCalculation(
                assetMetadata.initialMetadata.invoiceAmount,
                advancedAmount
            );
    }

    /**
     * @dev Calculate the finance tenure
     * @return uint24 Finance Tenure
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function calculateFinanceTenure(uint assetNumber)
        external
        view
        returns (uint24)
    {
        return _calculateTenure(assetNumber);
    }

    /**
     * @dev Calculate the total fees amount
     * @return uint Total Amount
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function calculateTotalFees(uint assetNumber) external view returns (uint) {
        return _calculateTotalFees(assetNumber);
    }

    /**
     * @dev Calculate the net amount payable to the client
     * @return uint Net Amount Payable to the Client
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function calculateNetAmountPayableToClient(uint assetNumber)
        external
        view
        returns (int)
    {
        uint advancedAmount = _calculateAdvancedAmount(assetNumber);
        uint totalAmountReceived = _calculateTotalAmountReceived(assetNumber);
        uint totalFees = _calculateTotalFees(assetNumber);
        return
            _formulas.netAmountPayableToClientCalculation(
                totalAmountReceived,
                advancedAmount,
                totalFees
            );
    }

    /**
     * @dev Calculate the total amount received
     * @return uint Total Received Amount
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function calculateTotalAmountReceived(uint assetNumber)
        external
        view
        returns (uint)
    {
        return _calculateTotalAmountReceived(assetNumber);
    }

    /**
     * @dev Implementation of a getter for asset NFT URI
     * @return string The URI for the asset NFT
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function tokenURI(uint assetNumber)
        public
        view
        virtual
        override
        returns (string memory)
    {
        string memory stringAssetNumber = Strings.toString(assetNumber);
        return string.concat(_assetBaseURI, stringAssetNumber);
    }

    /**
     * @dev Implementation of a setter for
     * payment receipt date & amount received from buyer & amout received from supplier
     * @param assetNumber The unique uint Asset Number of the NFT
     * @param buyerAmountReceived The uint value of the amount received from buyer
     * @param supplierAmountReceived The uint value of the amount received from supplier
     * @param paymentReceiptDate The uint48 value of the payment receipt date
     */
    function _setAdditionalMetadata(
        uint assetNumber,
        uint buyerAmountReceived,
        uint supplierAmountReceived,
        uint48 paymentReceiptDate
    ) private {
        require(
            _metadata[assetNumber].supplierAmountReserved == 0 &&
                _metadata[assetNumber].reservePaymentTransactionId == 0 &&
                _metadata[assetNumber].paymentReserveDate == 0,
            "Asset is already settled"
        );
        _metadata[assetNumber].paymentReceiptDate = paymentReceiptDate;
        _metadata[assetNumber].buyerAmountReceived = buyerAmountReceived;
        _metadata[assetNumber].supplierAmountReceived = supplierAmountReceived;
        emit AdditionalMetadataSet(
            assetNumber,
            buyerAmountReceived,
            supplierAmountReceived,
            paymentReceiptDate
        );
    }

    /**
     * @dev Implementation of a setter for the formulas contract
     * @param newFormulasAddress The address of the formulas calculation contract
     */
    function _setFormulas(address newFormulasAddress) private {
        address oldFormulasAddress = address(_formulas);
        _formulas = IFormulas(newFormulasAddress);
        emit FormulasSet(oldFormulasAddress, newFormulasAddress);
    }

    /**
     * @dev Implementation of a setter for the asset base URI
     * @param newBaseURI The string of the asset base URI
     */
    function _setBaseURI(string memory newBaseURI) private {
        string memory oldBaseURI = _assetBaseURI;
        _assetBaseURI = newBaseURI;
        emit AssetBaseURISet(oldBaseURI, newBaseURI);
    }

    /**
     * @dev Implementation of a setter for
     * payment receipt date & amount received from buyer & amout received from supplier
     * @param assetNumber The unique uint Asset Number of the NFT
     * @param supplierAmountReserved The uint value of the reserved amount sent to supplier
     * @param reservePaymentTransactionId The uint value of the payment transaction ID
     * @param paymentReserveDate The uint48 value of the reserve payment date
     */
    function _setAssetSettledMetadata(
        uint assetNumber,
        uint supplierAmountReserved,
        uint reservePaymentTransactionId,
        uint48 paymentReserveDate
    ) private {
        require(
            _metadata[assetNumber].supplierAmountReserved == 0 &&
                _metadata[assetNumber].reservePaymentTransactionId == 0 &&
                _metadata[assetNumber].paymentReserveDate == 0,
            "Asset is already settled"
        );
        _metadata[assetNumber].paymentReserveDate = paymentReserveDate;
        _metadata[assetNumber].supplierAmountReserved = supplierAmountReserved;
        _metadata[assetNumber]
            .reservePaymentTransactionId = reservePaymentTransactionId;
        emit AssetSettledMetadataSet(
            assetNumber,
            supplierAmountReserved,
            reservePaymentTransactionId,
            paymentReserveDate
        );
    }

    /**
     * @dev Implementation of a getter for asset metadata
     * @return Metadata The metadata related to a specific asset
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function _getAsset(uint assetNumber)
        private
        view
        returns (Metadata memory)
    {
        return _metadata[assetNumber];
    }

    /**
     * @dev Calculate the number of late days
     * @return uint16 Number of Late Days
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function _calculateLateDays(uint assetNumber)
        private
        view
        returns (uint16)
    {
        Metadata memory assetMetadata = _getAsset(assetNumber);
        return
            _formulas.lateDaysCalculation(
                assetMetadata.paymentReceiptDate,
                assetMetadata.initialMetadata.dueDate,
                assetMetadata.initialMetadata.gracePeriod
            );
    }

    /**
     * @dev Calculate the advanced amount
     * @return uint Advanced Amount
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function _calculateAdvancedAmount(uint assetNumber)
        private
        view
        returns (uint)
    {
        Metadata memory assetMetadata = _getAsset(assetNumber);
        return
            _formulas.advancedAmountCalculation(
                assetMetadata.initialMetadata.invoiceLimit,
                assetMetadata.initialMetadata.advanceRatio
            );
    }

    /**
     * @dev Calculate the factoring amount
     * @return uint Factoring Amount
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function _calculateFactoringAmount(uint assetNumber)
        private
        view
        returns (uint)
    {
        Metadata memory assetMetadata = _getAsset(assetNumber);
        return
            _formulas.factoringAmountCalculation(
                assetMetadata.initialMetadata.invoiceAmount,
                assetMetadata.initialMetadata.factoringFee
            );
    }

    /**
     * @dev Calculate the total amount received
     * @return uint Total Received Amount
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function _calculateTotalAmountReceived(uint assetNumber)
        private
        view
        returns (uint)
    {
        Metadata memory assetMetadata = _getAsset(assetNumber);
        return
            _formulas.totalAmountReceivedCalculation(
                assetMetadata.buyerAmountReceived,
                assetMetadata.supplierAmountReceived
            );
    }

    /**
     * @dev Calculate the tenure
     * @return uint Invoice Tenure or Finance Tenure
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function _calculateTenure(uint assetNumber) private view returns (uint16) {
        Metadata memory assetMetadata = _getAsset(assetNumber);
        return
            assetMetadata.paymentReceiptDate == 0
                ? _formulas.invoiceTenureCalculation(
                    assetMetadata.initialMetadata.dueDate,
                    assetMetadata.initialMetadata.invoiceDate
                )
                : _formulas.financeTenureCalculation(
                    assetMetadata.paymentReceiptDate,
                    assetMetadata.initialMetadata.fundsAdvancedDate
                );
    }

    /**
     * @dev Calculate the discount amount
     * @return uint Amount of the Discount
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function _calculateDiscountAmount(uint assetNumber)
        private
        view
        returns (uint)
    {
        Metadata memory assetMetadata = _getAsset(assetNumber);
        uint16 tenure = _calculateTenure(assetNumber);
        uint16 lateDays = _calculateLateDays(assetNumber);
        uint advancedAmount = _calculateAdvancedAmount(assetNumber);
        return
            _formulas.discountAmountCalculation(
                assetMetadata.initialMetadata.discountFee,
                tenure,
                lateDays,
                advancedAmount
            );
    }

    /**
     * @dev Calculate the total fees amount
     * @return uint Total Amount
     * @param assetNumber The unique uint Asset Number of the NFT
     */
    function _calculateTotalFees(uint assetNumber) private view returns (uint) {
        Metadata memory assetMetadata = _getAsset(assetNumber);
        uint factoringAmount = _calculateFactoringAmount(assetNumber);
        uint discountAmount = _calculateDiscountAmount(assetNumber);
        return
            _formulas.totalFeesCalculation(
                factoringAmount,
                discountAmount,
                assetMetadata.initialMetadata.additionalFee,
                assetMetadata.initialMetadata.bankChargesFee
            );
    }
}
