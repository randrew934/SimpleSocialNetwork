const Migrations = artifacts.require("./SimpleSocialNetwork.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};
