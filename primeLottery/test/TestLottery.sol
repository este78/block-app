pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Lottery.sol";

contract TestLottery {
    // The address of the lottery contract to be tested
    Lottery lottery = Lottery(DeployedAddresses.Lottery());
    
    function testLoop() public {
        Assert.equal(lottery.factorial(5), 625, "Loop result");
    }
    function testIsPrime() public {
      Assert.equal(lottery.isPrime(13), true, "Lottery result");   
    }
    
}