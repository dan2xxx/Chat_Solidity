// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
/// @title Voting with delegation.
import 'openzeppelin-solidity/contracts/access/Ownable.sol';


interface ERC20 {
     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
     function transfer(address recipient, uint256 amount) external returns (bool);
     function balanceOf(address account) external view returns (uint256);
     function burn(uint256 amount) external returns (bool);
     function burnFrom(address account, uint256 amount) external;
}

contract Chat2 is Ownable{

  struct Premium {
    string name;
    uint finishTime;
  }

  
  //ERC20 public CHTT = ERC20(0x23489422cE5bf94ED42b42248cd04246c64d8719); 
    ERC20 public CHTT = ERC20(0x84f00c47FDf071f5BB65bA8F9fF1418e32e529a6);


  mapping(address => Premium) public premiumUsers;
  uint public price = 120;
  
  //events
  event NewMessage(address sender, string name, string message, uint timestamp);
  
  
  
  function addMessage (string memory _message) public returns(bool) {
      
      
      if (premiumUsers[msg.sender].finishTime > block.timestamp) {
          emit NewMessage(msg.sender, premiumUsers[msg.sender].name, _message, block.timestamp);
      } else {
          emit NewMessage(msg.sender, '', _message, block.timestamp);
      }
      
      
      return true;
  }
  
  
  function register(string memory _name, uint  _amount, address _address) public returns(bool) {
     
      require(_amount / 1000000000000000000 >= 1, "min 1 token");
      uint _duration = _amount * price / 1000000000000000000;
      
      CHTT.transferFrom(msg.sender, address(this), _amount / 10 * 9);
      CHTT.burnFrom(msg.sender, _amount / 10);
      
    
    Premium memory currentUser = premiumUsers[_address];
    

      if (currentUser.finishTime < block.timestamp) {
          currentUser.name = _name;
          currentUser.finishTime = block.timestamp + _duration;
      } else {
          currentUser.name = _name;
          currentUser.finishTime = currentUser.finishTime + _duration;
      }
      
      premiumUsers[_address] = currentUser;
 
      return true;
    }
    
   function withdrawFunds(uint _amount) public onlyOwner returns (bool) {
  
       require(_amount <= CHTT.balanceOf(address(this)), "not enough tokens");
       CHTT.transfer(owner(), _amount);
   }
   
   function changePrice (uint _price) public onlyOwner {
       price = _price;
   }
    
}