//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {TokenSale} from "../src/TokenSale.sol";
import {DeployTokenSale} from "../script/DeployTokenSale.s.sol";

contract TokenSaleTest is Test {
    DeployTokenSale public deployer;
    TokenSale public tokenSale;
    address public User = makeAddr("user");

    function setUp() public {
        deployer = new DeployTokenSale();
        tokenSale = new TokenSale();
        tokenSale = deployer.run();
        vm.deal(User, 10 ether);
    }

    function testMinimumUSD() public {
        uint256 minimumUsd = 0.001 ether;
        assertEq(minimumUsd, tokenSale.MINIMUM_USD());
    }

    function testBuyTokens() public {
        vm.prank(User);
        uint256 actualTokens = tokenSale.buyTokens{value: 1 ether}();
        uint256 expectedTokens = 100 * 1e18;
        assertEq(actualTokens, expectedTokens);
        assertEq(tokenSale.totalRaised(), 1 ether);
    }

    function testWithdraw() public {
        vm.prank(User);
        tokenSale.buyTokens{value: 3 ether}();
        vm.prank(msg.sender);
        tokenSale.withdraw();
    }

    function testChangeOwner() public {
        address owner = msg.sender;
        address newOwner = makeAddr("newOwner");
        vm.prank(owner);
        tokenSale.changeOwner(newOwner);
        assertEq(tokenSale.owner(), newOwner);
    }
}
