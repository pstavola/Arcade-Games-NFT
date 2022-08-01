// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ArcadeGamesNFT is
    ERC721,
    ERC721Enumerable,
    ERC721URIStorage,
    Ownable
{
    uint256 public tokenIdCounter = 0;
    uint256 public mintPrice = 0.01 ether;
    uint256 public constant maxSupply = 100;
    uint256 public maxPerTxn = 5;
    string public URI = "https://ipfs.io/ipfs/QmTYnT6ZCa9Gke6iEh1QqYgXbbST4CTeKHboURZ7VYU79A";

    constructor() ERC721("ArcadeGamesNFT", "AGN") {}
    

    function _baseURI() internal pure override returns (string memory) {
        return "https://ipfs.io/ipfs/";
    }

    function mintItem(address to, uint256 _amount) public payable {
        require(totalSupply() <= maxSupply);
        require(msg.value >= _amount * mintPrice, "Not enough ETH sent!");
        require(_amount <= maxPerTxn, "You cannot mint more than 5 NFTs in a single transaction");

        for(uint256 i=0; i < _amount; i++){
            tokenIdCounter++;
            _safeMint(to, tokenIdCounter);
            _setTokenURI(tokenIdCounter, URI);
        }
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function refund()
        public
        onlyOwner
    {
        payable(msg.sender).transfer(address(this).balance);
    }
}
