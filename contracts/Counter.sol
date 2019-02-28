pragma solidity ^0.5.0;

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