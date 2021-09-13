pragma solidity ^0.8.2;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract RugbyDAUMarket is ReentrancyGuard {
    //Vars to keep track of the length of the arrays that need display in the shop
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    Counters.Counter private _itemSold;

    //who is the onwer of the contract (for comissions)
    address payable owner;
    uint listingPrice = 0.00001 ether; //== €0.03 at the moment of coding 

    constructor(){
        owner = payable(msg.sender);
    }   
    //"Object" that helps mapping the variables involving the exchange of tokens between the stakeholders of the transaction ()
    struct Merchandise {
        uint itemId;                   // id of the item listed
        address rugbydauTokenContract;  // minting contract's address
        uint256 tokenId;                // id of the token 
        address payable seller;         // current owner of the token
        address payable owner;          // original owner of the contract
        uint256 price;                  // price of the token
        bool isSold;                    // 
    }
    //map an id to the items for sale
    mapping(uint256 => Merchandise) private idToMerchandise;
    //emit an event for the front end
    event MerchandiseCreated(
        uint indexed itemId,
        address indexed rugbydauTokenContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool isSold  
    );
    //Gets the listing pricing
    function getListingPrice() public view returns (uint256){
        return listingPrice;
    }
    //adds a new nft to the marketplace stock (list)
    function createMerchandise(address rugbydauTokenContract, uint256 tokenId, uint256 price) public payable nonReentrant{
        //check that the minter pays the market fees also that a price is set for the item
        require(price>0, "Price must be bigger than zero");
        require(msg.value == listingPrice, "Must pay the marketplace's due");
        //use counter to determine the index in the merchandise mapping
        _itemIds.increment();
        uint256 itemId = _itemIds.current();
        //create entry in the merchandise mapping
        idToMerchandise[itemId] = Merchandise(
            itemId,                 //id of the item in the market stock
            rugbydauTokenContract,  //contract where the token was minted
            tokenId,                //id of the token
            payable(msg.sender),    //address that created the entry
            payable(address(0)),    //token minter,it's 0 because seller==owner in merch creation
            price,                  //price of item
            false);                 //set to false because item is just being listed
    
        //the marketplace is taking ownership of the contract to be able to transfer
        IERC721(rugbydauTokenContract).transferFrom(msg.sender, address(this), tokenId);
        //emit event
        emit MerchandiseCreated(itemId,rugbydauTokenContract,tokenId,msg.sender,address(0),price,false);
    }
    //processes the sale of a listed nft
    function createSale(address rugbydauTokenContract, uint256 itemId) public payable nonReentrant{
        //use the item Id to get the price and the token id
        uint myPrice = idToMerchandise[itemId].price;
        uint myTokenId = idToMerchandise[itemId].tokenId;
        
        //check that the buyer sends funds
        require(msg.value == myPrice, "Please send the requested price for the item");
        
        //transfer the eth payed by customer from this contract's address to the seller's address
        idToMerchandise[itemId].seller.transfer(msg.value);
        
        //transfer the ownership from this contract's address to the buyer's address
        IERC721(rugbydauTokenContract).transferFrom(tx.origin, msg.sender, myTokenId);
        
        //update the Merchandise mapping wth the new owner and changing the isSold to true
        idToMerchandise[itemId].owner= payable(msg.sender);
        idToMerchandise[itemId].isSold = true;

        //keep track of the number of items sold
        _itemSold.increment();

        //pay the owner of the marketplace the listing fee
        payable(owner).transfer(listingPrice);
    }
    //Functions querying about NFTs 
    //Return the NFTs currently for sale
    function showMarketStock() public view returns (Merchandise[] memory){
        uint stockCount = _itemIds.current();
        uint unsoldStockCount = _itemIds.current() - _itemSold.current();
        uint currentIndex = 0;

        Merchandise[] memory stock = new Merchandise[](unsoldStockCount);
        for(uint i= 0; i < stockCount; i++){
            //only items with no owner are listed in the marketplace(all others are sold already)
            if(idToMerchandise[i+1].owner == address(0)){
               uint currentId = idToMerchandise[i+1].itemId;
               Merchandise storage currentItem = idToMerchandise[currentId];
               stock[currentIndex] = currentItem;
               currentIndex++;
            }
        }
        //return the array
        return stock;
    }
    //Fetch the msg.sender's own NFTs
    function showMyRugbyDAUs() public view returns (Merchandise[] memory){
        uint totalItemCount = _itemIds.current();
        uint itemCount = 0;
        uint currentIndex = 0;

        for(uint i = 0; i < totalItemCount; i++){
            if(idToMerchandise[i+1].owner == msg.sender){
                itemCount++;
            }
        }

        Merchandise[] memory myCollection = new Merchandise[](itemCount);
        for(uint i= 0; i < totalItemCount; i++){
            //only items with no owner are listed in the marketplace(all others are sold already)
            if(idToMerchandise[i+1].owner == msg.sender){
               uint currentId = idToMerchandise[i+1].itemId;
               Merchandise storage currentItem = idToMerchandise[currentId];
               myCollection[currentIndex] = currentItem;
               currentIndex++;
            }
        }
        //return the array
        return myCollection;   
    }
    //Fetch all the merch for sale created by the msg.sender
    function showMyMerchandise() public view returns (Merchandise[] memory){
         uint totalItemCount = _itemIds.current();
        uint itemCount = 0;
        uint currentIndex = 0;

        for(uint i = 0; i < totalItemCount; i++){
            if(idToMerchandise[i+1].seller == msg.sender){
                itemCount++;
            }
        }

        Merchandise[] memory myMerchandise = new Merchandise[](itemCount);
        for(uint i= 0; i < totalItemCount; i++){
            //only items whose seller is the same as the msg.sender
            if(idToMerchandise[i+1].seller == msg.sender){
               uint currentId = idToMerchandise[i+1].itemId;
               Merchandise storage currentItem = idToMerchandise[currentId];
               myMerchandise[currentIndex] = currentItem;
               currentIndex++;
            }
        }
        return myMerchandise;
    }
}