// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./IMarketplace.sol";
import "../AssetNFT/IAssetNFT.sol";
import "../Token/Token.sol";

/**
 * @title The common marketplace for the AssetNFTs
 * @author Polytrade.Finance
 * @dev Implementation of all AssetNFT trading operations
 * @custom:receiver Receiver contract able to receiver tokens
 */
contract Marketplace is IERC721Receiver, Ownable, IMarketplace {
    IAssetNFT public assetNFT;
    Token public stableToken;

    /**
     * @dev Constructor for the main Marketplace
     * @param _assetNFTAddress The address of the Asset NFT used in the marketplace
     * @param _stableTokenAddress The address of the stableToken (ERC20) contract
     */
    constructor(address _assetNFTAddress, address _stableTokenAddress) {
        _setAssetNFT(_assetNFTAddress);
        _setStableToken(_stableTokenAddress);
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
     * @param _stableTokenAddress The address of the stableToken (ERC20) contract
     */
    function setStableToken(address _stableTokenAddress) external onlyOwner {
        _setStableToken(_stableTokenAddress);
    }

    /**
     * @dev Implementation of the function used to buy Asset NFT
     * @param _assetNumber The uint unique number of the Asset NFT
     */
    function buy(uint _assetNumber) external {
        address _owner = assetNFT.ownerOf(_assetNumber);
        require(_owner != address(0), "Asset does not exist");
        uint _amount = assetNFT.calculateReserveAmount(_assetNumber);
        assetNFT.safeTransferFrom(_owner, msg.sender, _assetNumber);
        stableToken.transferFrom(msg.sender, _owner, _amount);
    }

    /**
     * @dev Implementation of the function used to disbuse money
     * @param _assetNumber The uint unique number of the Asset NFT
     * @return int the required amount to be paied
     */
    function disburse(uint _assetNumber) external view returns (int) {
        int _amount = assetNFT.calculateNetAmountPayableToClient(_assetNumber);

        return _amount;
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
     * @dev Implementation of a setter for the asset NFT contract
     * @param _newAssetNFTAddress The address of the asset NFT contract
     */
    function _setAssetNFT(address _newAssetNFTAddress) private {
        address _oldAssetNFTAddress = address(assetNFT);
        assetNFT = IAssetNFT(_newAssetNFTAddress);
        emit AssetNFTSet(_oldAssetNFTAddress, _newAssetNFTAddress);
    }

    /**
     * @dev Implementation of a setter for the ERC20 token
     * @param _stableTokenAddress The address of the stableToken (ERC20) contract
     */
    function _setStableToken(address _stableTokenAddress) private {
        stableToken = Token(_stableTokenAddress);
        emit StableTokenSet(_stableTokenAddress);
    }
}
