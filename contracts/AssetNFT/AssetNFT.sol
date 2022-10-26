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
    IFormulas public formulas;
    /**
     * @dev Mapping will be indexing the metadata for each AssetNFT by its Asset Number
     */
    mapping(uint => Metadata) private _metadata;

    /**
     * @dev Constructor will call the parent one to create an ERC721 with specific name and symbol
     * @param _name String defining the name of the new ERC721 token
     * @param _symbol String defining the symbol of the new ERC721 token
     * @param _formulasAddress The address of the formulas calculation contract
     */
    constructor(
        string memory _name,
        string memory _symbol,
        address _formulasAddress
    ) ERC721(_name, _symbol) {
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
     * @param _supplierAmountReserved The uint value of the reserved amount send to supplier
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
        Metadata memory assetMetadata = _getAsset(_assetNumber);
        return
            formulas.lateDays(
                assetMetadata.paymentReceiptDate,
                assetMetadata.initialMetadata.dueDate,
                assetMetadata.initialMetadata.gracePeriod
            );
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
        Metadata memory assetMetadata = _getAsset(_assetNumber);
        uint16 tenure = assetMetadata.paymentReceiptDate == 0
            ? formulas.invoiceTenure(
                assetMetadata.initialMetadata.dueDate,
                assetMetadata.initialMetadata.invoiceDate
            )
            : formulas.financeTenure(
                assetMetadata.paymentReceiptDate,
                assetMetadata.initialMetadata.fundsAdvancedDate
            );
        uint16 lateDays = formulas.lateDays(
            assetMetadata.paymentReceiptDate,
            assetMetadata.initialMetadata.dueDate,
            assetMetadata.initialMetadata.gracePeriod
        );
        uint advancedAmount = formulas.advancedAmount(
            assetMetadata.initialMetadata.invoiceLimit,
            assetMetadata.initialMetadata.advanceRatio
        );
        return
            formulas.discountAmount(
                assetMetadata.initialMetadata.discountFee,
                tenure,
                lateDays,
                advancedAmount
            );
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
        uint16 lateDays = formulas.lateDays(
            assetMetadata.paymentReceiptDate,
            assetMetadata.initialMetadata.dueDate,
            assetMetadata.initialMetadata.gracePeriod
        );
        uint advancedAmount = formulas.advancedAmount(
            assetMetadata.initialMetadata.invoiceLimit,
            assetMetadata.initialMetadata.advanceRatio
        );
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
    function calculateFactoringAmount(uint _assetNumber)
        external
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
        uint advancedAmount = formulas.advancedAmount(
            assetMetadata.initialMetadata.invoiceLimit,
            assetMetadata.initialMetadata.advanceRatio
        );
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
     * @dev Calculate the total fees amount
     * @return uint Total Amount
     * @param _assetNumber The unique uint Asset Number of the NFT
     */
    function calculateTotalFees(uint _assetNumber)
        external
        view
        returns (uint)
    {
        Metadata memory assetMetadata = _getAsset(_assetNumber);
        uint16 tenure = assetMetadata.paymentReceiptDate == 0
            ? formulas.invoiceTenure(
                assetMetadata.initialMetadata.dueDate,
                assetMetadata.initialMetadata.invoiceDate
            )
            : formulas.financeTenure(
                assetMetadata.paymentReceiptDate,
                assetMetadata.initialMetadata.fundsAdvancedDate
            );
        uint16 lateDays = formulas.lateDays(
            assetMetadata.paymentReceiptDate,
            assetMetadata.initialMetadata.dueDate,
            assetMetadata.initialMetadata.gracePeriod
        );
        uint advancedAmount = formulas.advancedAmount(
            assetMetadata.initialMetadata.invoiceLimit,
            assetMetadata.initialMetadata.advanceRatio
        );
        uint factoringAmount = formulas.factoringAmount(
            assetMetadata.initialMetadata.invoiceAmount,
            assetMetadata.initialMetadata.factoringFee
        );
        uint discountAmount = formulas.discountAmount(
            assetMetadata.initialMetadata.discountFee,
            tenure,
            lateDays,
            advancedAmount
        );
        return
            formulas.totalFees(
                factoringAmount,
                discountAmount,
                assetMetadata.initialMetadata.additionalFee,
                assetMetadata.initialMetadata.bankChargesFee
            );
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
        Metadata memory assetMetadata = _getAsset(_assetNumber);
        uint advancedAmount = formulas.advancedAmount(
            assetMetadata.initialMetadata.invoiceLimit,
            assetMetadata.initialMetadata.advanceRatio
        );
        uint16 tenure = assetMetadata.paymentReceiptDate == 0
            ? formulas.invoiceTenure(
                assetMetadata.initialMetadata.dueDate,
                assetMetadata.initialMetadata.invoiceDate
            )
            : formulas.financeTenure(
                assetMetadata.paymentReceiptDate,
                assetMetadata.initialMetadata.fundsAdvancedDate
            );
        uint16 lateDays = formulas.lateDays(
            assetMetadata.paymentReceiptDate,
            assetMetadata.initialMetadata.dueDate,
            assetMetadata.initialMetadata.gracePeriod
        );
        uint factoringAmount = formulas.factoringAmount(
            assetMetadata.initialMetadata.invoiceAmount,
            assetMetadata.initialMetadata.factoringFee
        );
        uint discountAmount = formulas.discountAmount(
            assetMetadata.initialMetadata.discountFee,
            tenure,
            lateDays,
            advancedAmount
        );
        uint totalAmountReceived = formulas.totalAmountReceived(
            assetMetadata.buyerAmountReceived,
            assetMetadata.supplierAmountReceived
        );
        uint totalFees = formulas.totalFees(
            factoringAmount,
            discountAmount,
            assetMetadata.initialMetadata.additionalFee,
            assetMetadata.initialMetadata.bankChargesFee
        );
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
        Metadata memory assetMetadata = _getAsset(_assetNumber);
        return
            formulas.totalAmountReceived(
                assetMetadata.buyerAmountReceived,
                assetMetadata.supplierAmountReceived
            );
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
            msg.sender,
            _assetNumber,
            _buyerAmountReceived,
            _supplierAmountReceived,
            _paymentReceiptDate
        );
    }

    /**
     * @dev Implementation of a setter for the formulas contract
     * @param _formulasAddress The address of the formulas calculation contract
     */
    function _setFormulas(address _formulasAddress) private {
        formulas = IFormulas(_formulasAddress);
        emit FormulasSet(msg.sender, _formulasAddress);
    }

    /**
     * @dev Implementation of a setter for
     * payment receipt date & amount received from buyer & amout received from supplier
     * @param _assetNumber The unique uint Asset Number of the NFT
     * @param _supplierAmountReserved The uint value of the reserved amount send to supplier
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
            msg.sender,
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
}
