pragma solidity ^0.5.0;

contract SimpleBank {
    uint public transactions;
    mapping(address=>uint) balances;
    
    function deposit() public payable {
        balances[msg.sender] += msg.value;
        transactions++;
    }
    
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }
    
    function withdraw(uint amount) public {
        require(balances[msg.sender] >= amount);
        balances[msg.sender] -= amount;
        msg.sender.transfer(amount);
        transactions++;
    }
}