const kip17 = artifacts.require("KIP17Token");
const Seller = [
  // artifacts.require("timeSeller100"),
  artifacts.require("timeSeller1000"),
  // artifacts.require("timeSeller5000"),
  // artifacts.require("timeSeller10000"),
];
const Price = ["100000000", "1000000000", "5000000000", "10000000000"]; // KUSDT Decimal 6
const Payment = "0xcee8faf64bb97a73bb51e115aa89c17ffa8dd167"; // token contract address
const StartWhen = 1636164000; //timestamp

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
