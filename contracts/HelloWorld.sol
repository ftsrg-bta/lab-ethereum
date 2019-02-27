pragma solidity ^0.5.0;

contract Mortal {
    address payable owner;
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    constructor() public {
        owner = msg.sender;
    }
    
    function kill() public onlyOwner {
        selfdestruct(owner);
    }
}

contract Greeter is Mortal {
    string message;
    
    constructor(string memory _message) public {
        message = _message;
    }
    
    function greet() public view returns (string memory) {
        return message;
    }
}