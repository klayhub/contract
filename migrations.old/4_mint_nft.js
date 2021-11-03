const kip17 = artifacts.require("KIP17Token");
const kip7 = artifacts.require("KIP7Token");
const Seller = artifacts.require("timeSeller");

const price = 100;
const mintAmount = [1, 9, 100, 500];
const version = 0;
const metadataURI =
  "https://link.ap1.storjshare.io/jvx24pqgycg2w7xbm6bdvbncblra/time%2Fmetadata%2Fmetadata.json";
const minter = "0x94503955d5aa7a97ccca15f1b0d985696ea8afe1";

module.exports = async function (deployer) {
  const nft = await kip17.deployed();
  const seller = await Seller.deployed();

  for (i = 0; i < mintAmount.length; i++) {
    for (var numberOf = 1; numberOf <= mintAmount[i]; numberOf++) {
      const _number = numberOf.toString().padStart(5, "0");
      const _amount = mintAmount[i].toString().padStart(5, "0");
      const _version = version.toString().padStart(5, "0");
      const tokenId = `${price}${_number}${_amount}${_version}`;
      console.log("TokenID", tokenId);
      try {
        await nft.mintWithTokenURI(minter, tokenId, metadataURI);
        nft.approve(seller.address, tokenId);
        seller.register(tokenId);
      } catch (e) {
        console.log("Token Already Exists", tokenId);
      }
    }
  }
};
