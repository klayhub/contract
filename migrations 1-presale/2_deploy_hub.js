const _hub = artifacts.require("KIP7Token");

module.exports = async function (deployer) {
  deployer.deploy(_hub, "Klayhub", "HUB", "18", "1500000000000000000000000000");
};
