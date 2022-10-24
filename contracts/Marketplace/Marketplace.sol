// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "../AssetNFT/IAssetNFT.sol";

/**
 * @title The common marketplace for the AssetNFTs
 * @author Polytrade.Finance
 * @dev Implementation of all AssetNFT trading operations
 * @custom:receiver Receiver contract able to receiver tokens
 */
contract Marketplace is IERC721Receiver, Ownable {
    IAssetNFT public assetNFT;

    /**
     * @dev Constructor for the main Marketplace
     * @param _assetNFTAddress The address of the Asset NFT used in the marketplace
     */
    constructor(address _assetNFTAddress) {
        assetNFT = IAssetNFT(_assetNFTAddress);
    }

    /**
     * @dev Whenever an {IERC721} `assetNumber` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient,
     * the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint assetNumber,
        bytes calldata data
    ) external pure override returns (bytes4) {
        operator;
        from;
        assetNumber;
        data;
        return this.onERC721Received.selector;
    }

    /**
     * @dev Implementation of the function used to buy Asset NFT
     * @param _assetNumber The uint unique number of the Asset NFT
     * @param _buyerAmountReceived The uint value of the amount received from buyer
     * @param _supplierAmountReceived The uint value of the amount received from supplier
     * @param _paymentReceiptDate The uint48 value of the payment receipt date
     */
    function buy(
        uint _assetNumber,
        uint _buyerAmountReceived,
        uint _supplierAmountReceived,
        uint48 _paymentReceiptDate
    ) public {
        assetNFT.buyAsset(
            msg.sender,
            _assetNumber,
            _buyerAmountReceived,
            _supplierAmountReceived,
            _paymentReceiptDate
        );
    }

    /**
     * @dev Implementation of the function used to disbuse money
     * @param _assetNumber The uint unique number of the Asset NFT
     * @return int the required amount to be paied
     */
    function disburse(uint _assetNumber) public view returns (int) {
        int _amount = assetNFT.calculateNetAmountPayableToClient(_assetNumber);

        return _amount;
    }
}
