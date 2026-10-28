package com.UTETra.app.dto;

import com.UTETra.app.entity.CustomerOrder;
import com.UTETra.app.entity.OrderItem;
import com.UTETra.app.entity.PaymentTransaction;

import java.util.List;

/** Data prepared inside the service transaction for the Admin order detail page. */
public record AdminOrderDetail(
        CustomerOrder order,
        List<OrderItem> items,
        List<PaymentTransaction> payments,
        List<CustomerOrder.OrderStatus> nextStatuses) {
}
