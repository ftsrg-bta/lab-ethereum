pragma solidity ^0.5.0;

// Hello world example, storing a message that can be queried.
contract Greeter {
    string message;
    
    constructor(string memory _message) public {
        message = _message;
    }
    
    function greet() public view returns (string memory) {
        return message;
    }
}