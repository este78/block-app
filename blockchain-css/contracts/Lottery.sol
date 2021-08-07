pragma solidity ^0.5.0;

contract Lottery {
    function factorial(uint x) public pure returns (uint) {
        uint ans = x;
        // for loop
        for (uint i = x-1; i > 1; i--) {
            ans = x * ans;
        }

        return ans;
    }
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