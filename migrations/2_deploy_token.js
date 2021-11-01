const kip17 = artifacts.require("KIP17Token");

module.exports = async function (deployer) {
  deployer.deploy(kip17, "Time is money", "TIME");
};
