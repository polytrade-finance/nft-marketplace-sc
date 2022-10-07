// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IAssetNFT.sol";

/**
 * @title A simple ERC721 token
 * @author Polytrade.Finance
 * @dev Implementation of Non-Fungible Token Standard, including the Metadata extension
 * @custom:access Accessible only by the owner
 * @custom:indexing Enumerable token can be indexed
 */
contract AssetNFT is ERC721Enumerable, IAssetNFT, Ownable {
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
    function createAsset(
        address _receiver,
        uint _tokenId,
        Metadata memory _metadata
    ) external onlyOwner {
        metadata[_tokenId] = _metadata;

        emit AssetCreate(msg.sender, _receiver, _tokenId);

        _mint(_receiver, _tokenId);
    }
}
