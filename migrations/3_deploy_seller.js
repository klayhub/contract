const kip17 = artifacts.require("KIP17Token");
const seller = artifacts.require("timeSeller");

module.exports = async function (deployer) {
  console.log(kip17.address);
  await deployer.deploy(seller, kip17.address);
};
