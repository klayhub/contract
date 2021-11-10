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
  [0, 0, 0, 0, 0, 0, 0],
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

const test = [
  [100001000018701000, 100001000000100100],
  [100001000018801000, 100001000000200100],
  [100001000018901000, 100001000000300100],
  [100001000019001000, 100001000000400100],
  [100001000019101000, 100001000000500100],
  [100001000019201000, 100001000000600100],
  [100001000019301000, 100001000000700100],
  [100001000019401000, 100001000000800100],
];

module.exports = async function (deployer) {
  const nft = await kip17.deployed();
  const minter = await nftMinter.deployed();
  const refunder = await timeRefunder.deployed();
  // await nft.addMinter(minter.address);

  const mintLimit = 501;
  let count = 1;
  // for (let i = 0; i < test.length; i++) {
  //   await nft.approve(refunder.address, test[i][1].toString());
  //   await refunder.register(test[i][0].toString(), test[i][1].toString());
  // }
  for (let i = 0; i < mintAmount.length; i++)
    for (let j = 0; j < mintAmount[i].length; j++) {
      let m = mintAmount[i][j];
      for (let n = 1; n <= m; n++)
        try {
          if (completed[i][j] >= n) continue;
          if (count >= mintLimit) break;
          const oldId = tokenId(1, mintPrice[i], count, 610);
          const newId = tokenId(1, mintPrice[i], n, m);
          console.log(oldId, newId);
          const approved = (await nft.getApproved(newId)).toString();
          const registered = (await refunder.NewId(oldId)).toString();
          console.log(approved);
          if (approved != refunder.address) {
            console.log(`${newId} not approved`);
            nft.approve(refunder.address, newId);
          }
          if (registered == "0") {
            console.log(`${oldId} not registered`);
            refunder.register(oldId, newId);
          }
          count++;
        } catch (e) {
          console.log("Already Exists", e);
        }
    }
};
