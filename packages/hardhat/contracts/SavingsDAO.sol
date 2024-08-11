// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SavingsDAO {
    mapping(address => uint) public savings;
    uint public totalSavings;
    uint public savingsPercentage; // Porcentaje a retener por cada transacción

    event SavingsDeposited(address indexed use r, uint amount);
    event SavingsWithdrawn(address indexed user, uint amount);

    constructor(uint _savingsPercentage) {
        savingsPercentage = _savingsPercentage;
    }

    function depositSavings(uint amount) public {
        uint savingsAmount = (amount * savingsPercentage) / 100;
        savings[msg.sender] += savingsAmount;
        totalSavings += savingsAmount;

        emit SavingsDeposited(msg.sender, savingsAmount);
    }

    function withdrawSavings() public {
        uint amount = savings[msg.sender];
        require(amount > 0, "No tienes ahorros disponibles para retirar");

        savings[msg.sender] = 0;
        totalSavings -= amount;

        payable(msg.sender).transfer(amount);

        emit SavingsWithdrawn(msg.sender, amount);
    }

    function getSavings(address user) public view returns (uint) {
        return savings[user];
    }
}
