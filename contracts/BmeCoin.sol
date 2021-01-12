// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;

// A custom coin, where the owner gets the initial supply.
// Then, users can transfer their tokens.
contract BmeCoin {

    // State variables
    mapping(address=>uint) balances; // Balance of each user (address)

    // Constructor with an initial supply
    constructor(uint totalSupply) {
        // The caller (who deploys the contract) gets all coins
        balances[msg.sender] = totalSupply;
    }

    // Get the balance of the caller, does not modify state so can be 'view'
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }

    // Make a transfer from the caller to a given address with a given amount
    function transfer(address to, uint amount) public {
        // Check that the caller has enough tokens
        require(balances[msg.sender] >= amount);
        // Guard against overflow (only needed below 0.8.0): the receiver should not overflow
        // require(balances[to] + amount >= balances[to]);
        // Make the transfer by reducing caller and increasing receiver
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
}