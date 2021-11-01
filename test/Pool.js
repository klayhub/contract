const Pool = artifacts.require("Pool");
const StakeToken = artifacts.require("StakeToken");
const RewardToken = artifacts.require("RewardToken");

contract("Pool", (accounts) => {
  const MyAddress = "0x94503955d5aa7a97ccca15f1b0d985696ea8afe1";
  it("pool initiated completely", async () => {
    const PoolInstance = await Pool.deployed();
    const StakeTokenInstance = await StakeToken.deployed();
    const RewardTokenInstance = await RewardToken.deployed();
    const name = await PoolInstance.name.call();
    const NameOfstakeToken = await StakeTokenInstance.name.call();
    const NameOfrewardToken = await RewardTokenInstance.name.call();
    const startTime = await PoolInstance.startTime.call();
    const DURATION = await PoolInstance.DURATION.call();

    assert.equal(name, "No.1 Test Pool", "Wrong name");
    assert.equal(NameOfstakeToken, "Stake Token", "Wrong stakeToken");
    assert.equal(NameOfrewardToken, "Reward Token", "Wrong rewardToken");
    assert.equal(startTime, 1635266244, "Wrong startTime");
    assert.equal(DURATION, 604800, "Wrong DURATION");
  });

  it("Pool reward setting complete", async () => {
    const PoolInstance = await Pool.deployed();
    const rewardDistribution = await PoolInstance.rewardDistribution.call();

    assert.equal(rewardDistribution, MyAddress, "Wrong rewardDistribution");
  });
});
