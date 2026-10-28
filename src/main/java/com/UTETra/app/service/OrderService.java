package com.UTETra.app.service;

import com.UTETra.app.dto.AdminOrderDetail;
import com.UTETra.app.dto.OrderDashboardSummary;
import com.UTETra.app.entity.CustomerOrder;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.time.LocalDate;

public interface OrderService {

    Page<CustomerOrder> search(String orderCode,
                               CustomerOrder.OrderStatus status,
                               LocalDate from,
                               LocalDate to,
                               Pageable pageable);

    Page<CustomerOrder> findForUser(Long userId, Pageable pageable);

    AdminOrderDetail getDetail(Long id);

    AdminOrderDetail getDetailByCode(String orderCode);

    void updateStatus(Long id, CustomerOrder.OrderStatus targetStatus);

    void confirmOfflinePayment(Long id);

    void customerCancelOrder(String orderCode, Long userId, String recipientPhone);

    void customerConfirmReceived(String orderCode, Long userId, String recipientPhone);

    OrderDashboardSummary dashboardSummary(LocalDate from, LocalDate to);
}
