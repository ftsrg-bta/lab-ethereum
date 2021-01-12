// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;

// A simple counter, which can only be increased by its owner,
// but can be queried by anyone.
contract Counter {

    // State variables
    address owner;       // Owner
    uint public counter; // Value of the counter

    // Constructor
    constructor() {
        // Get the owner from the parameters of the transaction
        owner = msg.sender;
        // Initialize the counter
        // The default value is 0 if non-initialized, but
        // this makes the code more clear
        counter = 0;
    }

    // Increment the counter
    // Public function, can be called by anyone
    function increment() public {
        // Check that the caller is the owner, if not, revert
        require(msg.sender == owner);
        // Otherwise increment the counter
        counter++;
    }
}