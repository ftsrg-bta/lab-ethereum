# Solidity/Ethereum Development Quick Guide

## Solidity and Ethereum basics

Solidity is a rapidly evolving language, but it has a well written and extensive [documentation](https://solidity.readthedocs.io/en/v0.5.0/).
The current guide is based on version 0.5.0, but the latest documentation is available at [solidity.readthedocs.io/en/latest](https://solidity.readthedocs.io/en/latest/).

### Layout of source files

An example Solidity smart contract (implementing a simple bank) can be seen below.
Source files start with a `pragma` statement describing the _compiler version_ to use.
A source file can then define multiple _contracts_.
The example below has a single contract named `SimpleBank`.

At a first glance, smart contracts are similar to simple classes in object-oriented programming. Contracts can define
- _state variables_ which define the data stored on the blockchain and
- _functions_ that can manipulate the data and interact with other accounts.


It is also possible to _import_ other contracts from other source files and Solidity also supports _inheritance_ between contracts.

```
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
```

### State variables

The SimpleBank example defines two state variables.
- `transactions` is an unsigned integer (`uint`), storing the number of transactions in the current bank instance.
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
The SimpleBank example specifies three functions.
- The `deposit` function is `public` (can be called by anyone) and `payable`, which means that it can receive Ether as part of the call.
Functions can access a special `msg` field, which stores information about the function call.
For example, the `deposit` function reads the amount of Ether associated with the call from the `msg.value` field and increases the balance of the caller, whose address is stored in `msg.sender`.
It can also be seen that the dictionary can be accessed using square brackets (`balances[msg.sender]`).
Finally, the function increments the `transactions` counter.
- The function `getBalance` is marked as `view`, which means that it does not modify the state of the contract, but it can still read it.
The `pure` keyword (instead of `view`) is even more restrictive: such functions cannot read or write the state.
The function also specifies a return value with `returns (...)`.
This function gets and returns the balance of the caller (`msg.sender`).
- The function `withdraw` specifies a single `uint` parameter called `amount`, corresponding to the amount that the caller wants to withdraw from the bank.
The function first checks whether the caller has enough Ether in the bank using a `require` statement.
The `require` statement checks the condition and reverts the whole transaction if the condition is false.
Otherwise it updates the mapping by decreasing the balance of the caller and then transfers the required amount using the `transfer` function.
Finally, the function increments the `transactions` counter.

Besides the basic statements illustrated by the SimpleBank example, functions can have other statements such as selection (`if then else`) or loops (`for`, `while`).
However, as execution costs a transaction fee per instruction (gas), it is recommended to avoid complex operations like loops if possible.
Furthermore, instructions writing the blockchain state are more expensive to execute, therefore it is also recommended to minimize the number of writes.

Functions can be marked as `public`, `internal`, `private` or `external`.
For more information, see the [visibility section of the documentation](https://solidity.readthedocs.io/en/v0.5.0/contracts.html#visibility-and-getters).

### Handling Ether

Each address (contract or external) is associated with a balance in Ether, the native cryptocurrency of Ethereum.
Solidity provides various language features to query balances and transfer Ether.
The `address` type has a field `balance` which can query the balance.
For example, to query the balance of the current contract inside a function we can use `address(this).balance`:
```
function getMyBalance() public returns (uint) {
    return address(this).balance;
}
```

There is another flavour of the `address` type called `address payable`, which is a special address that can receive Ether (similarly to `payable` functions).
For example, `msg.sender` in a function has the `address payable` type.
A payable address has two functions to transfer Ether: `transfer` and `send`.
The difference between the two is that in case of a failure, `transfer` throws an exception while `send` indicates it with a false return value.
In the SimpleBank example, we use `transfer` in the `withdraw` function because if it fails, the exception is propagated and the whole transaction is reverted (including the instruction that decreased the balance of the caller).
It is a common programming error to use `send` without checking its return value.

As already seen in the SimpleBank example, functions can be marked with the `payable` keyword, allowing the caller to attach Ether to the call.
The Ether attached is automatically added to the balance of the contract, but can also be queried from the `msg.value` field.
When a contract wants to call another contract and send Ether, it can set the amount with the `value` function.
For example, if we have a `SimpleBank sb` field in another contract, we can call `sb.deposit.value(amount)()` to deposit a given amount.

Each contract can have at most one function _without a name_, which is called the _fallback function_.
This function gets executed when a call to the contract matches no other function.
Furthermore it is also executed when `transfer` or `send` is used to transfer Ether to a contract.
However, this requires the fallback function to be marked as `payable`.
An example fallback function can be seen below.
```
function () public payable {
    // Do something
}
```

There is no distinct type for Ether, unsigned integers are used.
The default unit is Wei, but literals can be specified using suffixes such as `wei`, `finney`, `szabo` or `ether`.
For example, `uint amount = 1 ether;` will store `10^18` in the variable `amount`.

### Error handling

Transactions in Ethereum work in an atomic way: if there is an error, the whole transaction gets reverted.
Errors can happen due to some condition in the execution, such as running out of the execution fee or indexing an array out of bounds.
However, there are multiple ways for the programmer to raise an error.
- `require(...)` checks if a condition holds and if not, it reverts the transaction. It is recommended to be used for example to validate parameters at the beginning of the function.
- `assert(...)` is similar to `require` in its effect, but it is recommended to use for checking conditions that should not fail. Proper code should never reach an assertion failure. In contrast, it is normal for `require` to raise an error.
- `revert()` simply reverts the transaction.

When functions call other functions, the errors propagate up, making the whole chain of calls revert.
However, there are a few exceptions from this rule: `send`, `call`, `delegatecall` and `staticcall` only indicate the error in their return value.
These functions should be used with caution.

### Additional language elements

TODO

## Development and testing

TODO
