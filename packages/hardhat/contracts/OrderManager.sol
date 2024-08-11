// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./FoodOrder.sol";

contract OrderManager {
    address public owner;
    mapping(uint => address) public orders;
    uint public orderCount;

    event NewOrderCreated(address indexed customer, address orderAddress);

    constructor() {
        owner = msg.sender;
        orderCount = 0;
    }

    function createOrder(
        string memory _restaurantName,
        string[] memory _dishes,
        uint _totalPrice,
        string memory _deliveryAddress
    ) public {
        // Crear una nueva instancia de FoodOrder y almacenar su dirección
        FoodOrder newOrder = new FoodOrder(_restaurantName, _dishes, _totalPrice, _deliveryAddress);
        orders[orderCount] = address(newOrder);
        orderCount++;

        emit NewOrderCreated(msg.sender, address(newOrder));
    }

    function getOrderStatus(uint _orderId) public view returns (FoodOrder.OrderStatus) {
        address orderAddress = orders[_orderId];
        require(orderAddress != address(0), "Pedido no encontrado");
        FoodOrder order = FoodOrder(orderAddress);
        return order.getOrderStatus();
    }

    function acceptOrder(uint _orderId, address _deliveryPerson) public {
        address orderAddress = orders[_orderId];
        require(orderAddress != address(0), "Pedido no encontrado");
        FoodOrder(orderAddress).acceptOrder(_deliveryPerson);
    }

    function markOrderAsDelivered(uint _orderId) public {
        address orderAddress = orders[_orderId];
        require(orderAddress != address(0), "Pedido no encontrado");
        FoodOrder(orderAddress).markAsDelivered();
    }
}
