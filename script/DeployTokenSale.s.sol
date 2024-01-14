//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {TokenSale} from "../src/TokenSale.sol";

contract DeployTokenSale is Script {
    function run() external returns (TokenSale) {
        vm.startBroadcast();
        TokenSale tokenSale = new TokenSale();
        vm.stopBroadcast();
        return tokenSale;
    }
}
