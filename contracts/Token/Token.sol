// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title The token used to pay for getting AssetNFTs
 * @author Polytrade.Finance
 * @dev IERC20 used for test purposes
 */
contract Token is ERC20 {
    constructor(
        string memory _name,
        string memory _symbol,
        address _receiver,
        uint _totalSupply
    ) ERC20(_name, _symbol) {
        _mint(_receiver, _totalSupply * 1 ether);
    }

    function mint(address _receiver, uint _amount) public {
        _mint(_receiver, _amount);
    }

    function approve(
        address _owner,
        address _spender,
        uint _amount
    ) public {
        _approve(_owner, _spender, _amount);
    }
}
