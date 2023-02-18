// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CarLease {
  address payable public owner;
  address public renter;
  string public make;
  string public model;
  uint public price;
  uint public deposit;
  uint public startTime;
  uint public endTime;
  uint public cancellationFee;
  uint public lateFee;
  bool public isBooked;
  bool public isCancelled;
  bool public isLate;

  event RentalBooked(address indexed renter, uint indexed deposit);
  event LeaseCancelled(address indexed renter, uint indexed refund);
  event LateFeeCharged(address indexed owner, address indexed renter, uint indexed amount);
  event FundsWithdrawn(address indexed owner, uint indexed amount);

  modifier onlyOwner() {
    require(msg.sender == owner, "Only the owner can perform this action.");
    _;
  }

  modifier onlyRenter() {
    require(msg.sender == renter, "Only the renter can perform this action.");
    _;
  }

  modifier canBook() {
    require(!isBooked, "Car is already rented.");
    require(startTime > block.timestamp, "Booking cannot be made as the start time has already passed.");
    _;
  }

  modifier canCancel() {
    require(isBooked && !isCancelled, "The lease cannot be cancelled.");
    require(startTime > block.timestamp, "Cancellation is not allowed after the start time.");
    _;
  }

  modifier canChargeLateFee() {
    require(isBooked && !isCancelled && block.timestamp > endTime, "Late fee cannot be charged yet.");
    require(!isLate, "Late fee has already been charged.");
    _;
  }

  constructor(string memory _make, string memory _model, uint _price, uint _deposit, uint _startTime, uint _endTime, uint _cancellationFee, uint _lateFee) {
    require(_startTime < _endTime, "End time must be after start time.");

    owner = payable(msg.sender);
    make = _make;
    model = _model;
    price = _price;
    deposit = _deposit;
    startTime = _startTime;
    endTime = _endTime;
    cancellationFee = _cancellationFee;
    lateFee = _lateFee;
    isBooked = false;
    isCancelled = false;
    isLate = false;
  }

  function bookCar() external payable canBook {
    require(msg.value == deposit, "Deposit amount is incorrect.");

    renter = msg.sender;
    isBooked = true;

    emit RentalBooked(renter, deposit);
  }

  function cancelLease() external onlyRenter canCancel {
    uint refund = deposit - cancellationFee;
    isCancelled = true;

    if (refund > 0) {
      payable(renter).transfer(refund);
    }

    emit LeaseCancelled(renter, refund);
  }

  function chargeLateFee() external onlyOwner canChargeLateFee {
    uint amount = lateFee;
    isLate = true;

    payable(owner).transfer(amount);

    emit LateFeeCharged(owner, renter, amount);
  }

  function withdraw(uint amount) external onlyOwner {
    require(amount <= address(this).balance, "Insufficient balance.");

    payable(owner).transfer(amount);

    emit FundsWithdrawn(owner, amount);
  }
}
