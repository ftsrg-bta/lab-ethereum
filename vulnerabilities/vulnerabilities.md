---
title: Solidity/Ethereum vulnerabilities
author: Ákos Hajdu
---

This is a supplementary material for the [Blockchain Technologies and Applications (VIMIAV17)](http://inf.mit.bme.hu/edu/courses/blockchain/) course at the [
Budapest University of Technology and Economics](http://www.bme.hu/?language=en).

## Introduction

There is a wide variety of vulnerabilities in blockchain-based infrastructures.
The source of vulnerabilities is often the misalignment or the gap between the programmers intent and the actual execution semantics.
Vulnerabilities can be categorized by the layer in which they appear.

## Programming language / contracts

- **Call to the unknown**: Some primitives in Solidity (to call functions and to transfer funds) invoke other functions as a side effect. The invoked function might belong to a malicious contract.
- **Gasless send**: Sending funds might cause an exception due to insufficient execution fees if the called function performs computations as a side effect. For example, `transfer` and `send` executes the fallback function with a limited amount of gas by default.
- **Mishandled exceptions**: There are several different ways of throwing exceptions in Solidity and handling them is not uniform. Therefore, the programmer might miss certain kinds of exceptions. For example, `transfer` propagates the exception up to the caller, but `send` indicates it in its return value.
- **Type casts**: While the compiler checks certain type errors, once deployed we cannot be sure about a type of a contract behind some address. If it is type does not match but has a function with the same signature, it will still be called.
- **Reentrancy**: Programmers might have the intention of atomicity in transactions, but certain primitives in Solidity pass the control over to the callee, allowing them to recursively call into a contract.
- **Keeping secrets**: To set a private field, a user has to send a transaction to call a setter function. The transaction and the function codes are public, so the value of the private field can be inferred.
- **Unchecked caller**: Anyone / any other contract can call public functions. Programmers tend to forget to check that some operations should only be called by the owner (e.g., killing the contract).
- **Input validation**: Anyone / any other contract can call public functions with possibly malicious input (e.g., misformatted addresses).

## Execution engine

- **Under/overflows**: The Ethereum Virtual Machine (EVM) can operate with 8, 16, 24, 32, ..., 256 bit signed or unsigned integers, which silently under/overflow. For example, `255 + 1 == 0` on 8 unsigned bits.
- **Immutable bugs**: The code of a contract cannot be modified or patched after publication, even if a bug is discovered. Even if a vulnerability is discovered, the contract is there available to exploit. _Note, that there are some patterns to kill a contract or to forward calls to a mutable address, but that again brings new vulnerabilities (an attacker might kill or hijack the contract). Such patterns should be implemented with great care._
- **Ether lost in transfer**: Sending Ether to an orphan address is lost forever.
- **Stack size limit**: Until a hard fork, it was possible to set up a long chain of calls and then finally call a victim contract making it fail with an exception due to the stack size limit. The victim contract might not have been expecting an exception.

## Blockchain and cross-peer protocols

- **Unpredictable state/transaction ordering dependency**: The state of a contract is determined by its data and its balance. Between issuing a transaction and its actual execution, other transactions might change the state of the contract. The order in which transactions are collected into block depends on the miners.
- **Generating randomness**: The blockchain is inherently deterministic. Timestamps and block hashes might be used as seeds for pseudo-random generators. However, miners can influence these parameters and could bias the outcome.
- **Time constraints/timestamp dependency**: Some applications use the block timestamp to determine which actions are permitted (e.g., if the owner does not claim the funds, some other user might claim it after a given time). Miners can control the timestamps to a small extent.

## References

- Atzei, Bartoletti, Cimoli - A survey of attacks on Ethereum smart contracts (2017)
- Luu, Chu, Olickel, Saxena, Hobor - Making Smart Contracts Smarter (2016)
- Nikolic, Kolluri, Sergey, Saxena, Hobor - Finding The Greedy, Prodigal, and Suicidal Contracts at Scale (2018)
- [National Vulnerability Database](https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=blockchain+OR+ethereum&search_type=all)
