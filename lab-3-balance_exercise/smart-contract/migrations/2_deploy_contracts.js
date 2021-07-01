var IfElse = artifacts.require("IfElse");
var Factorial = artifacts.require("Factorial");
var StorageDemo = artifacts.require("StorageDemo");

module.exports = function(deployer) {
  deployer.deploy(IfElse,Factorial,StorageDemo);
};

