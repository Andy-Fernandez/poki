/// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract OrderManager {
    address public owner;
    uint public orderCount;
    mapping(uint => address) public orders;

    event NewOrderCreated(address indexed customer, address indexed orderAddress);

    constructor() {
        owner = msg.sender;
    }

    function createOrder(
        string memory _restaurantName,
        string[] memory _dishes,
        uint _totalPrice,
        string memory _deliveryAddress
    ) public {
        FoodOrder newOrder = new FoodOrder(
            _restaurantName, _dishes, _totalPrice, _deliveryAddress
        );
        orders[orderCount] = address(newOrder);
        orderCount++;

        emit NewOrderCreated(msg.sender, address(newOrder));
    }

    function getOrderStatus(uint _orderId) public view returns (FoodOrder.OrderStatus) {
        FoodOrder order = FoodOrder(orders[_orderId]);
        return order.status();
    }

    function acceptOrder(uint _orderId, address _deliveryPerson) public {
        FoodOrder order = FoodOrder(orders[_orderId]);
        order.acceptOrder(_deliveryPerson);
    }

    function markOrderAsDelivered(uint _orderId) public {
        FoodOrder order = FoodOrder(orders[_orderId]);
        order.markAsDelivered();
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
        customer = msg.sender;
        restaurantName = _restaurantName;
        dishes = _dishes;
        totalPrice = _totalPrice;
        deliveryAddress = _deliveryAddress;
        status = OrderStatus.Placed;

        emit OrderPlaced(customer, dishes, totalPrice);
    }

    function acceptOrder(address _deliveryPerson) public {
        require(status == OrderStatus.Placed, "Order already accepted");
        require(deliveryPerson == address(0), "Delivery person already assigned");
        deliveryPerson = _deliveryPerson;
        status = OrderStatus.Accepted;

        emit OrderAccepted(deliveryPerson);
    }

    function markAsDelivered() public {
        require(msg.sender == deliveryPerson, "Only the delivery person can mark as delivered");
        require(status == OrderStatus.Accepted, "Order not accepted yet");
        status = OrderStatus.Delivered;

        emit OrderDelivered(customer);
    }

    function _status() public view returns (OrderStatus) {
        return status;
    }
}
