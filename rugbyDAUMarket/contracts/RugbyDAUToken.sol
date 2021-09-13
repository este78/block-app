// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract RugbyDAUToken is ERC721, ERC721Enumerable, ERC721URIStorage {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    //The contract address of the exchange,it requires operator permission to transfer tokens between owner and buyer. The address will be set up in the contract's constructor along with the name and symboi of the token.
    address contractMarketAddress;
    address owner;
    mapping (address => bool) private minters;

    constructor(address _marketAddress) ERC721("RugbyDAU Token", "RGBY") {
        owner = msg.sender;
        setMinter(owner);
        contractMarketAddress = _marketAddress;
    }
  modifier onlyOwner {
       require(tx.origin == owner, "Only the owner has access to this feature");
       _;
    }
  //internal function to concatenate the base URI to the CID from IPFS
  function _baseURI() internal pure override returns (string memory) {
        return "https://ipfs.io/ipfs/";
    }
  //set and revoke permission to creators to mint
  function setMinter(address _creator) public onlyOwner{
      minters[_creator]= true;
    }
  function revokeMinter(address _creator) public onlyOwner{
      minters[_creator]=false;
    }
  function isMinter(address _creator) public view returns (bool){
      return minters[_creator];
    }
  
  //mints a Non-Fungible Token
  function createToken(string memory tokenURI) public returns (uint) {
    require(isMinter(tx.origin), "Only authorised creators can mint");
    //add 1 to the array index
    _tokenIdCounter.increment();
    uint256 newTokenId = _tokenIdCounter.current();

    //internal functions from ERC721, mint new token and set the URI of the underlying digital asset
    _mint(msg.sender, newTokenId);
    _setTokenURI(newTokenId, tokenURI);
    //required operator approval for the RugbyDAU exchange
    setApprovalForAll(contractMarketAddress, true);
    //return id of the token for the react application
    return newTokenId;
  }
 
    
    // The following functions are overrides required by Solidity.
     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
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
}


  



