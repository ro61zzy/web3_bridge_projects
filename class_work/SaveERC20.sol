// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Importing the IERC20 interface from OpenZeppelin, which defines the standard functions for interacting with an ERC-20 token
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

// This contract allows users to deposit, withdraw, and transfer ERC-20 tokens within the contract
contract SaveERC20 {
    // State variable to store the owner of the contract
    address owner;

    // State variable to store the address of the ERC-20 token that this contract interacts with
    address tokenAddress;

    // A mapping to keep track of each user's balance of deposited tokens
    mapping(address => uint256) balances;

    // Event emitted when a deposit is successful
    event DepositSuccessful(address indexed user, uint256 indexed amount);

    // Event emitted when a withdrawal is successful
    event WithdrawalSuccessful(address indexed user, uint256 indexed amount);

    // Event emitted when a transfer between users is successful
    event TransferSuccessful(address indexed from, address indexed _to, uint256 indexed amount);

    // Constructor function to initialize the contract
    constructor(address _tokenAddress) {
        // Set the owner to the address that deployed the contract
        owner = msg.sender;

        // Set the token address to the address provided during deployment
        tokenAddress = _tokenAddress;
    }

    // Modifier that restricts access to certain functions to only the owner of the contract
    modifier onlyOwner() {
        // Check if the caller is the owner
        require(owner == msg.sender, "not owner");
        _;
    }

    // Function to allow users to deposit tokens into the contract
    function deposit(uint256 _amount) external {
        // Ensure that the caller's address is not the zero address (which is an invalid address)
        require(msg.sender != address(0), "zero address detected");

        // Ensure that the deposit amount is greater than zero
        require(_amount > 0, "can't deposit zero");

        // Get the caller's token balance from the ERC-20 contract
        uint256 _userTokenBalance = IERC20(tokenAddress).balanceOf(msg.sender);

        // Ensure that the caller has enough tokens to deposit
        require(_userTokenBalance >= _amount, "insufficient amount");

        // Transfer the tokens from the caller's address to this contract
        IERC20(tokenAddress).transferFrom(msg.sender, address(this), _amount);

        // Update the caller's balance in the contract
        balances[msg.sender] += _amount;

        // Emit an event indicating that the deposit was successful
        emit DepositSuccessful(msg.sender, _amount);
    }

    // Function to allow users to withdraw their tokens from the contract
    function withdraw(uint256 _amount) external {
        // Ensure that the caller's address is not the zero address
        require(msg.sender != address(0), "zero address detected");

        // Ensure that the withdrawal amount is greater than zero
        require(_amount > 0, "can't withdraw zero");

        // Get the caller's balance of deposited tokens in the contract
        uint256 _userBalance = balances[msg.sender];

        // Ensure that the caller has enough tokens to withdraw
        require(_amount <= _userBalance, "insufficient amount");

        // Update the caller's balance in the contract
        balances[msg.sender] -= _amount;

        // Transfer the tokens from the contract to the caller's address
        IERC20(tokenAddress).transfer(msg.sender, _amount);

        // Emit an event indicating that the withdrawal was successful
        emit WithdrawalSuccessful(msg.sender, _amount);
    }

    // Function to allow users to check their balance of deposited tokens
    function myBalance() external view returns(uint256) {
        // Return the balance of the caller
        return balances[msg.sender];
    }

    // Function to allow the owner to check the balance of any user
    function getAnyBalance(address _user) external view onlyOwner returns(uint256) {
        // Return the balance of the specified user
        return balances[_user];
    }

    // Function to allow the owner to check the total balance of tokens held by the contract
    function getContractBalance() external view onlyOwner returns(uint256) {
        // Return the contract's balance of tokens
        return IERC20(tokenAddress).balanceOf(address(this));
    }

    // Function to allow users to transfer their deposited tokens to another user
    function transferFunds(address _to, uint256 _amount) external {
        // Ensure that the caller's address is not the zero address
        require(msg.sender != address(0), "zero address detected");

        // Ensure that the recipient's address is not the zero address
        require(_to != address(0), "can't send to zero address");

        // Ensure that the caller has enough tokens to transfer
        require(balances[msg.sender] >= _amount, "Insufficient funds!");

        // Update the caller's balance in the contract
        balances[msg.sender] -= _amount;

        // Transfer the tokens from the contract to the recipient's address
        IERC20(tokenAddress).transfer(_to, _amount);

        // Emit an event indicating that the transfer was successful
        emit TransferSuccessful(msg.sender, _to, _amount);
    }

    // Function to allow a user to transfer some of their deposited tokens to another user's balance within the contract
    function depositForAnotherUserFromWithin(address _user, uint256 _amount) external {
        // Ensure that the caller's address is not the zero address
        require(msg.sender != address(0), "zero address detected");

        // Ensure that the recipient's address is not the zero address
        require(_user != address(0), "can't send to zero address");

        // Ensure that the caller has enough tokens deposited in the contract
        require(balances[msg.sender] >= _amount, "insufficient amount");

        // Update the caller's balance in the contract
        balances[msg.sender] -= _amount;

        // Update the recipient's balance in the contract
        balances[_user] += _amount;
    }

    // Function to allow a user to directly deposit tokens into another user's balance in the contract
    function depositForAnotherUser(address _user, uint256 _amount) external {
        // Ensure that the caller's address is not the zero address
        require(msg.sender != address(0), "zero address detected");

        // Ensure that the recipient's address is not the zero address
        require(_user != address(0), "can't send to zero address");

        // Get the caller's token balance from the ERC-20 contract
        uint256 _userTokenBalance = IERC20(tokenAddress).balanceOf(msg.sender);

        // Ensure that the caller has enough tokens to deposit
        require(_userTokenBalance >= _amount, "insufficient amount");

        // Transfer the tokens from the caller's address to this contract
        IERC20(tokenAddress).transferFrom(msg.sender, address(this), _amount);

        // Update the recipient's balance in the contract
        balances[_user] += _amount;
    }

    // Function to allow the owner to withdraw tokens from the contract
    function ownerWithdraw(uint256 _amount) external onlyOwner {
        // Ensure that the contract has enough tokens to cover the withdrawal amount
        require(IERC20(tokenAddress).balanceOf(address(this)) >= _amount, "insufficient funds");

        // Transfer the tokens from the contract to the owner's address
        IERC20(tokenAddress).transfer(owner, _amount);
    }
}
