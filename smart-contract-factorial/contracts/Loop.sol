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
}
