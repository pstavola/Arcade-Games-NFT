// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Arcade Games NFT
 * @author patricius
 * @notice An NFT collection of covers of the 100 best Arcade Games ever
 * @dev A standard ERC721 implementation. Artworks are stored on IPFS
 */
contract ArcadeGamesNFT is
    ERC721,
    ERC721Enumerable,
    ERC721URIStorage,
    Ownable
{
    /* ========== GLOBAL VARIABLES ========== */

    uint256 public tokenIdCounter = 0; //token id counter incremented per each mint
    uint256 public constant MINT_PRICE = 0.01 ether; //mint price
    uint256 public constant MAX_SUPPLY = 100; //max NFT supply
    uint256 public constant MAX_PER_TXN = 5; //max quantity of NFTs minted in one transaction
    string public baseTokenURI;

    /* ========== MODIFIERS ========== */

    /**
     * @notice Based on Mint Price it checks that enough ETH has been sent.
     */
    modifier minValue(uint256 _amount) {
        require(msg.value >= _amount * MINT_PRICE, "Not enough ETH sent!");
        _;
    }

    /* ========== CONSTRUCTOR ========== */

    constructor(string memory baseURI) ERC721("Arcade Games", "ARCG") {
        setBaseURI(baseURI);
    }
    
    /* ========== FUNCTIONS ========== */

    /**
     * @notice mints token using parent _safeMint function. ID counter is increased each minted token. Checks that max tokens supply and mint price are respected.
     */
    function mintItem() public payable minValue(1) {
        require(totalSupply() < MAX_SUPPLY, "Maximum supply of 100 has been reached");

        tokenIdCounter++;
        _safeMint(msg.sender, tokenIdCounter);
    }

    /**
     * @notice mints the amount of token requested by iterating over mintItem() function. Checks that max amount of tokens per txn and mint price are correct.
     * @param _amount amount of tokens to be minted
     */
    function mintItem(uint256 _amount) public payable minValue(_amount) {
        require(_amount <= MAX_PER_TXN, "You cannot mint more than 5 NFTs in a single transaction");

        for(uint256 i=0; i < _amount; i++){
            mintItem();
        }
    }

    /**
     * @notice transfers all the funds collected to owner address. Only owner can invoke this
     */
    function withdraw()
        public
        payable
        onlyOwner
    {
        uint balance = address(this).balance;
        require(balance > 0, "No ether left to withdraw");

        (bool sent, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(sent, "Transfer failed.");
    }

    /**
     * @notice Set baseTokenURI state variable.
     * @param _baseTokenURI URI address
     */
    function setBaseURI(string memory _baseTokenURI) public onlyOwner {
        baseTokenURI = _baseTokenURI;
    }

    /**
     * @notice override required by Solidity.
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    /**
     * @notice override required by Solidity.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    /**
     * @notice override required by Solidity.
     */
    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    /**
     * @notice override required by Solidity.
     */
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    /**
     * @notice override required by Solidity.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
