pragma solidity ^0.5.0;

// A domain name service contract, where users can register IP addresses
// for domain names.
contract DNS {
    struct Record {
        string ip;
        address owner;
    }
    
    mapping(string=>Record) records;
    uint constant price = 0.01 ether;
    address payable owner;
    
    constructor() public {
        owner = msg.sender;
    }
    
    function register(string memory domain, string memory ip) public payable {
        require(records[domain].owner == address(0x0) ||
                records[domain].owner == msg.sender);
        require(msg.value >= price);
        
        records[domain] = Record(ip, msg.sender);
    }
    
    function lookup(string memory domain) public view returns (string memory) {
        return records[domain].ip;
    }
    
    function transfer(string memory domain, address newowner) public {
        require(records[domain].owner == msg.sender);
        records[domain].owner = newowner;
    }
    
    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(address(this).balance);
    }
}