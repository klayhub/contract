const kip17 = artifacts.require("KIP17Token");
const kip7 = artifacts.require("KIP7Token");

module.exports = async function (deployer) {
  await deployer.deploy(
    kip7,
    "Klayhub governence token",
    "HUB",
    "18",
    "150000000000000000000000000"
  );
  await deployer.deploy(kip17, "Time is money", "TIME");
};
