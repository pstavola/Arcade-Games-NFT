// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const baseTokenURI = "ipfs://QmTYnT6ZCa9Gke6iEh1QqYgXbbST4CTeKHboURZ7VYU79A"; // IPFS address of the art collection
  const ArcadeGamesNFT = await hre.ethers.getContractFactory("ArcadeGamesNFT");
  const arcaedgamesnft = await ArcadeGamesNFT.deploy(baseTokenURI);

  await arcaedgamesnft.deployed();

  console.log("ArcadeGamesNFT deployed to:", arcaedgamesnft.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
