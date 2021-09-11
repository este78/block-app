var RugbyDAUMarketplace = artifacts.require("./RugbyDAUMarketplace.sol");

module.exports = function(deployer) {
  deployer.deploy(RugbyDAUMarketplace);
};