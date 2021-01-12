// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;

// Hello world example, storing a message that can be queried.
contract Greeter {

    // State variables
    string message; // Message

    // Constructor: get a message and store it
    constructor(string memory _message) {
        message = _message;
    }

    // Query the message
    // Does not modify state, can be 'view'
    function greet() public view returns (string memory) {
        return message;
    }
}