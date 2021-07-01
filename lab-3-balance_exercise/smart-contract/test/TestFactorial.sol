pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Factorial.sol";

contract TestFactorial {
    // The address of the ifElse contract to be tested
    Factorial factorial = Factorial(DeployedAddresses.Factorial());

    // Testing the adopt() function
    function testFactorial() public {
        Assert.equal(factorial.factorial(5), 120, "IfElse result");
    }
 
    
}