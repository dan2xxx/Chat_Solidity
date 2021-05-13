// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/extensions/ERC20Burnable.sol";




contract Token is ERC20, ERC20Burnable {

    constructor() public ERC20("ChatToken", "CHTT") {
        _mint(msg.sender, 1000000000000000000000000);
    }
    
    

   function mint(address to, uint256 amount) public virtual {
        _mint(to, amount);
    }
}

