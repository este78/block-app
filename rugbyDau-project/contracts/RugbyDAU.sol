// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract RugbyDAU is ERC721Enumerable{

  string [] public colors;
  mapping(string => bool) public _colorExists;
 
  constructor() ERC721("RugbyDAU", "RGBY"){
  }

  function mint(string memory _color) public{
    //does the color already exists?
    require(!_colorExists[_color]);
    //append new color to array
    colors.push(_color);
    //get the new entry's index 
    uint _id = colors.length - 1;
    //mint token with color entered
    _mint(msg.sender, _id);
    //map this color so it won't repeat
    _colorExists[_color] = true;
  }

}
