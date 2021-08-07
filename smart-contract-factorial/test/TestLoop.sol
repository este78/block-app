pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Loop.sol";

contract TestLoop {
    // The address of the loop contract to be tested
    Loop loop = Loop(DeployedAddresses.Loop());

    function testLoop() public {
        Assert.equal(loop.factorial(5), 625, "Loop result");
    }
      function testIsPrime() public {
        Assert.equal(loop.isPrime(13), true, "Loop result");   
    }
    
}
