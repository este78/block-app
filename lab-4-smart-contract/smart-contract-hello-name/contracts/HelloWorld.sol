pragma solidity ^0.5.0;

contract HelloWorld {
     
    function helloWorld(string memory name) public returns (string memory) {
        return string(abi.encodePacked("Hello"," ",name));
    }

}