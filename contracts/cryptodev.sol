// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

interface InftCollection {
     function tokenOfOwnerByIndex(address owner, uint256 index) external view  returns (uint256);

    function balanceOf(address owner) external view  returns (uint256 balance);
}



contract TomiwaCoin is ERC20 {
    uint constant tokenPrice = 0.001 ether;
    uint pricePerNFT = 10 * 10**18;
    uint maxTotalSupply = 10000 * 10**18;
    InftCollection nftCollection;
    mapping(uint => bool) nftClaimed;

  constructor(address _nftAddress) ERC20("Tomiwa Coin", "TC"){
       nftCollection = InftCollection(_nftAddress);
  }

 function mint(uint _amount) public payable {
  uint calculatedAmount = _amount * tokenPrice;
  require(msg.value >= calculatedAmount, "Incorrect ether sent");
  uint convertedAmount = _amount * 10**18;
  require( (totalSupply() + convertedAmount) <= maxTotalSupply, "Maximum supply reached");
  _mint(msg.sender, convertedAmount);
 }

 function claimToken() public {
   address _connectedAddress = msg.sender;

   uint connectedAddressNFTBalance = nftCollection.balanceOf(_connectedAddress);

   require(connectedAddressNFTBalance > 0, "You do not have any Mutant Apes NFT");

   uint amount = 0;

   for(uint i=0; i < connectedAddressNFTBalance; i++){
       uint tokenId = nftCollection.tokenOfOwnerByIndex(_connectedAddress, i);
        if(!nftClaimed[tokenId]){
            nftClaimed[tokenId] = true;
            amount++;
        }
   }

   require(amount > 0, "You have claimed all your NFTs");

   _mint(msg.sender, amount * pricePerNFT);
 }

 function getNftBalance() public view returns(uint){
     return nftCollection.tokenOfOwnerByIndex(msg.sender, 0);
 }

 fallback() external payable {}
 receive() external payable {}

}