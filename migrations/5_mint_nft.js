const kip17 = artifacts.require("KIP17Token");
const nftMinter = artifacts.require("nftMinter");

const mintAmount = [[1, 9, 20]];
const mintPrice = [100, 1000, 5000, 10000];

const completed = [[0, 0, 0]];

module.exports = async function (deployer, network, accounts) {
  const nft = await kip17.deployed();
  const minter = await nftMinter.deployed();
  await nft.addMinter(minter.address);

  for (let i = 0; i < mintAmount.length; i++)
    for (let j = 0; j < mintAmount[i].length; j++) {
      let m = mintAmount[i][j];
      for (let n = 1; n <= m; n += 21)
        try {
          if (completed[i][j] > n) continue;
          console.log(mintPrice[i], n, m);
          await minter.mint(accounts[0], mintPrice[i], n, m);
        } catch (e) {
          console.log("Already Exists");
        }
    }
};
