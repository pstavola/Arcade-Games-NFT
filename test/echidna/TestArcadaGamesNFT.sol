// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../../contracts/ArcadeGamesNFT.sol";

contract TestArcadaGamesNFT {
    ArcadeGamesNFT nft;

    constructor() {
        nft = new ArcadeGamesNFT();
    }

    function echidna_supply_under_100() public view returns(bool){
        return nft.totalSupply() <= nft.MAX_SUPPLY();
    }

    function echidna_correct_nft_owner() public returns(bool) {
        nft.mintItem{value:0.01 ether}();
        uint256 tokenId = nft.tokenIdCounter();
        address owner = nft.ownerOf(tokenId);

        return owner == msg.sender;
    }

    function echidna_correct_nft_balance() public returns(bool) {
        nft.mintItem{value:0.05 ether}(5);
        uint256 balance = nft.balanceOf(msg.sender);

        return balance == 5;
    }

    function testBalance() public {
        uint256 balance = msg.sender.balance;
        nft.mintItem{value:0.01 ether}();
        uint256 newBalance = msg.sender.balance;

        assert(newBalance != balance - 0.01 ether);

        nft.mintItem{value:0.05 ether}(5);

        assert(msg.sender.balance != newBalance - 0.05 ether);
    }
}