const kip17 = artifacts.require("KIP17Token");
const Seller = [
  artifacts.require("timeSeller100"),
  artifacts.require("timeSeller1000"),
  artifacts.require("timeSeller5000"),
  artifacts.require("timeSeller10000"),
];

const mintAmount = [
  [1, 9, 100, 500, 1000, 3390],
  [1, 9, 30, 50, 100, 200, 610],
  [1, 9, 30, 50, 110],
  [1, 5, 9, 20, 65],
];
const mintPrice = [100, 1000, 5000, 10000];

const completed = [
  [1, 9, 100, 500, 1000, 1940],
  [1, 9, 30, 50, 100, 200, 610],
  [1, 9, 30, 50, 110],
  [1, 5, 9, 20, 65],
];

let count = [3550, 0, 0, 0]; // 1 더 낮게 설정
//3610 4991

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
  const seller = [
    await Seller[0].deployed(),
    await Seller[1].deployed(),
    await Seller[2].deployed(),
    await Seller[3].deployed(),
  ];

  for (let i = 0; i < mintAmount.length; i++) {
    for (let j = 0; j < mintAmount[i].length; j++) {
      let m = mintAmount[i][j];
      for (let n = 1; n <= m; n++) {
        if (completed[i][j] >= n) continue;
        const newId = tokenId(1, mintPrice[i], n, m);
        console.log("\nToken Id : ", newId, count[i]);
        const approved = (await nft.getApproved(newId)).toString();
        const registered = (await seller[i].tokenIdById(count[i])).toString();
        console.log("Approved ", approved);
        if (approved != seller[i].address) {
          console.log(`Approving...`);
          nft.approve(seller[i].address, newId);
        } else console.log("Already Approved");
        if (registered != newId) {
          try {
            console.log("Registering..", newId, count[i]);
            seller[i].registerById(newId, count[i]);
          } catch (e) {
            console.log("ERORR!!!! ", approved, newId, count[i]);
            console.log("Error", e);
          }
        } else console.log("Already Registered");
        count[i]++;
      }
    }
  }
};
