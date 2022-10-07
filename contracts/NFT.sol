// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
 * @title A simple ERC721 token
 * @author Polytrade.Finance
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 * the Metadata extension
 */
contract NFT is ERC721 {
    /**
     * @title A new struct to define the metadata structure
     * @dev Defining a new type of struct called Metadata to store the asset metadata
     */
    struct Metadata {
        uint16 factoringFee;
        uint16 discountingFee;
        uint16 financedTenure;
        uint16 advancedPercentage;
        uint16 reservePercentage;
        uint16 gracePeriod;
        uint16 lateFeePercentage;
        uint invoiceAmount;
        uint availableAmount;
        uint bankCharges;
    }

    /**
     * @dev Metadata struct and public, we can read it from the smart contract and get the asset metadata
     */
    Metadata public metadata;

    /**
     * @dev Constructor will call the parent one to create an ERC721 with specific name and symbol
     * @param _name String defining the name of the new ERC721 token
     * @param _symbol String defining the symbol of the new ERC721 token
     */
    constructor(string memory _name, string memory _symbol)
        ERC721(_name, _symbol)
    {
        _name;
    }

    /**
     * @dev Implementation of a mint function that uses the predefined _mint() function from ERC721 standard
     * @param _receiver The receiver address of the newly minted NFT
     * @param _tokenId The unique uint token ID of the newly minted NFT
     * @param _metadata Struct of type Metadata contains add metadata need to be verified
     */
    function mint(
        address _receiver,
        uint _tokenId,
        Metadata memory _metadata
    ) public {
        metadata.factoringFee = _metadata.factoringFee;
        metadata.discountingFee = _metadata.discountingFee;
        metadata.financedTenure = _metadata.financedTenure;
        metadata.advancedPercentage = _metadata.advancedPercentage;
        metadata.reservePercentage = _metadata.reservePercentage;
        metadata.gracePeriod = _metadata.gracePeriod;
        metadata.lateFeePercentage = _metadata.lateFeePercentage;
        metadata.invoiceAmount = _metadata.invoiceAmount;
        metadata.availableAmount = _metadata.availableAmount;
        metadata.bankCharges = _metadata.bankCharges;
        _mint(_receiver, _tokenId);
    }
}
