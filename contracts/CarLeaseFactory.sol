// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./CarLease.sol";

contract CarLeaseFactory {
address[] public carLeases;

function createCarLease(string memory _make, string memory _model, uint _price, uint _deposit, uint _startTime, uint _endTime, uint _cancellationFee, uint _lateFee) public {
CarLease newCarLease = new CarLease(_make, _model, _price, _deposit, _startTime, _endTime, _cancellationFee, _lateFee);
carLeases.push(address(newCarLease));
}

function getCarLeases() public view returns (address[] memory) {
return carLeases;
}
}