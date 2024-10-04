// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RozzyToken is ERC20, Ownable {
    constructor(uint256 initialSupply) ERC20("Rozzy", "RZY") Ownable(msg.sender) {
        _mint(msg.sender, initialSupply);
    }

    // Function to allow the owner to mint more tokens if needed
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
