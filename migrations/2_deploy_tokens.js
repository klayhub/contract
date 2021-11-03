const _time = artifacts.require("KIP17Token");
const _hub = artifacts.require("KIP7Token");

module.exports = async function (deployer) {
  await deployer.deploy(
    _hub,
    "Klayhub",
    "HUB",
    "18",
    "1500000000000000000000000000"
  );
  await deployer.deploy(_time, "TIME NFT", "TIME");
};
