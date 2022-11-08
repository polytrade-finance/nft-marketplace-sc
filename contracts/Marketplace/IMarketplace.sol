// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

/**
 * @title The main interface to define the main marketplace
 * @author Polytrade.Finance
 * @dev Collection of all procedures related to the marketplace
 */
interface IMarketplace {
    /**
     * @dev Emitted when new `newAssetNFT` contract has been set instead of `oldAssetNFT`
     * @param oldAssetNFT Old address of asset NFT contract token
     * @param newAssetNFT New address of asset NFT contract token
     */
    event AssetNFTSet(address oldAssetNFT, address newAssetNFT);

    /**
     * @dev Emitted when new `stableToken` contract has been set
     * @param stableToken Address of ERC20 contract token
     */
    event StableTokenSet(address stableToken);

    /**
     * @dev Implementation of a setter for the asset NFT contract
     * @param assetNFTAddress Address of the asset NFT contract
     */
    function setAssetNFT(address assetNFTAddress) external;

    /**
     * @dev Implementation of a setter for the ERC20 token
     * @param stableTokenAddress Address of the stableToken (ERC20) contract
     */
    function setStableToken(address stableTokenAddress) external;

    /**
     * @dev Implementation of the function used to buy Asset NFT
     * @param assetNumber Uint unique number of the Asset NFT
     */
    function buy(uint assetNumber) external;

    /**
     * @dev Implementation of the function used to disburse money
     * @param assetNumber Uint unique number of the Asset NFT
     * @return int Required amount to be paid
     */
    function disburse(uint assetNumber) external returns (int);

    /**
     * @dev Implementation of a getter for the asset NFT contract
     * @return address Address of the asset NFT contract
     */
    function getAssetNFT() external view returns (address);

    /**
     * @dev Implementation of a getter for the stable coin contract
     * @return address Address of the stable coin contract
     */
    function getStableCoin() external view returns (address);
}
