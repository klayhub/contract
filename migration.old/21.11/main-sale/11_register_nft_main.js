const kip17 = artifacts.require("KIP17Token");
const Seller = [
  artifacts.require("timeSeller100"),
  artifacts.require("timeSeller1000"),
  artifacts.require("timeSeller5000"),
  artifacts.require("timeSeller10000"),
];

const tokenIDs = require("../lib/sale-main-remained.json");

module.exports = async function (deployer) {
  const nft = await kip17.deployed();
  const seller = await Seller[1].deployed();
  let count = 0;

  for (let i = 0; i < tokenIDs.length; i++) {
    const newId = tokenIDs[i];
    console.log("\nToken Id : ", newId, count);
    const approved = (await nft.getApproved(newId)).toString();
    const registered = (await seller.tokenIdById(count)).toString();
    console.log("Approved ", approved);
    if (approved != seller.address) {
      console.log(`Approving...`);
      nft.approve(seller.address, newId);
    } else console.log("Already Approved");
    if (registered != newId) {
      try {
        console.log("Registering..", newId, count);
        seller.registerById(newId, count);
      } catch (e) {
        console.log("ERORR!!!! ", approved, newId, count);
        console.log("Error", e);
      }
    } else console.log("Already Registered");
    count++;
  }
};
