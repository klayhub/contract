const kip17 = artifacts.require("KIP17Token");

module.exports = async function (deployer) {
  const nft = await kip17.deployed();

  const tokenIds = require("../lib/sale-1.2-remained.json");
  tokenIds.forEach(async (tokenId, i) => {
    owner = await nft.ownerOf(tokenId);
    if (owner == "0x2cCD2dFc4E6dD26945cFA8048B3B03a2ED81628d")
      console.log(tokenId);
  });
};
