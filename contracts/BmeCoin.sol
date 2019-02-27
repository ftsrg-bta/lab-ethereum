pragma solidity ^0.5.0;

contract BmeCoin {
    mapping(address=>uint) balances;
    
    constructor(uint totalSupply) public {
        balances[msg.sender] = totalSupply;
    }
    
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }
    
    function transfer(address to, uint amount) public {
        require(balances[msg.sender] >= amount);
        require(balances[to] + amount >= balances[to]);
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
}