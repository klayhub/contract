const kip17 = artifacts.require("KIP17Token");
const nftMinter = artifacts.require("nftMinter");
const Seller = artifacts.require("timeSeller1000");
module.exports = async function (deployer) {
  const seller = await Seller.deployed();
  const nft = await kip17.deployed();
  const minter = await nftMinter.deployed();
  // await nft.addMinter(minter.address);

  let m = 610;
  for (let n = 1; n <= 500; n++) {
    const _price = (1000).toString().padStart(7, "0");
    const _number = n.toString().padStart(5, "0");
    const _amount = m.toString().padStart(5, "0");
    const _version = 1;
    const tokenId = `${_version}${_price}${_number}${_amount}`;
    try {
      console.log(tokenId);
      nft.approve(seller.address, tokenId);
      await seller.register(tokenId);
    } catch (e) {
      console.log("Already Exists");
    }
  }
};
