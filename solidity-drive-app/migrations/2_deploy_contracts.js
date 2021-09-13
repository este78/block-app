var RugbyDAUToken = artifacts.require("./RugbyDAUToken.sol");

module.exports = function(deployer) {
  deployer.deploy(RugbyDAUToken);
};