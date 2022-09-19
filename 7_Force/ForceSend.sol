// SPDX-License-Identifier: unlicensing
pragma solidity ^0.6.0;

contract ForceSend {
    address payable target_no_receiver;
    address payable owner;

    constructor(address _target) public {
        target_no_receiver = payable(_target);
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function withdraw() payable public onlyOwner {
        owner.transfer(address(this).balance);
    }

    function force_send() public onlyOwner {
        selfdestruct(target_no_receiver);
    }

    receive() external payable {}
}
