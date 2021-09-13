// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract RugbyDAUToken is ERC721URIStorage {
  //util for keeping track with the unique id of the minted tokens
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  //The contract address of the exchange,it requires operator permission to transfer tokens between owner and buyer. The address will be set up in the contract's constructor along with the name and symboi of the token.
  address contractMarketAddress;
  constructor(address _marketAddress) ERC721("RugbyDAU Tokens","RGBY") {
    contractMarketAddress = _marketAddress;
  }
  //Automaticallyconcatenates this to the CID from IPFS
  function _baseURI() internal pure override returns (string memory) {
        return "https://https://ipfs.io/ipfs/";
    }

  function createToken(string memory tokenURI) public returns (uint){
    //add 1 to the array index
    _tokenIds.increment();
    uint256 newTokenId = _tokenIds.current();

    //internal functions from ERC721, mint new token and set the URI of the underlying digital asset
    _mint(msg.sender, newTokenId);
    _setTokenURI(newTokenId, tokenURI);
    //required operator approval for the RugbyDAU exchange
    setApprovalForAll(contractMarketAddress, true);
    //return id of the token for the react application
    return newTokenId;
  }
}

