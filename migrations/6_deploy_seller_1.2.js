const kip17 = artifacts.require("KIP17Token");
const Seller = artifacts.require("timeSellerForFailed");
const Price = "1000000000"; // KUSDT Decimal 6
const Payment = "0xcee8faf64bb97a73bb51e115aa89c17ffa8dd167"; // token contract address
const StartWhen = 1636707600; //timestamp

module.exports = async function (deployer) {
  console.log(kip17.address);
  await deployer.deploy(Seller, kip17.address, Payment, Price, StartWhen);
};
