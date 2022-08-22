// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../../contracts/ArcadeGamesNFT.sol";

contract TestArcadaGamesNFT {
    ArcadeGamesNFT nft;

    event AssertionFailed(string reason);

    constructor() public {
        nft = new ArcadeGamesNFT();
    }

    function echidna_supply_under_100() public view returns(bool){
        return nft.totalSupply() <= nft.MAX_SUPPLY();
    }

    function echidna_correct_nft_owner() public returns(bool) {
        nft.mintItem{value:0.01 ether}();
        uint256 tokenId = nft.tokenIdCounter();

        return nft.ownerOf(tokenId) == msg.sender;
    }

    function echidna_correct_nft_balance() public returns(bool) {
        nft.mintItem{value:0.05 ether}(5);

        return nft.balanceOf(msg.sender) == 5;
    }

    function testBalance() public {
        uint256 balance = msg.sender.balance;
        nft.mintItem{value:0.01 ether}();
        uint256 newBalance = msg.sender.balance;

        if (newBalance != balance - 0.01 ether) {
            emit AssertionFailed("incorrect balance-0.01");
        }

        nft.mintItem{value:0.05 ether}(5);

        if (msg.sender.balance != newBalance - 0.05 ether) {
            emit AssertionFailed("incorrect balance-0.05");
        }
    }
}