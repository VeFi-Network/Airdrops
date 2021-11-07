const Airdrop = artifacts.require("Airdrop");

module.exports = function (deployer) {
  deployer.deploy(Airdrop, "0x1515b7652185388925f5d8283496753883416f09");
};
