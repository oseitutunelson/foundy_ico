//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    uint256 private initialSupply = 1000 * 1e18;

    constructor() ERC20("ETOKEN", "ETK") {
        _mint(msg.sender, initialSupply);
    }

    function getTotalSupply() public view returns (uint256) {
        return initialSupply;
    }
}
