pragma solidity ^0.5.0;

contract Loop {
    function factorial(uint x) public pure returns (uint) {
        uint ans = x;
        
        for (uint i = 0; i < 10; i++) {
            ans = ans + 5;
        }

        return ans;
    }
}
