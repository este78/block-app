var RugbyDAUMarket = artifacts.require("./RugbyDAUMarket.sol");
var RugbyDAUToken = artifacts.require("./RugbyDAUToken.sol");


module.exports = function(deployer) {
  deployer.deploy(RugbyDAUMarket).then(function() {
    return deployer.deploy(RugbyDAUToken, RugbyDAUMarket.address)
  });
};
