// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Iwhitelist.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";


contract NftContract is ERC721Enumerable , Ownable {
   
   Iwhitelist whitelist;
   uint maxNFTSupply = 10;
   uint nftTokenId;
   bool presaleStarted;
   uint presaleEnded;
   string baseUrl;

   uint NFTPrice = 0.002 ether;
   
   constructor(string memory _baseUrl, address _whitelistAddress) ERC721("Mutant Apes", "MA"){
        whitelist = Iwhitelist(_whitelistAddress);
        baseUrl = _baseUrl;
   }

   function startPresale() public onlyOwner {
       presaleStarted = true;
       presaleEnded = block.timestamp + 5 minutes;
   }

   function presaleMint() public payable {
       require(whitelist.whitelistAddress(msg.sender), "Address not whitelisted");
       require(presaleStarted && presaleEnded > block.timestamp, "Presale not running");
       require(nftTokenId < maxNFTSupply, "Mutant Apes sold out");
       require(msg.value >= NFTPrice, "Insufficient funds");
       nftTokenId++;
       _safeMint(msg.sender, nftTokenId);
   }



   function postsaleMint() public payable {
       require(presaleStarted && presaleEnded <= block.timestamp, "Presale still running or has'nt started");
       require(nftTokenId < maxNFTSupply, "Mutant Apes sold out");
       require(msg.value >= NFTPrice, "Insufficient funds");
       nftTokenId++;
       _safeMint(msg.sender, nftTokenId);
   }

   function withdrawFunds() public onlyOwner {
       (bool sent,) = owner().call{ value: address(this).balance }("");
       require(sent, "Funds Approved");
   }

   function _baseURI() internal view virtual override returns(string memory){
       return baseUrl;
   }

   function viewContractBalance() public view returns(uint){
       return address(this).balance;
   }
  
   fallback() external payable {}
   receive() external payable {}

}