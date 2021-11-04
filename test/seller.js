const kip17 = artifacts.require("KIP17Token");
const kip7 = artifacts.require("KIP7Token");
const Seller = [
  artifacts.require("timeSeller100"),
  artifacts.require("timeSeller1000"),
  artifacts.require("timeSeller5000"),
  artifacts.require("timeSeller10000"),
];
contract("Seller", (accounts) => {
  const MyAddress = "0x94503955d5aa7a97ccca15f1b0d985696ea8afe1";
  it("Buy", async () => {
    const hub = await kip17.deployed();
    const seller100 = await Seller[0].deployed();
    const seller1000 = await Seller[1].deployed();
    const seller5000 = await Seller[2].deployed();
    const seller10000 = await Seller[3].deployed();

    await hub.approve(
      seller5000.address,
      999999999999999999999999999999999999999,
      { from: MyAddress }
    );
    await hub.approve(
      seller10000.address,
      999999999999999999999999999999999999999,
      { from: MyAddress }
    );

    await seller5000.BuyTime(1);
    await seller10000.BuyTime(2);
  });
});
