const kip17 = artifacts.require("KIP17Token");
const kip7 = artifacts.require("KIP7Token");
const Seller = [
  artifacts.require("timeSeller100"),
  artifacts.require("timeSeller1000"),
  artifacts.require("timeSeller5000"),
  artifacts.require("timeSeller10000"),
];

const mintAmount = [
  [1, 2],
  [1, 3],
  [1, 4],
  [1, 5],
];
const mintPrice = [100, 1000, 5000, 10000];
const metadataURI = "https://nft.klayhub.com/metadata/";
const version = 1;

const minter = "0x94503955d5aa7a97ccca15f1b0d985696ea8afe1";

module.exports = async function (deployer) {
  const nft = await kip17.deployed();
  const seller = [
    await Seller[0].deployed(),
    await Seller[1].deployed(),
    await Seller[2].deployed(),
    await Seller[3].deployed(),
  ];

  // n/m - p
  for (let p = 0; p < mintAmount.length; p++) {
    for (let i = 0; i < mintAmount[p].length; i++) {
      let m = mintAmount[p][i];
      for (let n = 1; n <= m; n++) {
        const _price = mintPrice[p].toString().padStart(10, "0");
        const _number = n.toString().padStart(5, "0");
        const _amount = mintAmount[p][i].toString().padStart(5, "0");
        const _version = version.toString().padStart(5, "0");
        const tokenId = `${_version}${_price}${_number}${_amount}`;
        console.log("TokenID", tokenId.replace(/(^0+)/, ""));
        try {
          await nft.mintWithTokenURI(
            minter,
            tokenId,
            `${metadataURI}${tokenId}.json`
          );
          nft.approve(seller[p].address, tokenId);
          seller[p].register(tokenId);
        } catch (e) {
          console.log("Token Already Exists", tokenId);
        }
      }
    }
  }
};
