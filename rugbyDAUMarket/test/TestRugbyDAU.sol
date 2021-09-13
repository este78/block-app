// SPDX-License-Identifier: MIT
pragma solidity >0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/RugbyDAUMarket.sol";
import "../contracts/RugbyDAUToken.sol";

contract TestRugbyDAU {

    uint public initialBalance = 0.001 ether;
    
    RugbyDAUMarket market = RugbyDAUMarket(DeployedAddresses.RugbyDAUMarket());
    RugbyDAUToken rgbyToken = RugbyDAUToken(DeployedAddresses.RugbyDAUToken());

    uint token1 = rgbyToken.createToken("QmTFXTec3N5i6XZUEaoftfSXb2uRoSq14soypA1Uts8H4J");
    uint token2 = rgbyToken.createToken("QmNSiNZ82EDS98pubWTemdVmXU313FCpchFpTj2RHC61Gu");

    uint listingPrice = market.getListingPrice();

    //market.createMerchandise(address(rgbyToken), token1, 0.0001 ether,{value:listingPrice});
    
    //market.createSale(address(rgbyToken), token1,{value:0.0001 ether, from:"0x1851Adc1531F0F59c6d4B6ffFd76A6206B51422B"});

  function testGetListingPrice() public {
   Assert.equal(listingPrice, 0.00001 ether , "It should be 10000000000000 wei.");
  }
  //tests if the token is minted(has an id), 
  function testCreateToken() public{
    Assert.equal(token1, 1 , "Token 1 id is = 1");
    bool isApproved = rgbyToken.isApprovedForAll(address(this), address(market));
    Assert.equal(isApproved, true, "Is marketplace operator");
    string memory tokenURI = rgbyToken.tokenURI(token1);
    Assert.equal(tokenURI,"https://ipfs.io/ipfs/QmTFXTec3N5i6XZUEaoftfSXb2uRoSq14soypA1Uts8H4J","Token URI stored");
  }
  function testIsMinter() public{
    //account that creates the tokenContract
    bool minter = rgbyToken.isMinter(0x044Efb951F1c3F150A22886B9D45fC5a6C5A755E);
    //another account in the network (not approved)
    bool notMinter = rgbyToken.isMinter(0xA40E84588B96529706c2aAe74e94B12bf9cB4a82);
    Assert.equal(minter, true, "The role of creator includes minter");
    Assert.equal(notMinter, false, "This user is not a creator");
  }
  //testing create a new item in the marketplace
  function testCreateMerchandise() public{
    //call create merchandise and send the required value
    market.createMerchandise{value: 0.00001 ether}(address(rgbyToken), token2, 0.0005 ether);

    Assert.equal(market.showMyMerchandise()[0].itemId, 1, "Check the itemId has been parsed");
    Assert.equal(market.showMyMerchandise()[0].rugbydauTokenContract, address(rgbyToken), "Check the minting contract address has been parsed");
    Assert.equal(market.showMyMerchandise()[0].seller, address(this), "Check the tokenId has been parsed");
    Assert.equal(market.showMyMerchandise()[0].owner, address(0), "Check the tokenId has been parsed");
    Assert.equal(market.showMyMerchandise()[0].price, 0.0005 ether, "Check the tokenId has been parsed");
    Assert.equal(market.showMyMerchandise()[0].isSold, false, "Check the tokenId has been parsed");
  }

  //testing a sale
  
  /*function testCreateSale() public{
    market.createMerchandise{value: 0.00001 ether}(address(rgbyToken), token2, 0.0005 ether);
    address buyer = 0x1851Adc1531F0F59c6d4B6ffFd76A6206B51422B;
    market.createSale{value: 0.0005 ether}(address(rgbyToken), 1);

    Assert.equal(market.showMyMerchandise()[0].owner, address(this), "Check the tokenId has been parsed");
    Assert.equal(market.showMyMerchandise()[0].isSold, true, "Check the tokenId has been parsed");
  }*/

}
