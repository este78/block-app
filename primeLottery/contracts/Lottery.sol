pragma solidity ^0.5.0;

contract Lottery {
  function isPrime(uint256 _numberDrawed) pure public returns(bool){
        uint256 numberDrawed = _numberDrawed;
        for(uint i = 2; i < numberDrawed; i++){
            if(numberDrawed % i == 0 ){
                return false;
            }
            return numberDrawed > 1;
        }
    }
}