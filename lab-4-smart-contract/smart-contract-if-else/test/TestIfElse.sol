pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/IfElse.sol";

contract TestIfElse {
    // The address of the ifElse contract to be tested
    IfElse ifElse = IfElse(DeployedAddresses.IfElse());

    // Testing the adopt() function
    function testIfElse() public {
        Assert.equal(ifElse.foo(7), 0, "IfElse result");
    }

    
}
