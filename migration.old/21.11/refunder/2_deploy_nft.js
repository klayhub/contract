const _time = artifacts.require("KIP17Token");

module.exports = async function (deployer) {
  await deployer.deploy(_time, "TIME NFT", "TIME");
};
