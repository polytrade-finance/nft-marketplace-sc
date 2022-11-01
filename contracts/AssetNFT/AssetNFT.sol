// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
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
    IFormulas public formulas;
    string public baseURI;

    /**
     * @dev Mapping will be indexing the metadata for each AssetNFT by its Asset Number
     */
    mapping(uint => Metadata) private _metadata;

    /**
     * @dev Constructor will call the parent one to create an ERC721 with specific name and symbol
     * @param _name String defining the name of the new ERC721 token
     * @param _symbol String defining the symbol of the new ERC721 token
     * @param _baseURI The string of the asset base URI
     * @param _formulasAddress The address of the formulas calculation contract
     */
    constructor(
        string memory _name,
        string memory _symbol,
        string memory _baseURI,
        address _formulasAddress
    ) ERC721(_name, _symbol) {
        _setBaseURI(_baseURI);
        _setFormulas(_formulasAddress);
    }

    /**
     * @dev Implementation of a mint function that uses the predefined _mint() function from ERC721 standard
     * @param _receiver The receiver address of the newly minted NFT
     * @param _assetNumber The unique uint Asset Number of the NFT
     * @param _initialMetadata Struct of type InitialMetadata contains initial metadata need to be verified
     */
    function createAsset(
        address _receiver,
        uint _assetNumber,
        InitialMetadata memory _initialMetadata
    ) external onlyOwner {
        require(
            ((_initialMetadata.dueDate - _initialMetadata.fundsAdvancedDate) /
                1 days) >= 20,
            "Asset due less than 20 days"
        );
        _metadata[_assetNumber].initialMetadata = _initialMetadata;
        _mint(_receiver, _assetNumber);
        emit AssetCreate(msg.sender, _receiver, _assetNumber);
    }

    /**
     * @dev Implementation of a setter for the formulas contract
     * @param _formulasAddress The address of the formulas calculation contract
     */
    function setFormulas(address _formulasAddress) external onlyOwner {
        _setFormulas(_formulasAddress);
    }

    /**
     * @dev Implementation of a setter for the asset base URI
     * @param _newBaseURI The string of the asset base URI
     */
    function setBaseURI(string memory _newBaseURI) external onlyOwner {
        _setBaseURI(_newBaseURI);
    }

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
    ) external onlyOwner {
        _setAdditionalMetadata(
            _assetNumber,
            _buyerAmountReceived,
            _supplierAmountReceived,
            _paymentReceiptDate
        );
    }

    /**
     * @dev Implementation of a setter for
     * payment receipt date & amount received from buyer & amout received from supplier
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
    ) external onlyOwner {
        _setAssetSettledMetadata(
            _assetNumber,
            _supplierAmountReserved,
            _reservePaymentTransactionId,
            _paymentReserveDate
        );
    }

    /**
     * @dev Implementation of a getter for asset metadata
     * @return Metadata The metadata related to a specific asset
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function getAsset(uint _assetNumber)
        external
        view
        returns (Metadata memory)
    {
        return _getAsset(_assetNumber);
    }

    /**
     * @dev Calculate the number of late days
     * @return uint16 Number of Late Days
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function calculateLateDays(uint _assetNumber)
        external
        view
        returns (uint16)
    {
        return _calculateLateDays(_assetNumber);
    }

    /**
     * @dev Calculate the discount amount
     * @return uint Amount of the Discount
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function calculateDiscountAmount(uint _assetNumber)
        external
        view
        returns (uint)
    {
        return _calculateDiscountAmount(_assetNumber);
    }

    /**
     * @dev Calculate the late amount
     * @return uint Late Amount
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function calculateLateAmount(uint _assetNumber)
        external
        view
        returns (uint)
    {
        Metadata memory assetMetadata = _getAsset(_assetNumber);
        uint16 lateDays = _calculateLateDays(_assetNumber);
        uint advancedAmount = _calculateAdvancedAmount(_assetNumber);
        return
            formulas.lateAmount(
                assetMetadata.initialMetadata.lateFee,
                lateDays,
                advancedAmount
            );
    }

    /**
     * @dev Calculate the advanced amount
     * @return uint Advanced Amount
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function calculateAdvancedAmount(uint _assetNumber)
        external
        view
        returns (uint)
    {
        return _calculateAdvancedAmount(_assetNumber);
    }

    /**
     * @dev Calculate the factoring amount
     * @return uint Factoring Amount
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function calculateFactoringAmount(uint _assetNumber)
        external
        view
        returns (uint)
    {
        return _calculateFactoringAmount(_assetNumber);
    }

    /**
     * @dev Calculate the invoice tenure
     * @return uint24 Invoice Tenure
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function calculateInvoiceTenure(uint _assetNumber)
        external
        view
        returns (uint24)
    {
        Metadata memory assetMetadata = _getAsset(_assetNumber);
        return
            formulas.invoiceTenure(
                assetMetadata.initialMetadata.dueDate,
                assetMetadata.initialMetadata.invoiceDate
            );
    }

    /**
     * @dev Calculate the reserve amount
     * @return uint Reserve Amount
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function calculateReserveAmount(uint _assetNumber)
        external
        view
        returns (uint)
    {
        Metadata memory assetMetadata = _getAsset(_assetNumber);
        uint advancedAmount = _calculateAdvancedAmount(_assetNumber);
        return
            formulas.reserveAmount(
                assetMetadata.initialMetadata.invoiceAmount,
                advancedAmount
            );
    }

    /**
     * @dev Calculate the finance tenure
     * @return uint24 Finance Tenure
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function calculateFinanceTenure(uint _assetNumber)
        external
        view
        returns (uint24)
    {
        return _calculateTenure(_assetNumber);
    }

    /**
     * @dev Calculate the total fees amount
     * @return uint Total Amount
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function calculateTotalFees(uint _assetNumber)
        external
        view
        returns (uint)
    {
        return _calculateTotalFees(_assetNumber);
    }

    /**
     * @dev Calculate the net amount payable to the client
     * @return uint Net Amount Payable to the Client
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function calculateNetAmountPayableToClient(uint _assetNumber)
        external
        view
        returns (int)
    {
        uint advancedAmount = _calculateAdvancedAmount(_assetNumber);
        uint totalAmountReceived = _calculateTotalAmountReceived(_assetNumber);
        uint totalFees = _calculateTotalFees(_assetNumber);
        return
            formulas.netAmountPayableToClient(
                totalAmountReceived,
                advancedAmount,
                totalFees
            );
    }

    /**
     * @dev Calculate the total amount received
     * @return uint Total Received Amount
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function calculateTotalAmountReceived(uint _assetNumber)
        external
        view
        returns (uint)
    {
        return _calculateTotalAmountReceived(_assetNumber);
    }

    /**
     * @dev Implementation of a getter for asset NFT URI
     * @return string The URI for the asset NFT
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function tokenURI(uint _assetNumber)
        public
        view
        virtual
        override
        returns (string memory)
    {
        string memory _stringAssetNumber = Strings.toString(_assetNumber);
        return string.concat(baseURI, _stringAssetNumber);
    }

    /**
     * @dev Implementation of a setter for
     * payment receipt date & amount received from buyer & amout received from supplier
     * @param _assetNumber The unique uint Asset Number of the NFT
     * @param _buyerAmountReceived The uint value of the amount received from buyer
     * @param _supplierAmountReceived The uint value of the amount received from supplier
     * @param _paymentReceiptDate The uint48 value of the payment receipt date
     */
    function _setAdditionalMetadata(
        uint _assetNumber,
        uint _buyerAmountReceived,
        uint _supplierAmountReceived,
        uint48 _paymentReceiptDate
    ) private {
        require(
            _metadata[_assetNumber].supplierAmountReserved == 0 &&
                _metadata[_assetNumber].reservePaymentTransactionId == 0 &&
                _metadata[_assetNumber].paymentReserveDate == 0,
            "Asset is already settled"
        );
        _metadata[_assetNumber].paymentReceiptDate = _paymentReceiptDate;
        _metadata[_assetNumber].buyerAmountReceived = _buyerAmountReceived;
        _metadata[_assetNumber]
            .supplierAmountReceived = _supplierAmountReceived;
        emit AdditionalMetadataSet(
            _assetNumber,
            _buyerAmountReceived,
            _supplierAmountReceived,
            _paymentReceiptDate
        );
    }

    /**
     * @dev Implementation of a setter for the formulas contract
     * @param _newFormulasAddress The address of the formulas calculation contract
     */
    function _setFormulas(address _newFormulasAddress) private {
        address _oldFormulasAddress = address(formulas);
        formulas = IFormulas(_newFormulasAddress);
        emit FormulasSet(_oldFormulasAddress, _newFormulasAddress);
    }

    /**
     * @dev Implementation of a setter for the asset base URI
     * @param _newBaseURI The string of the asset base URI
     */
    function _setBaseURI(string memory _newBaseURI) private {
        string memory _oldBaseURI = baseURI;
        baseURI = _newBaseURI;
        emit AssetBaseURISet(_oldBaseURI, _newBaseURI);
    }

    /**
     * @dev Implementation of a setter for
     * payment receipt date & amount received from buyer & amout received from supplier
     * @param _assetNumber The unique uint Asset Number of the NFT
     * @param _supplierAmountReserved The uint value of the reserved amount sent to supplier
     * @param _reservePaymentTransactionId The uint value of the payment transaction ID
     * @param _paymentReserveDate The uint48 value of the reserve payment date
     */
    function _setAssetSettledMetadata(
        uint _assetNumber,
        uint _supplierAmountReserved,
        uint _reservePaymentTransactionId,
        uint48 _paymentReserveDate
    ) private {
        require(
            _metadata[_assetNumber].supplierAmountReserved == 0 &&
                _metadata[_assetNumber].reservePaymentTransactionId == 0 &&
                _metadata[_assetNumber].paymentReserveDate == 0,
            "Asset is already settled"
        );
        _metadata[_assetNumber].paymentReserveDate = _paymentReserveDate;
        _metadata[_assetNumber]
            .supplierAmountReserved = _supplierAmountReserved;
        _metadata[_assetNumber]
            .reservePaymentTransactionId = _reservePaymentTransactionId;
        emit AssetSettledMetadataSet(
            _assetNumber,
            _supplierAmountReserved,
            _reservePaymentTransactionId,
            _paymentReserveDate
        );
    }

    /**
     * @dev Implementation of a getter for asset metadata
     * @return Metadata The metadata related to a specific asset
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function _getAsset(uint _assetNumber)
        private
        view
        returns (Metadata memory)
    {
        return _metadata[_assetNumber];
    }

    /**
     * @dev Calculate the number of late days
     * @return uint16 Number of Late Days
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function _calculateLateDays(uint _assetNumber)
        private
        view
        returns (uint16)
    {
        Metadata memory assetMetadata = _getAsset(_assetNumber);
        return
            formulas.lateDays(
                assetMetadata.paymentReceiptDate,
                assetMetadata.initialMetadata.dueDate,
                assetMetadata.initialMetadata.gracePeriod
            );
    }

    /**
     * @dev Calculate the advanced amount
     * @return uint Advanced Amount
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function _calculateAdvancedAmount(uint _assetNumber)
        private
        view
        returns (uint)
    {
        Metadata memory assetMetadata = _getAsset(_assetNumber);
        return
            formulas.advancedAmount(
                assetMetadata.initialMetadata.invoiceLimit,
                assetMetadata.initialMetadata.advanceRatio
            );
    }

    /**
     * @dev Calculate the factoring amount
     * @return uint Factoring Amount
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function _calculateFactoringAmount(uint _assetNumber)
        private
        view
        returns (uint)
    {
        Metadata memory assetMetadata = _getAsset(_assetNumber);
        return
            formulas.factoringAmount(
                assetMetadata.initialMetadata.invoiceAmount,
                assetMetadata.initialMetadata.factoringFee
            );
    }

    /**
     * @dev Calculate the total amount received
     * @return uint Total Received Amount
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function _calculateTotalAmountReceived(uint _assetNumber)
        private
        view
        returns (uint)
    {
        Metadata memory assetMetadata = _getAsset(_assetNumber);
        return
            formulas.totalAmountReceived(
                assetMetadata.buyerAmountReceived,
                assetMetadata.supplierAmountReceived
            );
    }

    /**
     * @dev Calculate the tenure
     * @return uint Invoice Tenure or Finance Tenure
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function _calculateTenure(uint _assetNumber) private view returns (uint16) {
        Metadata memory assetMetadata = _getAsset(_assetNumber);
        return
            assetMetadata.paymentReceiptDate == 0
                ? formulas.invoiceTenure(
                    assetMetadata.initialMetadata.dueDate,
                    assetMetadata.initialMetadata.invoiceDate
                )
                : formulas.financeTenure(
                    assetMetadata.paymentReceiptDate,
                    assetMetadata.initialMetadata.fundsAdvancedDate
                );
    }

    /**
     * @dev Calculate the discount amount
     * @return uint Amount of the Discount
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function _calculateDiscountAmount(uint _assetNumber)
        private
        view
        returns (uint)
    {
        Metadata memory assetMetadata = _getAsset(_assetNumber);
        uint16 tenure = _calculateTenure(_assetNumber);
        uint16 lateDays = _calculateLateDays(_assetNumber);
        uint advancedAmount = _calculateAdvancedAmount(_assetNumber);
        return
            formulas.discountAmount(
                assetMetadata.initialMetadata.discountFee,
                tenure,
                lateDays,
                advancedAmount
            );
    }

    /**
     * @dev Calculate the total fees amount
     * @return uint Total Amount
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function _calculateTotalFees(uint _assetNumber)
        private
        view
        returns (uint)
    {
        Metadata memory assetMetadata = _getAsset(_assetNumber);
        uint factoringAmount = _calculateFactoringAmount(_assetNumber);
        uint discountAmount = _calculateDiscountAmount(_assetNumber);
        return
            formulas.totalFees(
                factoringAmount,
                discountAmount,
                assetMetadata.initialMetadata.additionalFee,
                assetMetadata.initialMetadata.bankChargesFee
            );
    }
}
