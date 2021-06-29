pragma solidity ^0.5.0;

contract IfElse {
    function foo(uint x) public pure returns (uint) {
        if (x < 18) {
            return 0;
        } else {
            return 1;
        }
    }
}