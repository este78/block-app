pragma solidity ^0.5.0;

contract Factorial {
    function factorial(uint x) public pure returns (uint) {
        if(x == 1){
            return 1;
        }
        else{
            return (factorial(x-1) * x);
        }
    }
}