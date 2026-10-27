package com.UTETra.app.dto;

import java.math.BigDecimal;

public record OrderDashboardSummary(long totalOrders, long pendingOrders, BigDecimal paidRevenue) {
}
