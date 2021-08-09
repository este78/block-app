pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Lottery.sol";

contract TestLottery {
    //Add some ether to the test contract to be used in the appropiate calls: no.2,
    uint public initialBalance = 500 finney;
    // The address of the lottery contract to be tested
    Lottery lottery = Lottery(DeployedAddresses.Lottery());
    
    //1 getthe ether balance of the contract
    function testGetBalance() public {
      Assert.equal(lottery.getBalance(), 500 finney, "Check contract balance");   
    }
    //2 transfer funds to the contract
	function testAddFunds() public{
        address(lottery).transfer(500 finney);
        Assert.equal(lottery.getBalance(), 1 ether, "Check contract balance after adding funds");
    }
    //3 Withdraw all the ether except the initial balance of the contract
    function testWithdrawFunds() public{
        Assert.equal(lottery.getBalance(), 1 ether, "Check contract balance before withdrawal");
        lottery.withdraw();
        Assert.equal(lottery.getBalance(), 500 finney, "Check contract balance after withdrawal");
    }
    //4 Test for the prime number testing algorithm
    function testIsPrime() public {
      Assert.equal(lottery.isPrime(1), false, "Lottery result");   
      Assert.equal(lottery.isPrime(2), true, "Lottery result");
      Assert.equal(lottery.isPrime(65), false, "Lottery result");
      Assert.equal(lottery.isPrime(13), true, "Lottery result");
    } 

    //5 Test for the withdraw all funds from the contract
    function testWithdrawAll() public {
      lottery.withdrawAll();
      Assert.equal(lottery.getBalance(), 0, "Withdraw all funds");   
    }
      
}