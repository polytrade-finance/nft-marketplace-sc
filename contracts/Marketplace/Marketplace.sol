// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../AssetNFT/IAssetNFT.sol";

/**
 * @title The common marketplace for the AssetNFTs
 * @author Polytrade.Finance
 * @dev Implementation of all AssetNFT trading operations
 * @custom:receiver Receiver contract able to receiver tokens
 */
contract Marketplace is IERC721Receiver, Ownable {
    IAssetNFT private _assetNFT;

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

    function setAssetNFT(address _address) public onlyOwner {
        _assetNFT = IAssetNFT(_address);
    }

    function buy(uint _assetNumber, address _tokenAddress) public {
        address _owner = _assetNFT.ownerOf(_assetNumber);
        uint _amount = _assetNFT
            .getAsset(_assetNumber)
            .initialMetadata
            .invoiceAmount;

        _assetNFT.safeTransferFrom(_owner, msg.sender, _assetNumber);

        IERC20(_tokenAddress).approve(address(this), _amount);
        IERC20(_tokenAddress).transfer(_owner, _amount);
    }
}
