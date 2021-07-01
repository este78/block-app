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
    // Testing the adopt() function
    function testIfElse1() public {
        Assert.equal(ifElse.foo(11), 1, "IfElse result");
    }
    // Testing the adopt() function
    function testIfElse2() public {
        Assert.equal(ifElse.foo(50), 2, "IfElse result");
    }
    
}
