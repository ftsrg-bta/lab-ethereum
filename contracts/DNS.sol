pragma solidity ^0.5.0;

// A domain name service contract, where users can register IP addresses
// for domain names.
contract DNS {
    struct Record {
        string ip;
        address owner;
    }
    
    mapping(string=>Record) records;
    uint public price = 0.01 ether;
    address payable owner;
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    constructor() public {
        owner = msg.sender;
    }
    
    function setPrice(uint newPrice) public onlyOwner {
        price = newPrice;
    }
    
    function register(string memory domain, string memory ip) public payable {
        require(msg.value >= price);
        require(records[domain].owner == address(0x0) ||
                records[domain].owner == msg.sender);
        
        records[domain] = Record(ip, msg.sender);        
    }
    
    function lookup(string memory domain) public view returns (string memory) {
        return records[domain].ip;
    }
    
    function transfer(string memory domain, address newOwner) public {
        require(records[domain].owner == msg.sender);
        records[domain].owner = newOwner;
    }
    
    function withdraw() public onlyOwner {
        owner.transfer(address(this).balance);
    }
}