const kip17 = artifacts.require("KIP17Token");
const nftMinter = artifacts.require("nftMinter");

module.exports = async function (deployer) {
  const nft = await kip17.deployed();
  await deployer.deploy(nftMinter, nft.address);
};
