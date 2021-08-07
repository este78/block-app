pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/MathsQuestion.sol";

contract TestMathsQuestion {
    MathsQuestion mathsQuestion = MathsQuestion(DeployedAddresses.MathsQuestion());

    function testComputeProduct() public {
        uint size = 4;
        uint[] memory inputs = new uint[](size);
        uint[] memory results = new uint[](size);
        inputs[0] = 3;
        results[0] = 6;

        inputs[1] = 6;
        results[1] = 720;

        inputs[2] = 0;
        results[2] = 0;
        
        inputs[3] = 4;
        results[3] = 24;

        for(uint i = 0; i < size; i++) {
            uint returnedResult = mathsQuestion.computeProduct(inputs[i]);
            Assert.equal(returnedResult, results[i], "Maths Question result");
        }    
        
    }
    

    function testComputeProductOf5() public {
        uint returnedResult = mathsQuestion.computeProduct(5);
        Assert.equal(returnedResult, 120, "Maths Question result");
    }


    function testComputeProductOf7() public {
        uint returnedResult = mathsQuestion.computeProduct(7);
        Assert.equal(returnedResult, 5040, "Maths Question result");
    }

}
