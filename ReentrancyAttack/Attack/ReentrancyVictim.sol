//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.8;

contract ReentrancyVictim {

    mapping (address => uint) public balances; 

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= _amount);
        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "Failed to send Ether");
        balances[msg.sender] -= _amount;
    }

    function getBalance(address _addr) public view returns (uint) {
        return balances[_addr];
    }
    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }
}