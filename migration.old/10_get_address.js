const kip17 = artifacts.require("KIP17Token");
const kip7 = artifacts.require("KIP7Token");
const Seller = [
  artifacts.require("timeSeller100"),
  artifacts.require("timeSeller1000"),
  artifacts.require("timeSeller5000"),
  artifacts.require("timeSeller10000"),
];

const Time1000Amount = [1, 9, 30, 50, 100, 200, 610];

function getTokenId(price, n, m) {
  const _price = price.toString().padStart(7, "0");
  const _number = n.toString().padStart(5, "0");
  const _amount = m.toString().padStart(5, "0");
  const _version = 1;
  const tokenId = `${_version}${_price}${_number}${_amount}`;
  return tokenId;
}

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
  for (let i = 0; i < seller.length; i++) {
    console.log("seller" + [i], seller[i].address);
  }
  let tokenIds = [];
  Time1000Amount.forEach(async (amount) => {
    for (let j = 1; j <= amount; j++) {
      const tokenId = getTokenId(1000, j, amount);
      // const owner = await nft.ownerOf(tokenId);
      tokenIds.push(tokenId);
    }
  });
  const owners = require("../lib/1000owner.json");
  owners.forEach((owner, i) => {
    if (owner == "0x2cCD2dFc4E6dD26945cFA8048B3B03a2ED81628d")
      console.log(tokenIds[i]);
  });
};
