// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


contract RugbyDAUToken is ERC721URIStorage {
    //used for the display of tokens
    struct File{
        uint id;
        string hash;
        string fileName;
        string fileType;
        uint date;
        bool wasAdded;
    }
    mapping(address=>File[]) files;
    
    //used for governance and minting
    address owner;
    uint private _tokenIdCounter;
    mapping (address => bool) private minters;

    constructor() ERC721("RugbyDAU", "RGBY") {
        owner = msg.sender;
        setMinter(owner);
    }
    //restrict the use of certain methods to the contract owner
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
     
    //creates a token and adds the data to the drive
    function add(string memory _hash, string memory _fileName, string memory _fileType, uint _date) public{
        require(isMinter(msg.sender), "Only authorised creators can mint");
        //tokens start count from 1, any token showing id in the display has been deleted (there is no token zero)
        _tokenIdCounter++;
        uint256 tokenId = _tokenIdCounter;
        //internal functions from ERC721, mint new token and set the URI of the underlying digital asset
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, _hash);
        
       //First file ever added to the drive
        if (files[msg.sender].length == 0){
            files[msg.sender].push(File({id:tokenId, hash:_hash,fileName:_fileName,fileType:_fileType,date:_date, wasAdded:true}));
        }else{
            //any other add after the first
            uint lastIndex = files[msg.sender].length; 
            File memory lastEntry = files[msg.sender][lastIndex-1]; 
            //check for a deletion in the last entry of the array
            if(!lastEntry.wasAdded){
                //if a deletion is detected, cycle back until a record is found or the second entry is reached
                while((!lastEntry.wasAdded) && lastIndex>=1){
                    lastEntry = files[msg.sender][lastIndex-1];
                    lastIndex--;
                 }
                 //in case all files were deleted, add the new file in the first position
                 if(lastIndex == 0 && (!files[msg.sender][0].wasAdded)){
                     files[msg.sender][0]=File({id:tokenId, hash:_hash,fileName:_fileName,fileType:_fileType,date:_date, wasAdded:true});
                 }else{
                     //add the next file in place of the last deleted entry, last index has a +1 because the loop will subtract 1 extra on its last loop
                     files[msg.sender][lastIndex+1]=File({id:tokenId, hash:_hash,fileName:_fileName,fileType:_fileType,date:_date, wasAdded:true});
                 }

            }else{
                //If there is no deletion detected push the file to the array
               files[msg.sender].push(File({id: tokenId,hash:_hash,fileName:_fileName,fileType:_fileType,date:_date, wasAdded:true})); 
            }
       }
    }

    function transferRGBY(uint _index, uint _tokenId, address _to) public {

        require(_isApprovedOrOwner(msg.sender, _tokenId), "Only Approved or Owner can transfer this token");
        _transfer(msg.sender, _to, _tokenId);

        File memory transferFile = files[msg.sender][_index];

        //First file ever added to the drive
        if (files[_to].length == 0){
            files[_to].push(transferFile);
        }else{
            //any other add after the first
            uint lastIndex = files[_to].length; 
            File memory lastEntry = files[_to][lastIndex-1]; 
            //check for a deletion in the last entry of the array
            if(!lastEntry.wasAdded){
                //if a deletion is detected, cycle back until a record is found or the second entry is reached
                while((!lastEntry.wasAdded) && lastIndex>=1){
                    lastEntry = files[_to][lastIndex-1];
                    lastIndex--;
                 }
                 //in case all files were deleted, add the new file in the first position
                 if(lastIndex == 0 && (!files[owner][0].wasAdded)){
                     files[_to][0]=transferFile;
                 }else{
                     //add the next file in place of the last deleted entry, last index has a +1 because the loop will subtract 1 extra on its last loop
                     files[_to][lastIndex+1]=transferFile;
                 }

            }else{
                //If there is no deletion detected push the file to the array
               files[_to].push(transferFile); 
            }
       }
       _removeFile(_index, files[msg.sender].length);
    } 

    //if needed swaps last entry with file target for removal then deletes last entry
    function _removeFile(uint _index, uint _arrayLength) internal{
        uint lastElement = _arrayLength-1;
        if(_index != lastElement){
            files[msg.sender][_index] = files[msg.sender][lastElement];
        }
        delete files[msg.sender][lastElement];
    }

    //we need this getter as we just cannot loop through the mapped array
    function getFile(uint _index) public view returns(File memory){
        return files[msg.sender][_index];
    }

    //we need the length of each array in order to properly loop trough each of them
    function getLength() public view returns(uint){
        return files[msg.sender].length;
    }
    
    
    //common room 
     //we need this getter as we just cannot loop through the mapped array
    function getMarketFile(uint _index) public view returns(File memory){
        return files[owner][_index];
    }
    //we need the length of each array in order to properly loop trough each of them
    function getMarketLength() public view returns(uint){
        return files[owner].length;
    }

}


  



