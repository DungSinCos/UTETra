package com.UTETra.app.dto;

import java.math.BigDecimal;

public record OrderDashboardSummary(long totalOrders, long pendingOrders, BigDecimal paidRevenue) {
    public long getTotalOrders() {
        return totalOrders;
    }

    public long getPendingOrders() {
        return pendingOrders;
    }

    public BigDecimal getPaidRevenue() {
        return paidRevenue;
    }
}
