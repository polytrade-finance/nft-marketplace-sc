// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
 * @title A simple ERC721 token
 * @author Polytrade.Finance
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 * the Metadata extension
 */
contract NFT is ERC721 {
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    /**
    * @dev Implementation of a mint function that uses the predefined _mint() function from ERC721 standard
    * @param _receiver The receiver of the newly minted NFT
    * @param _tokenId The unique token ID of the newly minted NFT
    */
    function mint(address _receiver, uint _tokenId) public {
        _mint(_receiver, _tokenId);
    }
}