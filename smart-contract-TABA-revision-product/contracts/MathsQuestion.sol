pragma solidity ^0.5.0;

// In Mathematics there is an operation call the product this refers to the multiplication of a number of numbers.
// 0
// Given a number compute the product of 1 through that number N calculating the product of all numbers between 1 and n where n is inclusive where n is supplied to the smart contract where n > 0.

contract MathsQuestion {
    
    function computeProduct(uint n) public pure returns (uint) {
        uint product = 0;
        if(n < 1) {
            return product;
        } else {
            product = 1;
            for (uint i = 1; i <= n; i++) {
                product = product * i;
            }
            return product;
        }
    }

}
// 1*2*3 = 6