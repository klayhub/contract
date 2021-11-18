const _NFTPool = artifacts.require("NFTPool");
const _time = artifacts.require("KIP17Token");
const _hub = artifacts.require("KIP7Token");
const _nft = artifacts.require("PoolKIP17Token");

module.exports = async function (deployer) {
  const time = await _time.deployed();
  const nft = await _nft.deployed();
  const hub = await _hub.deployed();
  const Pool = await deployer.deploy(
    _NFTPool,
    "HUB:NFT-POOL",
    false,
    false,
    1637261280,
    604800,
    time.address,
    _nft.address,
    _hub.address
  );
  await nft.addMinter(Pool.address);
  await nft.setApprovalForAll(Pool.address, true);
  await time.setApprovalForAll(Pool.address, true);
  await hub.approve(Pool.address, "1000000000000000000000000");
  await Pool.notifyRewardAmount("1000000");
};

/*
pool = await NFTPool.deployed()
pool.notifyRewardAmount(1000000)
pool.stake(["100001000000100001","100001000000100009"])
 */
