const CarLease = artifacts.require("CarLease");

contract("CarLease", (accounts) => {
  const [owner, renter] = accounts;
  const make = "Volkswagon";
  const model = "Model A";
  const price = 100;
  const deposit = 50;
  const startTime = Math.floor(Date.now() / 1000) + 100; // start time is 100 seconds from now
  const endTime = startTime + 3600; // end time is 1 hour after start time
  const cancellationFee = 10;
  const lateFee = 5;

  let carLease;

  beforeEach(async () => {
    carLease = await CarLease.new(make, model, price, deposit, startTime, endTime, cancellationFee, lateFee, { from: owner });
  });

  it("should be able to rent a car", async () => {
    const tx = await carLease.bookCar({ from: renter, value: deposit });
    assert.equal(tx.logs[0].event, "RentalBooked");
    assert.equal(tx.logs[0].args.renter, renter);
  });

  it("should not be able to rent a car if already rented", async () => {
    await carLease.bookCar({ from: renter, value: deposit });
    try {
      await carLease.bookCar({ from: accounts[2], value: deposit });
    } catch (err) {
      assert(err.message.includes("Car is already rented."));
    }
  });

  it("should not be able to rent a car if the start time has already passed", async () => {
    const startTime = Math.floor(Date.now() / 1000) - 100; // start time is 100 seconds ago
    const endTime = startTime + 3600; // end time is 1 hour after start time
    const carLease = await CarLease.new(make, model, price, deposit, startTime, endTime, cancellationFee, lateFee, { from: owner });
    try {
      await carLease.bookCar({ from: renter, value: deposit });
    } catch (err) {
      assert(err.message.includes("Booking cannot be made as the start time has already passed."));
    }
  });

  it("should be able to cancel a lease before the start time", async () => {
    await carLease.bookCar({ from: renter, value: deposit });
    const tx = await carLease.cancelLease({ from: renter });
    assert.equal(tx.logs[0].event, "LeaseCancelled");
    assert.equal(tx.logs[0].args.renter, renter);
  });

  it("should not be able to cancel a lease after the start time", async () => {
    await carLease.bookCar({ from: renter, value: deposit });
    const startTime = Math.floor(Date.now() / 1000) - 100; // start time is 100 seconds ago
    const endTime = startTime + 3600; // end time is 1 hour after start time
    const carLease = await CarLease.new(make, model, price, deposit, startTime, endTime, cancellationFee, lateFee, { from: owner });
    try {
      await carLease.cancelLease({ from: renter });
    } catch (err) {
      assert(err.message.includes("Cancellation is not allowed after the start time."));
    }
  });

  it("should be able to charge a late fee for a lease thathas gone past the end time", async () => {
    await carLease.bookCar({ from: renter, value: deposit });
    const endTime = Math.floor(Date.now() / 1000) - 100; // end time is 100 seconds ago
    const tx = await carLease.chargeLateFee({ from: owner });
    assert.equal(tx.logs[0].event, "LateFeeCharged");
    assert.equal(tx.logs[0].args.renter, renter);
    assert.equal(tx.logs[0].args.amount, lateFee);
    });
    
    it("should not be able to charge a late fee for a lease that has not yet ended", async () => {
    await carLease.bookCar({ from: renter, value: deposit });
    try {
    await carLease.chargeLateFee({ from: owner });
    } catch (err) {
    assert(err.message.includes("Late fee cannot be charged yet."));
    }
    });
    
    it("should be able to withdraw funds from the contract", async () => {
    const amount = 50;
    await carLease.withdraw(amount, { from: owner });
    const balance = await web3.eth.getBalance(carLease.address);
    assert.equal(balance, deposit - amount);
    });
    });
