pragma solidity ^0.5.0;

contract Wallet {
    mapping(address=>uint) balances;
    
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }
    
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }
    
    function withdraw(uint amount) public {
        require(balances[msg.sender] >= amount);
        balances[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}