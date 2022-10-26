// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "../Token/Token.sol";
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
    Token public usdt;

    /**
     * @dev Emitted when new `_assetNFT` contract has been set
     * @param _assetNFT The address of asset NFT contract token
     */
    event AssetNFTSet(address _assetNFT);

    /**
     * @dev Emitted when new `_usdt` contract has been set
     * @param _usdt The address of ERC20 contract token
     */
    event USDTSet(address _usdt);

    /**
     * @dev Constructor for the main Marketplace
     * @param _assetNFTAddress The address of the Asset NFT used in the marketplace
     * @param _usdtAddress The address of the usdt (ERC20) contract
     */
    constructor(address _assetNFTAddress, address _usdtAddress) {
        _setAssetNFT(_assetNFTAddress);
        _setUSDT(_usdtAddress);
    }

    /**
     * @dev Implementation of a setter for the asset NFT contract
     * @param _assetNFTAddress The address of the asset NFT contract
     */
    function setAssetNFT(address _assetNFTAddress) external onlyOwner {
        _setAssetNFT(_assetNFTAddress);
    }

    /**
     * @dev Implementation of a setter for the ERC20 token
     * @param _usdtAddress The address of the usdt (ERC20) contract
     */
    function setUSDT(address _usdtAddress) external onlyOwner {
        _setUSDT(_usdtAddress);
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
     */
    function buy(uint _assetNumber) public {
        address _owner = assetNFT.ownerOf(_assetNumber);
        require(_owner != address(0), "Asset does not exist");
        uint _amount = assetNFT.calculateReserveAmount(_assetNumber);
        assetNFT.safeTransferFrom(_owner, msg.sender, _assetNumber);
        usdt.approve(msg.sender, address(this), _amount);
        usdt.transferFrom(msg.sender, _owner, _amount);
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

    /**
     * @dev Implementation of a setter for the asset NFT contract
     * @param _assetNFTAddress The address of the asset NFT contract
     */
    function _setAssetNFT(address _assetNFTAddress) private {
        assetNFT = IAssetNFT(_assetNFTAddress);
        emit AssetNFTSet(_assetNFTAddress);
    }

    /**
     * @dev Implementation of a setter for the ERC20 token
     * @param _usdtAddress The address of the usdt (ERC20) contract
     */
    function _setUSDT(address _usdtAddress) private {
        usdt = Token(_usdtAddress);
        emit USDTSet(_usdtAddress);
    }
}
