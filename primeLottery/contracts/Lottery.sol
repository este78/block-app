pragma solidity ^0.5.0;

contract Lottery {

   address payable owner;

   constructor() payable{
       owner = payable(msg.sender);
   } 

   function deposit() public payable{
   }  

   // Function to transfer Ether from this contract to address from input
    function transfer(address payable _to) public {
        // Note that "to" is declared as payable
        (bool success,) = _to.call{value: 3 ether}("");
        require(success, "Failed to send Ether");
    }  
   
    function spin() public external{
        require(msg.value == 1 ether, "Price of a spin is 1 ether");
        require (address(this).balance > 5 ether, "Lottery machine has no funds");
        if( isPrime(rand()) ){
            transfer(msg.sender);
        }
    }

    //Source: https://stackoverflow.com/questions/58188832/solidity-generate-unpredictable-random-number-that-does-not-depend-on-input
    function rand() public view returns(uint256){
        uint256 seed = uint256(keccak256(abi.encodePacked(
            block.timestamp + block.difficulty +
            ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (block.timestamp)) +
            block.gaslimit + 
            ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (block.timestamp)) +
            block.number
        )));

        return (seed - ((seed / 100) * 100));
    }

    //source: https://stackoverflow.com/questions/40200089/number-prime-test-in-javascript
    function isPrime(uint256 _numberDrawed) pure public returns(bool){
        uint256 num = _numberDrawed;
        for(uint i = 2; i < num; i++){
            if(num % i == 0 ){
                return false;
            }
            return num > 1;
        }
    }
}