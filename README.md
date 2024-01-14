## Token Sale Contract
    
   This is a simple token sale contract written in Solidity. It allows users to buy tokens with Ether and sell their tokens back for Ether.

# Setup
   To use this contract, you will need to deploy it to the Ethereum blockchain. You will also need to set the tokensPerEth variable to the desired rate of exchange between tokens and Ether.

# Buy Tokens
   To buy tokens, users can call the buy function and send Ether to the contract. The contract will then transfer the tokens to the user's account.

# Sell Tokens
   To sell tokens, users can call the sellTokens function and specify the number of tokens they want to sell. The contract will then transfer the Ether to the user's account and burn the tokens.

# Events
   The contract emits the following events:

- SellTokens: Emitted when a user sells tokens. The event has three parameters: the seller's address, the contract's address, and the number of tokens sold.
Testing
This contract has been tested using `forge test`

