// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title The main interface to define the main marketplace
 * @author Polytrade.Finance
 * @dev Collection of all procedures related to the marketplace
 */
interface IMarketplace {
    /**
     * @dev Emitted when new `newAssetNFT` contract has been set instead of `oldAssetNFT`
     * @param oldAssetNFT The old address of asset NFT contract token
     * @param newAssetNFT The new address of asset NFT contract token
     */
    event AssetNFTSet(address oldAssetNFT, address newAssetNFT);

    /**
     * @dev Emitted when new `stableToken` contract has been set
     * @param stableToken The address of ERC20 contract token
     */
    event StableTokenSet(address stableToken);

    /**
     * @dev Implementation of a setter for the asset NFT contract
     * @param assetNFTAddress The address of the asset NFT contract
     */
    function setAssetNFT(address assetNFTAddress) external;

    /**
     * @dev Implementation of a setter for the ERC20 token
     * @param stableTokenAddress The address of the stableToken (ERC20) contract
     */
    function setStableToken(address stableTokenAddress) external;

    /**
     * @dev Implementation of the function used to buy Asset NFT
     * @param assetNumber The uint unique number of the Asset NFT
     */
    function buy(uint assetNumber) external;

    /**
     * @dev Implementation of the function used to disbuse money
     * @param assetNumber The uint unique number of the Asset NFT
     * @return int the required amount to be paied
     */
    function disburse(uint assetNumber) external view returns (int);

    /**
     * @dev Implementation of a getter for the asset NFT contract
     * @return address The address of the asset NFT contract
     */
    function getAssetNFT() external view returns (address);

    /**
     * @dev Implementation of a getter for the stable coin contract
     * @return address The address of the stable coin contract
     */
    function getStableCoin() external view returns (address);
}
