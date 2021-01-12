// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;

// A domain name service contract, where users can register IP addresses
// for domain names for a given price, that is adjustable by the owner.
// The owner is also able to withdraw the accummulated Ether from the contract.
contract DNS {

    // Helper structure for storing an IP and its owner
    struct Record {
        string ip;
        address owner;
    }

    // State variables
    mapping(string=>Record) records; // Associate domain names with their IP and owner
    uint public price = 0.01 ether;  // Current price of registration
    address payable owner;           // Owner of the service

    // Modifier that can be attached to functions and will make the function
    // revert in the beginning if the caller is not the owner
    modifier onlyOwner {
        require(msg.sender == owner); // Do the check
        _; // If check succeeds do the rest of the function
    }

    // Constructor
    constructor() {
        owner = payable(msg.sender); // Deployer (caller) is the owner
    }

    // Set the price, only owner can call
    function setPrice(uint newPrice) public onlyOwner {
        price = newPrice;
    }

    // Register a given domain for a given IP
    function register(string memory domain, string memory ip) public payable {
        // Check if enough Ether was associated with the call
        require(msg.value >= price);
        // Check if this domain has not been registered yet (the owner is
        // the default zero address) or if it is already registered, but
        // the owner is the current caller.
        require(records[domain].owner == address(0x0) ||
                records[domain].owner == msg.sender);
        // If check succeeds, do the registration
        records[domain] = Record(ip, msg.sender);
    }

    // Look up the IP for a domain, does not modify state, can be 'view'
    function lookup(string memory domain) public view returns (string memory) {
        return records[domain].ip;
    }

    // Transfer the ownership of a domain to a new owner
    function transfer(string memory domain, address newOwner) public {
        // Check if the domain is owned by the current caller
        require(records[domain].owner == msg.sender);
        // If yes, transfer ownership
        records[domain].owner = newOwner;
    }

    // Withdraw the collected Ether from the contract, only owner can call
    function withdraw() public onlyOwner {
        // Transfer all the balance to the owner
        owner.transfer(address(this).balance);
    }
}