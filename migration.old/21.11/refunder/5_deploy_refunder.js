const _time = artifacts.require("KIP17Token");
const Refunder = artifacts.require("timeRefunder");
const OLD_NFT = "0xd8bcdf643a4b1ea328758e4096750fe96ec869aa";
const PAYMENT = "0xcee8faf64bb97a73bb51e115aa89c17ffa8dd167";

module.exports = async function (deployer) {
  const time = await _time.deployed();
  await deployer.deploy(Refunder, OLD_NFT, time.address, PAYMENT);
};
