pragma solidity ^0.5.16;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SlotMachine.sol";

contract TestRNG {
    // The address of the loop contract to be tested
    SlotMachine round = SlotMachine(DeployedAddresses.SlotMachine());

    function testIsPrime() public {
        Assert.equal(round.isPrime(13), true, "Loop result");   
    }

    
}