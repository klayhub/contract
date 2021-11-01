const seller = artifacts.require("timeSeller");
const kip17 = artifacts.require("KIP17Token");

module.exports = async function (deployer) {
  nft = await kip17.deployed();
  deployer.deploy(seller, nft.address);
};
