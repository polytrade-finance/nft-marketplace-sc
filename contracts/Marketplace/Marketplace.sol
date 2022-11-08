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
    IAssetNFT private _assetNFT;
    Token private _stableToken;

    /**
     * @dev Constructor for the main Marketplace
     * @param assetNFTAddress Address of the Asset NFT used in the marketplace
     * @param stableTokenAddress Address of the stableToken (ERC20) contract
     */
    constructor(address assetNFTAddress, address stableTokenAddress) {
        _setAssetNFT(assetNFTAddress);
        _setStableToken(stableTokenAddress);
    }

    /**
     * @dev Implementation of a setter for the asset NFT contract
     * @param assetNFTAddress Address of the asset NFT contract
     */
    function setAssetNFT(address assetNFTAddress) external onlyOwner {
        _setAssetNFT(assetNFTAddress);
    }

    /**
     * @dev Implementation of a setter for the ERC20 token
     * @param stableTokenAddress Address of the stableToken (ERC20) contract
     */
    function setStableToken(address stableTokenAddress) external onlyOwner {
        _setStableToken(stableTokenAddress);
    }

    /**
     * @dev Implementation of the function used to buy Asset NFT
     * @param assetNumber Uint unique number of the Asset NFT
     */
    function buy(uint assetNumber) external {
        address assetOwner = _assetNFT.ownerOf(assetNumber);
        require(assetOwner != address(0), "Asset does not exist");
        uint amount = _assetNFT.calculateReserveAmount(assetNumber);
        _assetNFT.safeTransferFrom(assetOwner, msg.sender, assetNumber);
        require(
            _stableToken.transferFrom(msg.sender, assetOwner, amount),
            "Transfer failed"
        );
    }

    /**
     * @dev Implementation of the function used to disburse money
     * @param assetNumber Uint unique number of the Asset NFT
     * @return int Required amount to be paid
     */
    function disburse(uint assetNumber) external view returns (int) {
        int amount = _assetNFT.calculateNetAmountPayableToClient(assetNumber);

        return amount;
    }

    /**
     * @dev Implementation of a getter for the asset NFT contract
     * @return address Address of the asset NFT contract
     */
    function getAssetNFT() external view returns (address) {
        return address(_assetNFT);
    }

    /**
     * @dev Implementation of a getter for the stable coin contract
     * @return address Address of the stable coin contract
     */
    function getStableCoin() external view returns (address) {
        return address(_stableToken);
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
        address,
        address,
        uint,
        bytes calldata
    ) external pure override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    /**
     * @dev Implementation of a setter for the asset NFT contract
     * @param newAssetNFTAddress Address of the asset NFT contract
     */
    function _setAssetNFT(address newAssetNFTAddress) private {
        address oldAssetNFTAddress = address(_assetNFT);
        _assetNFT = IAssetNFT(newAssetNFTAddress);
        emit AssetNFTSet(oldAssetNFTAddress, newAssetNFTAddress);
    }

    /**
     * @dev Implementation of a setter for the ERC20 token
     * @param stableTokenAddress Address of the stableToken (ERC20) contract
     */
    function _setStableToken(address stableTokenAddress) private {
        _stableToken = Token(stableTokenAddress);
        emit StableTokenSet(stableTokenAddress);
    }
}
