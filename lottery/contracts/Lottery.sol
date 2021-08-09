pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

contract Lottery{
   address payable owner;
   uint private initialFund;
   
   constructor () payable public{
       require(msg.value >= 500 finney, "Initial funds required");
       owner = tx.origin;
       initialFund = msg.value;
       address(this).transfer(msg.value);
   }
   //restricts the execution of certain functions to the owner of the contract 
   modifier onlyOwner {
       require(tx.origin == owner, "Only the owner has access to this feature");
       _;
   }
   
/*===================================================================================================================*/
// LOTTERY GOVERNANCE
/*===================================================================================================================*/
   
   //Required to send ethereum to a contract's address
    function () external payable{
    }
    
    //get balance of money in lottery account
    function getBalance() public view onlyOwner returns (uint){
        return address(this).balance;
    }

    //Transfer any profits to the contract owner
    function withdraw() public onlyOwner {
        require(address(this).balance > initialFund, "there are no funds in the contract's account");
        owner.transfer(address(this).balance - initialFund);
    }
    
    //Transfer any and all ether to the owner
    function withdrawAll() public onlyOwner {
        require(address(this).balance > 0, "there are no funds in the contract's account");
        owner.transfer(address(this).balance);
    }
    
    //pay ether to the lottery
    function addFunds() payable public onlyOwner {
        require(msg.value >= 10 finney, "You must add 10 finney or more to the contract account");
    }
    
/*===================================================================================================================*/
// LOTTERY FUNCTIONALLITY
/*===================================================================================================================*/
    uint public drawIndex = 0;
    mapping (uint => Draw) public draws;

    struct Draw{
        uint id;
        uint256 number;
        bool winner;
        address player;
    }

    event DrawCreated(
     uint256 numDrawed,
     bool winner,
     address player
    );

   //Player draw a number  
   function tryYourLuck() payable public {
       //conditions
       require(msg.value == 10 finney, "You need to pay 10 finney to play");
       require(address(this).balance >= 30 finney, "Lottery machine has no funds");
       //2 function calls for the draw (draw number, chack if winner)
       uint myNumber = rand();
       bool winner = isPrime(myNumber);
       // transfer ether if winner
       if (winner){
           msg.sender.transfer(30 finney);
       }
       //Log the draw in a mapping 
       draws[drawIndex] = Draw(drawIndex, myNumber, winner, msg.sender);
       drawIndex++;
       emit DrawCreated(myNumber, winner, msg.sender);
   }
  
  
   //pseudo-random number generator. Source: https://stackoverflow.com/questions/58188832/solidity-generate-unpredictable-random-number-that-does-not-depend-on-input
   function rand() public view  returns(uint256) {
        uint256 seed = uint256(keccak256(abi.encodePacked(
            block.timestamp + block.difficulty +
            ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (block.timestamp)) +
            block.gaslimit + 
            ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (block.timestamp)) +
            block.number
        )));
        //Draw numbers 1-100 (there are 25 prime numbers, chance of winning 1/4)
        return ((seed - ((seed / 100) * 100))+1);
    }

   //only prime numbers get a prize. Adapted from: https://stackoverflow.com/questions/40200089/number-prime-test-in-javascript
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
    //get all draws, used for display
    function getAllDraws() public view returns (Draw[] memory){
        Draw[] memory _draws = new Draw[](drawIndex);
        for (uint i = 0; i < drawIndex; i++) {
            _draws[i] = draws[i];
        }
        return _draws;
    }
}