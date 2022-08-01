require("@nomiclabs/hardhat-waffle");

module.exports = {
  solidity: "0.8.9",
  networks: {
    hardhat: {
      chainId: 1337
    },
    goerli: {
      url: "https://goerli.infura.io/v3/1fc7c7c3701c4083b769e561ae251f9a",
      accounts: [process.env.pk]
    },
    mainnet: {
      url: "https://mainnet.infura.io/v3/1fc7c7c3701c4083b769e561ae251f9a",
      accounts: [process.env.pk]
    }
  }
};