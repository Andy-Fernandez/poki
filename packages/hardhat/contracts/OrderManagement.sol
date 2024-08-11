// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OrderManagement {
    enum OrderStatus { Placed, Accepted, InTransit, Delivered, Cancelled }
    enum AccidentStatus { None, Reported, Resolved }

    struct Order {
        uint id;
        address customer;
        address restaurant;
        address deliveryPerson;
        uint totalPrice;
        OrderStatus status;
        AccidentStatus accidentStatus;
    }

    mapping(uint => Order) public orders;
    uint public orderCount = 0;

    event OrderPlaced(uint id, address customer, address restaurant, uint totalPrice);
    event OrderStatusChanged(uint id, OrderStatus status);
    event AccidentReported(uint id, address deliveryPerson);

    function placeOrder(address _restaurant, uint _totalPrice) public {
        orders[orderCount] = Order({
            id: orderCount,
            customer: msg.sender,
            restaurant: _restaurant,
            deliveryPerson: address(0),
            totalPrice: _totalPrice,
            status: OrderStatus.Placed,
            accidentStatus: AccidentStatus.None
        });

        emit OrderPlaced(orderCount, msg.sender, _restaurant, _totalPrice);
        orderCount++;
    }

    function assignDeliveryPerson(uint _orderId, address _deliveryPerson) public {
        Order storage order = orders[_orderId];
        require(order.status == OrderStatus.Placed, "El pedido no puede ser aceptado");
        order.deliveryPerson = _deliveryPerson;
        order.status = OrderStatus.Accepted;

        emit OrderStatusChanged(_orderId, OrderStatus.Accepted);
    }

    function reportAccident(uint _orderId) public {
        Order storage order = orders[_orderId];
        require(order.deliveryPerson == msg.sender, "Solo el repartidor puede reportar accidentes");
        order.accidentStatus = AccidentStatus.Reported;

        emit AccidentReported(_orderId, msg.sender);
    }

    function resolveAccident(uint _orderId) public {
        Order storage order = orders[_orderId];
        require(order.accidentStatus == AccidentStatus.Reported, "No hay accidente reportado para resolver");
        order.accidentStatus = AccidentStatus.Resolved;

        // Lógica para distribuir compensación...

        emit OrderStatusChanged(_orderId, order.status);
    }

    function completeOrder(uint _orderId) public {
        Order storage order = orders[_orderId];
        require(order.deliveryPerson == msg.sender, "Solo el repartidor puede marcar como entregado");
        order.status = OrderStatus.Delivered;

        emit OrderStatusChanged(_orderId, OrderStatus.Delivered);
    }
}
