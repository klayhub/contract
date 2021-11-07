const kip17 = artifacts.require("KIP17Token");
const nftMinter = artifacts.require("nftMinter");
const timeRefunder = artifacts.require("timeRefunder");

const mintAmount = [
  [1, 9, 100, 500, 1000, 3390],
  [1, 9, 30, 50, 100, 200, 610],
  [1, 9, 30, 50, 110],
  [1, 5, 9, 20, 65],
];
const mintPrice = [100, 1000, 5000, 10000];

const completed = [
  [1, 9, 100, 500, 1000, 3390],
  [1, 9, 30, 50, 100, 200, 100],
  [1, 9, 30, 50, 110],
  [1, 5, 9, 20, 65],
];

function tokenId(version, price, n, m) {
  const _price = price.toString().padStart(7, "0");
  const _number = n.toString().padStart(5, "0");
  const _amount = m.toString().padStart(5, "0");
  const _version = 1;
  const tokenId = `${_version}${_price}${_number}${_amount}`;
  return tokenId;
}
module.exports = async function (deployer) {
  const nft = await kip17.deployed();
  const minter = await nftMinter.deployed();
  // await nft.addMinter(minter.address);

  for (let i = 0; i < mintAmount.length; i++)
    for (let j = 0; j < mintAmount[i].length; j++) {
      let m = mintAmount[i][j];
      for (let n = 1; n <= m; n += 21)
        try {
          if (completed[i][j] >= n) continue;
          console.log(tokenId(1, mintPrice[i], n, m));
          await minter.mint(
            "0x2ccd2dfc4e6dd26945cfa8048b3b03a2ed81628d",
            mintPrice[i],
            n,
            m
          );
        } catch (e) {
          console.log("Already Exists");
        }
    }
};
