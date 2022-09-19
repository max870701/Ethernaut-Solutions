// SPDX-License-Identifier: unlicensing
pragma solidity ^0.6.0;

contract TransferOwnership {

    address public owner;
    event TransferStatus(bool result, bytes data);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function trigger(address target) public payable onlyOwner {
        (bool success, bytes memory returnData) = target.call{gas:100000, value: 0 ether}(abi.encodeWithSignature("changeOwner(address)", owner));
        emit TransferStatus(success, returnData);
    }
    receive() external payable {}
}
