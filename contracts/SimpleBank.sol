// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;

// A simple bank, where users can deposit and withdraw money (Ether)
// to/from their balance. The number of transactions is also counted.
contract SimpleBank {

    // State variables
    uint public transactions;        // Number of transactions
    mapping(address=>uint) balances; // Balance of each individual user (address)

    // No constructor: state variables are initialized to default value

    // Deposit Ether, no arguments needed, the amount of Ether
    // is the parameter of the transaction itself (payable function)
    function deposit() public payable {
        // Query the caller (msg.sender) and the amount they sent (msg.value)
        // and keep track of it in the mapping
        balances[msg.sender] += msg.value;
        // Increment the number of transactions
        transactions++;
    }

    // Get the balance of the caller, does not modify state so can be 'view'
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }

    // Withdraw a given amount of Ether
    function withdraw(uint amount) public {
        // Check that the caller indeed has the required amount
        require(balances[msg.sender] >= amount);
        // Reduce their balance in the mapping
        balances[msg.sender] -= amount;
        // Do the actual transfer between the contract and the caller
        // If transfer fails for some reason, the error is propagated
        // and withdraw also fails
        payable(msg.sender).transfer(amount);
        // Increment the number of transactions
        transactions++;
    }
}