// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FoodOrder {
    address public customer;
    address public restaurant;
    address public deliveryPerson;

    string public restaurantName;
    string[] public dishes;
    uint256 public totalPrice;
    string public deliveryAddress;
    
    enum OrderStatus { Placed, Accepted, Prepared, Collected, Delivered }
    OrderStatus public status;

    event OrderPlaced(address indexed customer, string[] dishes, uint256 totalPrice);
    event OrderAccepted(address indexed deliveryPerson);
    event OrderDelivered(address indexed customer);

    modifier onlyCustomer() {
        require(msg.sender == customer, "Solo el cliente puede ejecutar esta acción");
        _;
    }

    modifier onlyDeliveryPerson() {
        require(msg.sender == deliveryPerson, "Solo el repartidor puede ejecutar esta acción");
        _;
    }

    constructor(
        string memory _restaurantName,
        string[] memory _dishes,
        uint256 _totalPrice,
        string memory _deliveryAddress
    ) {
        require(bytes(_restaurantName).length > 0, "Nombre del restaurante es requerido");
        require(_dishes.length > 0, "Debe haber al menos un plato");
        require(_totalPrice > 0, "El precio total debe ser mayor a cero");
        require(bytes(_deliveryAddress).length > 0, "La dirección de entrega es requerida");

        customer = msg.sender;
        restaurantName = _restaurantName;
        dishes = _dishes;
        totalPrice = _totalPrice;
        deliveryAddress = _deliveryAddress;
        status = OrderStatus.Placed;

        emit OrderPlaced(customer, dishes, totalPrice);
    }

    function acceptOrder(address _deliveryPerson) public onlyCustomer {
        require(status == OrderStatus.Placed, "El pedido ya ha sido aceptado");
        deliveryPerson = _deliveryPerson;
        status = OrderStatus.Accepted;

        emit OrderAccepted(deliveryPerson);
    }

    function markAsDelivered() public onlyDeliveryPerson {
        require(status == OrderStatus.Accepted, "El pedido debe estar aceptado para ser entregado");
        status = OrderStatus.Delivered;

        emit OrderDelivered(customer);
    }
}
