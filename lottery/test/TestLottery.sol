pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Lottery.sol";

contract TestLottery {
    // The address of the lottery contract to be tested
    Lottery lottery = Lottery(DeployedAddresses.Lottery());
    
    function testPush() public{
        lottery.addScore(4);
        lottery.addScore(5);
        Assert.equal(lottery.getlength(),(2), "Lottery result");  
    }
    function testClear() public{
        lottery.clearArray();
        Assert.equal(lottery.getlength(),(0), "Lottery result");  
    }
    function testIsPrime() public {
      Assert.equal(lottery.isPrime(13), true, "Lottery result");   
    }
    
}