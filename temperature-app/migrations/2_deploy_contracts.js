var TemperatureManage = artifacts.require("TemperatureManage");

module.exports = function(deployer) {
  deployer.deploy(TemperatureManage);
};