const kip17 = artifacts.require("KIP17Token");
const Seller = artifacts.require("timeSellerForFailed");

const whitelist = require("../lib/sale-1.2-whitelist.json");
const NFT_List = require("../lib/sale-1.2-remained.json");

module.exports = async function (deployer) {
  const nft = await kip17.deployed();
  const seller = await Seller.deployed();

  for (let i = 0; i < whitelist.length; i++) {
    const addr = whitelist[i];
    seller.setCanBuy(addr, 6);
  }
};
