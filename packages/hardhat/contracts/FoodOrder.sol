// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FoodOrder {
    address public customer;
    address public restaurant;
    address public deliveryPerson;

    string public restaurantName;
    string[] public dishes;
    uint public totalPrice;
    string public deliveryAddress;
    enum OrderStatus { Placed, Accepted, Prepared, Collected, Delivered }
    OrderStatus public status;

    event OrderPlaced(address indexed customer, string[] dishes, uint totalPrice);
    event OrderAccepted(address indexed deliveryPerson);
    event OrderDelivered(address indexed customer);

    constructor(
        string memory _restaurantName,
        string[] memory _dishes,
        uint _totalPrice,
        string memory _deliveryAddress
    ) {
        customer = msg.sender;
        restaurantName = _restaurantName;
        dishes = _dishes;
        totalPrice = _totalPrice;
        deliveryAddress = _deliveryAddress;
        status = OrderStatus.Placed;

        emit OrderPlaced(customer, dishes, totalPrice);
    }

    function acceptOrder(address _deliveryPerson) public {
        require(status == OrderStatus.Placed, "El pedido ya ha sido aceptado");
        deliveryPerson = _deliveryPerson;
        status = OrderStatus.Accepted;

        emit OrderAccepted(deliveryPerson);
    }

    function markAsDelivered() public {
        require(msg.sender == deliveryPerson, "Solo el repartidor puede marcar como entregado");
        status = OrderStatus.Delivered;

        emit OrderDelivered(customer);
    }

    // Agregada una función para obtener el estado del pedido
    function getOrderStatus() public view returns (OrderStatus) {
        return status;
    }
}
