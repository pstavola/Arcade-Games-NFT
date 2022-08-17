// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

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
    uint256 public mintPrice = 0.01 ether; //mint price
    uint256 public constant maxSupply = 100; //max NFT supply
    uint256 public maxPerTxn = 5; //max quantity of NFTs minted in one transaction
    string public URI = "https://ipfs.io/ipfs/QmTYnT6ZCa9Gke6iEh1QqYgXbbST4CTeKHboURZ7VYU79A"; //IPFS address of the art collection

    /* ========== CONSTRUCTOR ========== */

    constructor() ERC721("ArcadeGamesNFT", "AGN") {}
    
    /* ========== FUNCTIONS ========== */

    /**
     * @notice mints the amount of token requested by iterating parent _safeMint and _setTokenURI functions. ID counter is increased each minted token. Checks that max tokens supply, max amount of tokens per txn and mint price are correct.
     * @param to address to send tokens to
     * @param _amount amount of tokens to be minted
     */
    function mintItem(address to, uint256 _amount) public payable {
        require(totalSupply() < maxSupply, "Maximum supply of 100 has been reached");
        require(_amount <= maxPerTxn, "You cannot mint more than 5 NFTs in a single transaction");
        require(msg.value >= _amount * mintPrice, "Not enough ETH sent!");

        for(uint256 i=0; i < _amount; i++){
            tokenIdCounter++;
            _safeMint(to, tokenIdCounter);
            _setTokenURI(tokenIdCounter, URI);
        }
    }


    /**
     * @notice transfers all the funds collected to owner address. Only owner can invoke this
     */
    function withdraw()
        public
        onlyOwner
    {
        payable(msg.sender).transfer(address(this).balance);
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
