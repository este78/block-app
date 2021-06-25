pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/StorageDemo.sol";

contract TestStorageDemo {
    // The address of the storageDemo contract to be tested
    StorageDemo storageDemo = StorageDemo(DeployedAddresses.StorageDemo());

    // Testing the adopt() function
    function testStorageDemo() public {
        storageDemo.set(1);
        Assert.equal(storageDemo.get(), 1, "StorageDemo result");
    }

    
}
