//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

/**
 * @title Token Sale contract
 * @author Owusu Nelson Osei Tutu
 * @notice token sale contract -- used for buy created tokens with eth -- like ico offerings
 */

import {Token} from "./Token.sol";

contract TokenSale {
    Token public token = new Token();

    //events
    event BuyTokens(address indexed buyer, uint256 amountTokens, uint256 ethAmount);
    event SellTokens(address indexed seller, address indexed reciever, uint256 amountToSell);
    event ChangeOwner(address indexed oldOwner,address indexed newOwner);

    //state variables
    address public owner;
    uint256 public totalRaised = 0;
    uint256 public totalSupply = token.getTotalSupply();
    uint256 tokensPerEth = 100;
    uint256 public vendorBalance = token.balanceOf(address(this));
    mapping(address => uint256) public tokenBalances;

    //minimum amount to buy tokens
    uint256 public constant MINIMUM_USD = 0.001 ether;

    //modifiers
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    //functions

    constructor() {
        owner = msg.sender;
    }

    //buying tokens
    function buyTokens() public payable returns (uint256) {
        uint256 amount = msg.value;
        require(amount >= MINIMUM_USD);
        totalRaised = totalRaised + amount;

        //transfer tokens
        uint256 amountToBuy = amount * tokensPerEth;
        require(vendorBalance > amountToBuy);

        (bool sent) = token.transfer(msg.sender, amountToBuy);
        require(sent, "transaction failed");

        //update msg.sender token balance
        vendorBalance = vendorBalance - amountToBuy;
        tokenBalances[msg.sender] += amountToBuy;

        emit BuyTokens(msg.sender, amountToBuy, amount);

        return amountToBuy;
    }

    //withdraw eth
    function withdraw() public onlyOwner {
        (bool sent,) = msg.sender.call{value: totalRaised}("");
        require(sent, "transaction failed");
    }

    //allow users to sell their tokens back for eth
    function sellTokens(uint256 amountToSell) public returns (uint256) {
        require(amountToSell > 0, "Amount to sell must be greater than 0");

        uint256 sellerBalance = token.balanceOf(msg.sender);
        uint256 amountOfEthToTransact = amountToSell / tokensPerEth;

        require(sellerBalance >= amountToSell, "Insufficient balance");
        require(vendorBalance >= amountOfEthToTransact, "Insufficient ETH balance");
        token.approve(address(this), amountToSell);
        // Ensure that the contract is approved to spend the tokens
        require(token.approve(address(this), amountToSell), "Token approval failed");
        // Transfer tokens from the seller to the contract
        (bool allowanceApproved) = token.transferFrom(msg.sender, address(this), amountToSell);
        require(allowanceApproved, "Token transfer failed");

        // Transfer ETH to the seller
        (bool ethTransferred,) = payable(msg.sender).call{value: amountOfEthToTransact}("");
        require(ethTransferred, "ETH transfer failed");

        emit SellTokens(msg.sender, address(this), amountToSell);
        return amountToSell;
    }

    // change owner of contract
    function changeOwner(address newOwner) public onlyOwner {
        owner = newOwner;
        emit ChangeOwner(owner,newOwner);
    }
}
