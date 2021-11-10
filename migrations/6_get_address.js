const kip17 = artifacts.require("KIP17Token");
const kip7 = artifacts.require("KIP7Token");
const Seller = [
  artifacts.require("timeSeller100"),
  artifacts.require("timeSeller1000"),
  artifacts.require("timeSeller5000"),
  artifacts.require("timeSeller10000"),
];

module.exports = async function (deployer) {
  const HUB = await kip7.deployed();
  const nft = await kip17.deployed();
  const seller = await Promise.all(
    Seller.map(async (s) => {
      return s.deployed();
    })
  );
  console.log("HUB", HUB.address);
  console.log("nft", nft.address);
  for (i = 0; i < seller.length; i++) {
    console.log("seller" + [i], seller[i].address);
  }
};
