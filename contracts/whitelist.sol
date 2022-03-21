// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Whitelist {
    event whitelistLog(address, string);
    uint maxWhitelistAddress = 3;
    uint public currentlyWhitelisted;
    mapping(address => bool) public  whitelistAddress;

 
 function addToWhitelist() public {
   require(!whitelistAddress[msg.sender], "Address already whitelisted");
   require(currentlyWhitelisted < maxWhitelistAddress, "Whitelist full");
   whitelistAddress[msg.sender] = true;
   currentlyWhitelisted++;
   emit whitelistLog(msg.sender, "Added to whitelist");
 }

 function getAddressStatus() public view returns(bool){
   return whitelistAddress[msg.sender];
 }
}
