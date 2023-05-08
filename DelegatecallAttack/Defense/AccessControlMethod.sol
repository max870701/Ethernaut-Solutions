// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Delegate {

  address public DelegateOwner; // Slot 0

  constructor(address _owner) {
    DelegateOwner = _owner;
  }

  function pwn() public {
    DelegateOwner = msg.sender;
  }
}

contract Delegation {

  address public DelegationOwner;
  Delegate delegate;

  constructor(address _delegateAddress) {
    delegate = Delegate(_delegateAddress);
    DelegationOwner = msg.sender;
  }

  fallback() external {
    // Access Control
    require(msg.sender == DelegationOwner, "Only owner can call the fallback function");
    (bool success,) = address(delegate).delegatecall(msg.data);
    require(success, "delegatecall failed");
  }
}