const kip17 = artifacts.require("KIP17Token");
const Seller = artifacts.require("timeSellerForFailed");

const mintAmount = [
  [1, 9, 100, 500, 1000, 3390],
  [1, 9, 30, 50, 100, 200, 610],
  [1, 9, 30, 50, 110],
  [1, 5, 9, 20, 65],
];
const mintPrice = [100, 1000, 5000, 10000];

const completed = [
  [1, 9, 100, 500, 1000, 3390],
  [1, 9, 30, 50, 100, 200, 110],
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

let count = 0;
module.exports = async function (deployer) {
  const nft = await kip17.deployed();
  const seller = await Seller.deployed();

  for (let i = 0; i < mintAmount.length; i++)
    for (let j = 0; j < mintAmount[i].length; j++) {
      let m = mintAmount[i][j];
      for (let n = 1; n <= m; n++)
        try {
          if (completed[i][j] >= n) continue;
          const newId = tokenId(1, mintPrice[i], n, m);
          console.log("Token Id : ", newId);
          const approved = (await nft.getApproved(newId)).toString();
          seller.registerById(newId, count++);
          // console.log("Approved ", approved);
          // if (approved != seller.address) {
          //   console.log(`${newId} not approved`);
          //   nft.approve(seller.address, newId);
          //   seller.registerById(newId, count++);
          // } else console.log("Already Exists");
        } catch (e) {
          console.log("Error", e);
        }
    }
};
