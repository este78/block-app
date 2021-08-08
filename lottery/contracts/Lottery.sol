pragma solidity ^0.5.0;

contract Lottery{
   address payable owner;
   mapping (uint => uint) public draws;
   
   uint256 private initialFund = 500000000000000000000;
   
   event Log(uint256 random);
   
   constructor () payable public{
       owner = msg.sender;
       address(this).transfer(msg.value);
   }
   
/*===================================================================================================================*/
// LOTTERY GOVERNANCE
/*===================================================================================================================*/
   
   //Required to send ethereum to a contract's address
    function () external payable{
    }
    
    //get balance of money in lottery account
    function getBalance() public view returns (uint){
        require(msg.sender == owner, "Only the owner may access the contract's balance");
        return address(this).balance;
    }

    //Transfer any profits to the contract owner
    function withdraw() public {
        require(msg.sender == owner, "you do not have permission to withdraw funds");
        require(address(this).balance > initialFund, "there are no funds in the contract's account");
        owner.transfer(address(this).balance - initialFund);
    }
    
    //Transfer any and all ether to the owner
    function withdrawAll() public {
        require(msg.sender == owner, "you do not have permission to withdraw funds");
        require(address(this).balance > 0, "there are no funds in the contract's account");
        owner.transfer(address(this).balance);
    }
    
    //pay ether to the lottery
    function addFunds() payable public {
        require(msg.sender == owner, "Only the owner may add funds");
        address(this).transfer(msg.value);
    }
    
/*===================================================================================================================*/
// LOTTERY FUNCTIONALLITY
/*===================================================================================================================*/
   //Player draw a number  
   function tryYourLuck() payable public {
       require(msg.value == 1 ether, "You need to pay 1 ether to play");
       require(address(this).balance > 3 ether, "Machine has no funds");
       uint myNumber = rand();
       if (isPrime(myNumber)){
           msg.sender.transfer(3000000000000000000);
       }
       emit Log(myNumber);
   }
  
  
   //pseudo-random number generator
   function rand() public view  returns(uint256) {
        uint256 seed = uint256(keccak256(abi.encodePacked(
            block.timestamp + block.difficulty +
            ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (block.timestamp)) +
            block.gaslimit + 
            ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (block.timestamp)) +
            block.number
        )));
    
        return (seed - ((seed / 100) * 100));
    }

   //only prime numbers get a prize
    function isPrime(uint256 _numberDrawed) pure public returns(bool){
        uint256 num = _numberDrawed;
        uint256 index = 2;
        while(index < num){
            if(num % index == 0 ){
                return false;
            }
            index++;
        } 
        return num > 1;
    }
}