const kip17 = artifacts.require("KIP17Token");
const Seller = [
  artifacts.require("timeSeller100"),
  artifacts.require("timeSeller1000"),
  artifacts.require("timeSeller5000"),
  artifacts.require("timeSeller10000"),
];
const Price = [100, 1000, 5000, 10000];
const StartWhen = 0; //timestamp

module.exports = async function (deployer) {
  console.log(kip17.address);
  for (let i = 0; i < Seller.length; i++)
    await deployer.deploy(Seller[i], kip17.address, Price[i], StartWhen);
};
