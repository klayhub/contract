// const kip17 = artifacts.require("KIP17Token");
// const kip7 = artifacts.require("KIP7Token");
// const Seller = [
//   artifacts.require("timeSeller100"),
//   artifacts.require("timeSeller1000"),
//   artifacts.require("timeSeller5000"),
//   artifacts.require("timeSeller10000"),
// ];

// const mintAmount = [
//   [1, 2],
//   [1, 3],
//   [1, 4],
//   [1, 5],
// ];
// const mintPrice = [100, 1000, 5000, 10000];
// const metadataURI = "https://nft.klayhub.com/metadata/";
// const version = 1;

// const minter = "0x94503955d5aa7a97ccca15f1b0d985696ea8afe1";

// module.exports = async function (deployer) {
//   const HUB = await kip7.deployed();
//   const nft = await kip17.deployed();
//   const seller = [
//     await Seller[0].deployed(),
//     await Seller[1].deployed(),
//     await Seller[2].deployed(),
//     await Seller[3].deployed(),
//   ];

//   console.log("HUB", HUB.address);
//   console.log("nft", nft.address);
//   for (i = 0; i < seller.length; i++) {
//     console.log("seller" + [i], seller[i].address);
//   }
// };
