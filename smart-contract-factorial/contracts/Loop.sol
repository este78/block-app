pragma solidity ^0.5.0;

contract Loop {
    function factorial(uint x) public pure returns (uint) {
        uint ans = x;
        // for loop
        for (uint i = x-1; i > 1; i--) {
            ans = x * ans;
        }

        return ans;
    }
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
