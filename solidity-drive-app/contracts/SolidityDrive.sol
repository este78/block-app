pragma solidity ^0.8.0;


contract SolidityDrive{

    struct File{
        string hash;
        string fileName;
        string fileType;
        uint date;
        bool wasAdded;
    }
    mapping(address=>File[]) files;

    function add(string memory _hash, string memory _fileName, string memory _fileType, uint _date) public{
       //First file ever added
        if (files[msg.sender].length == 0){
            files[msg.sender].push(File({hash:_hash,fileName:_fileName,fileType:_fileType,date:_date, wasAdded:true}));
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
                     files[msg.sender][0]=File({hash:_hash,fileName:_fileName,fileType:_fileType,date:_date, wasAdded:true});
                 }else{
                     //add the next file in place of the last deleted entry, last index has a +1 because the loop will subtract 1 extra on its last loop
                     files[msg.sender][lastIndex+1]=File({hash:_hash,fileName:_fileName,fileType:_fileType,date:_date, wasAdded:true});
                 }

            }else{
                //If there is no deletion detected push the file to the array
               files[msg.sender].push(File({hash:_hash,fileName:_fileName,fileType:_fileType,date:_date, wasAdded:true})); 
            }
       }
        
    }

    //if needed swaps last entry with file target for removal then deletes last entry
    function removeFile(uint _index, uint _arrayLength) public{
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
}