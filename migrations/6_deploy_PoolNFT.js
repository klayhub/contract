const _NFT = artifacts.require("PoolKIP17Token");

module.exports = function (deployer) {
  deployer.deploy(_NFT, "HUB:Pool-NFT", "POOL");
};
