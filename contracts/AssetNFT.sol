// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./IAssetNFT.sol";

/**
 * @title A simple ERC721 token
 * @author Polytrade.Finance
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 * the Metadata extension
 */
contract AssetNFT is ERC721, IAssetNFT {
    /**
     * @dev Mapping will be indexing the metadata for each AssetNFT by its token ID
     */
    mapping(uint => Metadata) public metadata;

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
    ) external {
        metadata[_tokenId] = _metadata;
        _mint(_receiver, _tokenId);
    }
}
