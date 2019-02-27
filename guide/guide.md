# Solidity/Ethereum Development Quick Guide

## Solidity and Ethereum basics

Solidity is a rapidly evolving language, but it has a well written and extensive [documentation](https://solidity.readthedocs.io/en/v0.5.0/).
The current guide is based on version 0.5.0, but the latest documentation is available at [solidity.readthedocs.io/en/latest](https://solidity.readthedocs.io/en/latest/).

### Layout of source files

An example Solidity smart contract (implementing a wallet) can be seen below.
Source files start with a `pragma` statement describing the _compiler version_ to use.
A source file can then define multiple _contracts_.
The example below has a single contract named `Wallet`.

At a first glance, smart contracts are similar to simple classes in object-oriented programming. Contracts can define
- _state variables_ which define the data stored on the blockchain and
- _functions_ that can manipulate the data and interact with other accounts.


It is also possible to _import_ other contracts from other source files and Solidity also supports _inheritance_ between contracts.

```
pragma solidity ^0.5.0;

contract Wallet {
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
```

### State variables

The example above defines two state variables.
- `transactions` is an unsigned integer (`uint`), storing the number of transactions in the current wallet.
- `balances` is a _mapping_ from addresses to integers, storing the balance of each user. Mappings work similarly to maps in Java/C++ or dictionaries in C#/Python.

#### Types

Solidity is a strongly-typed language, i.e., the type of each variable must be explicitly specified.
Solidity includes various _primitive types_, including:
- Booleans (true/false).
- Signed and unsigned integers of various bit-lengths: `int8`, `int16`, `int24`, ..., `int256` are signed and `uint8`, `uint16`, `uint24`, ..., `uint256` are unsigned integers with 8, 16, 24, ..., 256 bit-lengths. The default `int` and `uint` types correspond to `int256` and `uint256` respectively.
- Addresses (`address`) are 160-bit integers corresponding to Ethereum addresses.

Solidity also provides _reference types_, including:
- Arrays (with fixed or dynamic size).
- Structures (`struct`).
- Mappings (`mapping(...=>...)`).

These work in a similar way as in other programming languages.

For more information on types, see [types section of the documentation](https://solidity.readthedocs.io/en/v0.5.0/types.html).

#### Visibilities

State variables can be `private`, `internal` or `public`, which are similar to other programming languages.
However, there are a few remarkable differences.
- For public variables only a getter function is generated automatically. They cannot be directly written by other contracts or transactions.
- Although private (and internal) variables cannot be accessed and modified by other contracts, transactions on the blockchain are public, so the information stored in such variables is still visible to anyone. Never store passwords or other secret information on the blockchain.

### Functions

Functions in Solidity can read and manipulate the state variables and interact with other contracts and accounts.
Functions can have parameters (e.g., `withdraw` in the example has one parameter) and can return values (e.g., `getBalance` returns one).
The example above specifies three functions.
- The `deposit` function is `public` (can be called by anyone) and `payable`, which means that it can receive Ether as part of the call.
Functions can access a special `msg` field, which stores information about the function call.
For example, the `deposit` function reads the amount of Ether associated with the call from the `msg.value` field and increases the balance of the caller, whose address is stored in `msg.sender`.
It can also be seen that the dictionary can be accessed using square brackets (`balances[msg.sender]`).
Finally, the function increments the `transactions` counter.
- The function `getBalance` is marked as `view`, which means that it does not modify the state of the contract, but it can still read it.
The `pure` keyword (instead of `view`) is even more restrictive: such functions cannot read or write the state.
The function also specifies a return value with `returns (...)`.
This function gets and returns the balance of the caller (`msg.sender`).
- The function `withdraw` specifies a single `uint` parameter called `amount`, corresponding to the amount that the caller wants to withdraw from the wallet.
The function first checks whether the caller has enough Ether in the wallet using a `require` statement.
The `require` statement checks the condition and reverts the whole transaction if the condition is false.
Otherwise it updates the mapping by decreasing the balance of the caller and then transfers the required amount using the `transfer` function.
Finally, the function increments the `transactions` counter.

Besides the basic statements illustrated by the example, functions can have other statements such as selection (`if then else`) or loops (`for`, `while`).
However, as execution costs a transaction fee per instruction (gas), it is recommended to avoid complex operations like loops if possible.
Furthermore, instructions writing the blockchain state are more expensive to execute, therefore it is also recommended to minimize the number of writes.

Functions can be marked as `public`, `internal`, `private` or `external`.
For more information, see the [visibility section of the documentation](https://solidity.readthedocs.io/en/v0.5.0/contracts.html#visibility-and-getters).

### Handling Ether

Each address (contract or external) is associated with a balance in Ether, the native cryptocurrency of Ethereum.
Solidity provides various language features to query balances and transfer Ether.
The `address` type has a field `balance` which can query the balance.
For example, to query the balance of the current contract in a function we can use `address(this).balance`.

There is another flavour of the `address` type called `address payable`, which is a special address that can receive Ether (similarly to `payable` functions).
A `payable address` has two functions to transfer Ether: `transfer` and `send`.
The difference between the two is that in case of a falilure, `transfer` throws an exception while `send` indicates it with a false return value.
In the example above, it is safe to use `transfer` in the `withdraw` function because if it fails, the exception is propagated and the whole transaction is reverted.
However, if we used `send` we should also make sure to check its return value and only decrease the balance of the user if sending was successful.

TODO: payable Functions, msg.value, fallback


### Error handling

TODO

### Additional language elements

TODO

## Development and testing

TODO
