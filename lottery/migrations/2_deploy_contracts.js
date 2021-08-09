var Lottery = artifacts.require("./Lottery.sol");

module.exports = function(deployer) {
  deployer.deploy(Lottery, {value:500000000000000000, from:"0xAe7a8375B42C4407aE7f3C37a20251350fFd3f1d"});
};