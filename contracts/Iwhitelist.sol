// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


 interface Iwhitelist {
     function whitelistAddress(address) external view returns(bool);
 }