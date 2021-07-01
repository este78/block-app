pragma solidity ^0.5.0;

contract IfElse {
    function foo(uint x) public pure returns (uint) {
        if (x < 10) {
            return 0;
        } 
        if (x < 20){
            return 1;
        }
        else {
            return 2;
        }
    }
}