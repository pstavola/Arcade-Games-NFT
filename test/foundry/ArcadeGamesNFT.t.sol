// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../contracts/ArcadeGamesNFT.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol"; // Needed so the test contract itself can receive NFTs

contract ArcadeGamesNFTTest is Test, ERC721Holder {

    ArcadeGamesNFT public nft;
    //string public constant baseTokenURI = "ipfs://QmTYnT6ZCa9Gke6iEh1QqYgXbbST4CTeKHboURZ7VYU79A";

    function setUp() public {
        nft = new ArcadeGamesNFT();
    }

    // a. The contract is deployed successfully.
    function testCreateContract() public view {
        nft.tokenIdCounter();
    }

    // b. The deployed address is set to the owner.
    function testOwner() public {
        assertEq(nft.owner(), address(this));
    }

    // c. No more than 100 tokens can be minted.
    function testCannotMintMoreThan100() public {
        for(uint256 i; i <= 19; i++){
            nft.mintItem{value:0.05 ether}(5);
        }

        vm.expectRevert(abi.encodePacked("Maximum supply of 100 has been reached"));

        nft.mintItem{value:0.01 ether}();
    }

    // d. A token can not be minted if less value than cost (0.01) is provided.
    function testCannotMintForLessThanMinimumValue(uint256 _value) public {
        vm.expectRevert(abi.encodePacked("Not enough ETH sent!"));

        _value = bound(_value, 1 wei, 9999999999999999 wei);

        nft.mintItem{value:_value}();
    }

    // e. No more than five tokens can be minted in a single transaction.
    function testCannotMintMoreThan5TokensInASingleTxn() public {
        vm.expectRevert(abi.encodePacked("You cannot mint more than 5 NFTs in a single transaction"));

        nft.mintItem{value:0.06 ether}(6);
    }

    // f. The owner can withdraw the funds collected from the sale.
    function testOwnerCanWithdraw() public {
        address alice = makeAddr("alice");
        hoax(alice);
        nft.mintItem{value:0.05 ether}(5);

        vm.prank(nft.owner());
        nft.withdraw();
    }

    // Needed so the test contract itself can receive ether when withdrawing
    receive() external payable {}

    // g. You can mint one token provided the correct amount of ETH.
     function testMint1Token() public {
        nft.mintItem{value:0.01 ether}();
    }

    // h. You can mint three tokens in a single transaction provided the correct amount of ETH.
     function testMint3Tokens() public {
        nft.mintItem{value:0.03 ether}(3);
    }

    // i. Check the balance of an account that minted three tokens.
     function testCheckBalance() public {
        address alice = makeAddr("alice");
        hoax(alice);
        uint256 preBalance = alice.balance;
        nft.mintItem{value:0.03 ether}(3);
        uint256 postBalance = alice.balance;
        assertEq(preBalance - 0.03 ether, postBalance);
    }
}
