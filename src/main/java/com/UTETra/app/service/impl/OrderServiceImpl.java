package com.UTETra.app.service.impl;

import com.UTETra.app.dto.AdminOrderDetail;
import com.UTETra.app.dto.OrderDashboardSummary;
import com.UTETra.app.entity.CustomerOrder;
import com.UTETra.app.entity.OrderItem;
import com.UTETra.app.entity.PaymentTransaction;
import com.UTETra.app.exception.ResourceNotFoundException;
import com.UTETra.app.repository.OrderItemRepository;
import com.UTETra.app.repository.OrderRepository;
import com.UTETra.app.repository.PaymentTransactionRepository;
import com.UTETra.app.service.OrderService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.persistence.criteria.Predicate;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.EnumMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@Service
@Transactional
public class OrderServiceImpl implements OrderService {

    private static final Map<CustomerOrder.OrderStatus, List<CustomerOrder.OrderStatus>> TRANSITIONS = transitions();

    private final OrderRepository orderRepository;
    private final OrderItemRepository orderItemRepository;
    private final PaymentTransactionRepository paymentTransactionRepository;

    public OrderServiceImpl(OrderRepository orderRepository,
                            OrderItemRepository orderItemRepository,
                            PaymentTransactionRepository paymentTransactionRepository) {
        this.orderRepository = orderRepository;
        this.orderItemRepository = orderItemRepository;
        this.paymentTransactionRepository = paymentTransactionRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public Page<CustomerOrder> search(String orderCode,
                                      CustomerOrder.OrderStatus status,
                                      LocalDate from,
                                      LocalDate to,
                                      Pageable pageable) {
        validateRange(from, to);
        LocalDateTime fromDate = from == null ? null : from.atStartOfDay();
        LocalDateTime toExclusive = to == null ? null : to.plusDays(1).atStartOfDay();
        String normalizedCode = orderCode == null || orderCode.isBlank()
                ? null : orderCode.trim().toLowerCase(Locale.ROOT);

        Specification<CustomerOrder> specification = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (normalizedCode != null) {
                predicates.add(cb.like(cb.lower(root.get("orderCode")), "%" + normalizedCode + "%"));
            }
            if (status != null) {
                predicates.add(cb.equal(root.get("orderStatus"), status));
            }
            if (fromDate != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("createdAt"), fromDate));
            }
            if (toExclusive != null) {
                predicates.add(cb.lessThan(root.get("createdAt"), toExclusive));
            }
            return cb.and(predicates.toArray(Predicate[]::new));
        };
        return orderRepository.findAll(specification, pageable);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<CustomerOrder> findForUser(Long userId, Pageable pageable) {
        return orderRepository.findByUser_IdOrderByCreatedAtDesc(userId, pageable);
    }

    @Override
    @Transactional(readOnly = true)
    public AdminOrderDetail getDetail(Long id) {
        CustomerOrder order = orderRepository.findWithCustomerAndBranchById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Order", id));
        List<OrderItem> items = orderItemRepository.findByOrder_IdOrderByIdAsc(id);
        List<PaymentTransaction> payments = paymentTransactionRepository.findByOrder_IdOrderByCreatedAtDesc(id);
        return new AdminOrderDetail(order, items, payments, nextStatuses(order));
    }

    @Override
    public void updateStatus(Long id, CustomerOrder.OrderStatus targetStatus) {
        CustomerOrder order = orderRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Order", id));
        List<CustomerOrder.OrderStatus> allowed = nextStatuses(order);
        if (!allowed.contains(targetStatus)) {
            throw new IllegalArgumentException("Không thể chuyển đơn từ " + order.getOrderStatus()
                    + " sang " + targetStatus);
        }
        if (targetStatus == CustomerOrder.OrderStatus.CANCELLED
                && order.getPaymentStatus() == CustomerOrder.PaymentStatus.PAID) {
            throw new IllegalArgumentException("Đơn đã thanh toán, cần xử lý hoàn tiền trước khi hủy");
        }
        order.setOrderStatus(targetStatus);
        orderRepository.save(order);
    }

    @Override
    @Transactional(readOnly = true)
    public OrderDashboardSummary dashboardSummary(LocalDate from, LocalDate to) {
        validateRange(from, to);
        LocalDateTime fromDate = from == null ? null : from.atStartOfDay();
        LocalDateTime toExclusive = to == null ? null : to.plusDays(1).atStartOfDay();
        BigDecimal revenue = orderRepository.sumPaidRevenueInPeriod(
                CustomerOrder.PaymentStatus.PAID, fromDate, toExclusive);
        return new OrderDashboardSummary(
                orderRepository.countInPeriod(fromDate, toExclusive),
                orderRepository.countByStatusInPeriod(CustomerOrder.OrderStatus.PENDING, fromDate, toExclusive),
                revenue == null ? BigDecimal.ZERO : revenue);
    }

    private List<CustomerOrder.OrderStatus> nextStatuses(CustomerOrder order) {
        List<CustomerOrder.OrderStatus> statuses = TRANSITIONS.getOrDefault(order.getOrderStatus(), List.of());
        if (order.getOrderStatus() == CustomerOrder.OrderStatus.PREPARING
                && order.getOrderType() != CustomerOrder.OrderType.DELIVERY) {
            return List.of(CustomerOrder.OrderStatus.COMPLETED);
        }
        return statuses;
    }

    private void validateRange(LocalDate from, LocalDate to) {
        if (from != null && to != null && from.isAfter(to)) {
            throw new IllegalArgumentException("Ngày bắt đầu phải trước hoặc bằng ngày kết thúc");
        }
    }

    private static Map<CustomerOrder.OrderStatus, List<CustomerOrder.OrderStatus>> transitions() {
        Map<CustomerOrder.OrderStatus, List<CustomerOrder.OrderStatus>> map =
                new EnumMap<>(CustomerOrder.OrderStatus.class);
        map.put(CustomerOrder.OrderStatus.PENDING,
                List.of(CustomerOrder.OrderStatus.CONFIRMED, CustomerOrder.OrderStatus.CANCELLED));
        map.put(CustomerOrder.OrderStatus.CONFIRMED,
                List.of(CustomerOrder.OrderStatus.PREPARING, CustomerOrder.OrderStatus.CANCELLED));
        map.put(CustomerOrder.OrderStatus.PREPARING,
                List.of(CustomerOrder.OrderStatus.SHIPPING));
        map.put(CustomerOrder.OrderStatus.SHIPPING,
                List.of(CustomerOrder.OrderStatus.COMPLETED));
        return Map.copyOf(map);
    }
}
