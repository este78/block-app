pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/HelloWorld.sol";

contract TestHelloWorld {
    // The address of the helloworld contract to be tested
    HelloWorld helloworld = HelloWorld(DeployedAddresses.HelloWorld());

    // Testing the adopt() function
    function testHelloWorld() public {
        string memory returnedResult = helloworld.helloWorld("Josh");
        Assert.equal(returnedResult, "Hello Josh", "HelloWorld result");
    }

    
}
