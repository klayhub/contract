const kip17 = artifacts.require("KIP17Token");
const Seller = [
  artifacts.require("timeSeller100"),
  artifacts.require("timeSeller1000"),
  artifacts.require("timeSeller5000"),
  artifacts.require("timeSeller10000"),
];
const Price = [100, 1000, 5000, 10000];
const Payment = "0x27aDA6e477ea291650FEbe785e56f7888Df41576"; // token contract address
const StartWhen = 0; //timestamp

module.exports = async function (deployer) {
  console.log(kip17.address);
  for (let i = 0; i < Seller.length; i++)
    await deployer.deploy(
      Seller[i],
      kip17.address,
      Payment,
      Price[i],
      StartWhen
    );
};
