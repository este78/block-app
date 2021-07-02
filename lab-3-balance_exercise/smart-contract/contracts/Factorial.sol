pragma solidity ^0.5.0;

contract Factorial{
    function fact(uint x) public pure returns (uint) {
        if (x <= 1) {
            return 1;
        }
        else{
            return (x * fact(x-1));
        }       
    }
}