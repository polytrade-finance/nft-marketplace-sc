// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../AssetNFT/IAssetNFT.sol";
import "../Token/Token.sol";

/**
 * @title The main interface to define the main marketplace
 * @author Polytrade.Finance
 * @dev Collection of all procedures related to the marketplace
 */
interface IMarketplace {
    /**
     * @dev Emitted when new `_newAssetNFT` contract has been set instead of `_oldAssetNFT`
     * @param _oldAssetNFT The old address of asset NFT contract token
     * @param _newAssetNFT The new address of asset NFT contract token
     */
    event AssetNFTSet(address _oldAssetNFT, address _newAssetNFT);

    /**
     * @dev Emitted when new `_stableToken` contract has been set
     * @param _stableToken The address of ERC20 contract token
     */
    event StableTokenSet(address _stableToken);

    /**
     * @dev Implementation of a setter for the asset NFT contract
     * @param _assetNFTAddress The address of the asset NFT contract
     */
    function setAssetNFT(address _assetNFTAddress) external;

    /**
     * @dev Implementation of a setter for the ERC20 token
     * @param _stableTokenAddress The address of the stableToken (ERC20) contract
     */
    function setStableToken(address _stableTokenAddress) external;

    /**
     * @dev Implementation of the function used to buy Asset NFT
     * @param _assetNumber The uint unique number of the Asset NFT
     */
    function buy(uint _assetNumber) external;

    /**
     * @dev Implementation of the function used to disbuse money
     * @param _assetNumber The uint unique number of the Asset NFT
     * @return int the required amount to be paied
     */
    function disburse(uint _assetNumber) external view returns (int);
}
