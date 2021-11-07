const BigNumber = web3.BigNumber;
const MockToken = artifacts.require("MockToken");
const Airdrop = artifacts.require("Airdrop");
const { expectRevert } = require("@openzeppelin/test-helpers");

require("chai")
  .use(require("chai-as-promised"))
  .use(require("chai-bignumber")(BigNumber))
  .should();

contract("Airdrop", (accounts) => {
  let token;
  let airdrop;

  const [account1, account2, account3, account4, account5] = accounts;

  before(async () => {
    token = await MockToken.new("Mock Token", "MKT", web3.utils.toWei("1000"));
    airdrop = await Airdrop.new(token.address);
    await token.transfer(airdrop.address, web3.utils.toWei("1000"));
  });

  it("should have transfered 1000 tokens to airdrop contract", async () => {
    (await token.balanceOf(airdrop.address))
      .toString()
      .should.be.bignumber.equal(web3.utils.toWei("1000"));
  });

  it("should raise an exception if total is more than available", async () => {
    await expectRevert(
      airdrop.addRecipients(
        [
          { _recipient: account2, _amount: web3.utils.toWei("250") },
          { _recipient: account3, _amount: web3.utils.toWei("250") },
          { _recipient: account4, _amount: web3.utils.toWei("250") },
          { _recipient: account5, _amount: web3.utils.toWei("2500") }
        ],
        { from: account1 }
      ),
      "Not enough tokens"
    );
  });

  it("should add recipients", async () => {
    await airdrop.addRecipients(
      [
        { _recipient: account2, _amount: web3.utils.toWei("250") },
        { _recipient: account3, _amount: web3.utils.toWei("250") },
        { _recipient: account4, _amount: web3.utils.toWei("250") },
        { _recipient: account5, _amount: web3.utils.toWei("250") }
      ],
      { from: account1 }
    );
    const arr = await airdrop.getAllRecipients();
    assert.isTrue(arr.length === 4);
  });

  it("should execute airdrop", async () => {
    await airdrop.executeAirdrop({ from: account1 });
    (await token.balanceOf(account2))
      .toString()
      .should.be.bignumber.equal(web3.utils.toWei("250"));
  });
});
