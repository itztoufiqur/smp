// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";

contract ParticipationToken is ERC20, ERC20Burnable, ERC20Pausable, Ownable {
    // Mapping to keep track of student participation
    mapping(address => uint256) public participationTokens;

    // Event emitted when tokens are awarded
    event TokensAwarded(address indexed student, uint256 amount);

    // Event emitted when tokens are redeemed
    event TokensRedeemed(address indexed student, uint256 amount);

    // Constructor to set the token name and symbol
    constructor() ERC20("ParticipationToken", "PTK") {
        // Mint some initial tokens for the contract owner
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    // Function to award tokens to a student
    function awardTokens(address student, uint256 amount) external onlyOwner whenNotPaused {
        require(amount > 0, "Amount must be greater than 0");

        // Award tokens
        _mint(student, amount);
        participationTokens[student] += amount;

        emit TokensAwarded(student, amount);
    }

    // Function for students to redeem tokens for rewards
    function redeemTokens(uint256 amount) external whenNotPaused {
        require(balanceOf(msg.sender) >= amount, "Insufficient token balance");
        require(amount > 0, "Amount must be greater than 0");

        // Burn tokens instead of transferring to another address
        _burn(msg.sender, amount);
        participationTokens[msg.sender] -= amount;

        // Emit event
        emit TokensRedeemed(msg.sender, amount);

        // Implement reward logic here, e.g., issuing vouchers or extra credit
    }

    // Pausing functions to temporarily disable awarding or redeeming
    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}
