// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ArcadeGamesNFT.sol";
import "openzeppelin-contracts/contracts/token/ERC721/utils/ERC721Holder.sol";

contract ArcadeGamesNFTTest is Test, ERC721Holder {
    //the identifier of the fork
    //uint256 mainnetFork;
    //string MAINNET_RPC_URL = 'https://eth-mainnet.g.alchemy.com//v2/ALCHEMY_KEY';

    ArcadeGamesNFT public nft;

    function setUp() public {
        //mainnetFork = vm.createFork(MAINNET_RPC_URL);
        nft = new ArcadeGamesNFT();
    }

    // The contract is deployed successfully
    function testCreateContract() public {
        nft.tokenIdCounter();
    }

    // The deployed address is set to the owner
    function testOwner() public {
        assertEq(nft.owner(), address(this));
    }

    // No more than 100 tokens can be minted
    function testFailMintMoreThan100() public {
        for(uint256 i; i <= 100; i++){
            nft.mintItem{value:0.01 ether}(address(this), 1);
        }
    }
}
