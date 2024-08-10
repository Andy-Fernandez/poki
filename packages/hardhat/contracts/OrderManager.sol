//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// // Useful for debugging. Remove when deploying to a live network.
// import "hardhat/console.sol";

contract OrderManager {
    address public owner;
    mapping(uint => FoodOrder) public orders;
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
        FoodOrder newOrder = new FoodOrder(_restaurantName, _dishes, _totalPrice, _deliveryAddress);
        orders[orderCount] = newOrder;
        orderCount++;

        emit NewOrderCreated(msg.sender, address(newOrder));
    }

    function getOrderStatus(uint _orderId) public view returns (FoodOrder.OrderStatus) {
        return orders[_orderId].status();
    }

    function acceptOrder(uint _orderId, address _deliveryPerson) public {
        orders[_orderId].acceptOrder(_deliveryPerson);
    }

    function markOrderAsDelivered(uint _orderId) public {
        orders[_orderId].markAsDelivered();
    }
}

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
        customer = msg.sender;  // La persona que genera el pedido
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
}