pragma solidity ^0.5.0;

// A simple counter, which can only be increased by its owner.
contract Counter {

    address owner;
    uint public counter;

    constructor() public {
        owner = msg.sender;
        counter = 0;
    }

    function increment() public {
        require(msg.sender == owner);
        counter++;
    }

}