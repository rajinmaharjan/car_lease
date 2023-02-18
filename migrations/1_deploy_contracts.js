const CarLease = artifacts.require("CarLease");

module.exports = function (deployer) {
deployer.deploy(CarLease,"Tesla", "Model S", 1000, 500, Math.floor(Date.now() / 1000) + 3600, Math.floor(Date.now() / 1000) + 86400 * 7, 50, 10);
};
