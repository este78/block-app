var BookList = artifacts.require("./BookList.sol");

module.exports = function(deployer) {
  deployer.deploy(BookList);
};
