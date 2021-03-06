pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Lottery.sol";

contract TestLottery {
    // The address of the lottery contract to be tested
    Lottery lottery = Lottery(DeployedAddresses.Lottery());
    function testConstructor() public{
      Assert.equal(lottery.lotteryTokens, 1000000, "Lottery result");
    }
    function testIsPrime() public {
      Assert.equal(lottery.isPrime(13), true, "Lottery result");   
    }
    
}