// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SavingsDAO {
    mapping(address => uint) public savings;
    uint public totalSavings;
    uint public savingsPercentage; // Porcentaje a retener por cada transacción (0-100)

    event SavingsDeposited(address indexed user, uint amount);
    event SavingsWithdrawn(address indexed user, uint amount);

    constructor(uint _savingsPercentage) {
        require(_savingsPercentage <= 100, "El porcentaje debe estar entre 0 y 100");
        savingsPercentage = _savingsPercentage;
    }

    function depositSavings(uint amount) public payable {
        require(amount > 0, "El monto debe ser mayor a 0");
        require(msg.value == amount, "El monto depositado debe ser igual al valor enviado");

        uint savingsAmount = (amount * savingsPercentage) / 100;
        savings[msg.sender] += savingsAmount;
        totalSavings += savingsAmount;

        emit SavingsDeposited(msg.sender, savingsAmount);
    }

    function withdrawSavings() public {
        uint amount = savings[msg.sender];
        require(amount > 0, "No tienes ahorros disponibles para retirar");
        require(address(this).balance >= amount, "Saldo insuficiente en el contrato");

        // Actualiza el saldo del usuario antes de la transferencia para evitar reentradas
        savings[msg.sender] = 0;
        totalSavings -= amount;

        payable(msg.sender).transfer(amount);

        emit SavingsWithdrawn(msg.sender, amount);
    }

    function getSavings(address user) public view returns (uint) {
        return savings[user];
    }

    function getTotalSavings() public view returns (uint) {
        return totalSavings;
    }

    // Función para recibir Ether en el contrato
    receive() external payable {}
}
