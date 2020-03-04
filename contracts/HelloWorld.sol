pragma solidity ^0.5.0;

// Hello world example, storing a message that can be queried.
contract Greeter {

    // State variables
    string message; // Message

    // Constructor: get a message and store it
    constructor(string memory _message) public {
        message = _message;
    }

    // Query the message
    // Does not modify state, can be 'view'
    function greet() public view returns (string memory) {
        return message;
    }
}