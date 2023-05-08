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

  address public DelegationOwner; // Slot 0
  Delegate delegate;              // Slot 1

  constructor(address _delegateAddress) {
    delegate = Delegate(_delegateAddress);
    DelegationOwner = msg.sender;
  }

  fallback() external {
    (bool result,) = address(delegate).delegatecall(msg.data);
    if (result) {
      this;
    }
  }
}