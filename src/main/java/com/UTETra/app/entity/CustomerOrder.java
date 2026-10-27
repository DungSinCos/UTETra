package com.UTETra.app.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/** Maps the orders table. A separate name avoids confusion with java.lang.Object ordering APIs. */
@Entity
@Table(name = "orders")
public class CustomerOrder {

    public enum OrderType {
        DELIVERY("Giao hàng"), PICKUP("Đến lấy"), DINE_IN("Dùng tại quán");
        private final String label;
        OrderType(String label) { this.label = label; }
        public String getLabel() { return label; }
    }
    public enum PaymentMethod {
        COD("Thanh toán khi nhận"), MOMO("MoMo"), VNPAY("VNPay"),
        ZALOPAY("ZaloPay"), BANK_TRANSFER("Chuyển khoản");
        private final String label;
        PaymentMethod(String label) { this.label = label; }
        public String getLabel() { return label; }
    }
    public enum PaymentStatus {
        UNPAID("Chưa thanh toán"), PAID("Đã thanh toán"),
        REFUNDED("Đã hoàn tiền"), FAILED("Thất bại");
        private final String label;
        PaymentStatus(String label) { this.label = label; }
        public String getLabel() { return label; }
    }
    public enum OrderStatus {
        PENDING("Chờ xác nhận"), CONFIRMED("Đã xác nhận"), PREPARING("Đang chuẩn bị"),
        SHIPPING("Đang giao"), COMPLETED("Hoàn tất"), CANCELLED("Đã hủy");
        private final String label;
        OrderStatus(String label) { this.label = label; }
        public String getLabel() { return label; }
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "order_code", nullable = false, unique = true, length = 40)
    private String orderCode;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "branch_id", nullable = false)
    private Branch branch;

    @Column(name = "voucher_id")
    private Long voucherId;

    @Enumerated(EnumType.STRING)
    @Column(name = "order_type", nullable = false, length = 20)
    private OrderType orderType;

    @Column(name = "recipient_name", nullable = false, length = 100)
    private String recipientName;

    @Column(name = "recipient_phone", nullable = false, length = 20)
    private String recipientPhone;

    @Column(name = "shipping_address", length = 500)
    private String shippingAddress;

    @Column(name = "subtotal_amount", nullable = false, precision = 12, scale = 2)
    private BigDecimal subtotalAmount;

    @Column(name = "shipping_fee", nullable = false, precision = 12, scale = 2)
    private BigDecimal shippingFee;

    @Column(name = "discount_amount", nullable = false, precision = 12, scale = 2)
    private BigDecimal discountAmount;

    @Column(name = "total_amount", nullable = false, precision = 12, scale = 2)
    private BigDecimal totalAmount;

    @Enumerated(EnumType.STRING)
    @Column(name = "payment_method", nullable = false, length = 20)
    private PaymentMethod paymentMethod;

    @Enumerated(EnumType.STRING)
    @Column(name = "payment_status", nullable = false, length = 20)
    private PaymentStatus paymentStatus;

    @Enumerated(EnumType.STRING)
    @Column(name = "order_status", nullable = false, length = 20)
    private OrderStatus orderStatus;

    @Column(length = 500)
    private String note;

    @Column(name = "created_at", insertable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", insertable = false, updatable = false)
    private LocalDateTime updatedAt;

    public Long getId() { return id; }
    public String getOrderCode() { return orderCode; }
    public User getUser() { return user; }
    public Branch getBranch() { return branch; }
    public Long getVoucherId() { return voucherId; }
    public OrderType getOrderType() { return orderType; }
    public String getRecipientName() { return recipientName; }
    public String getRecipientPhone() { return recipientPhone; }
    public String getShippingAddress() { return shippingAddress; }
    public BigDecimal getSubtotalAmount() { return subtotalAmount; }
    public BigDecimal getShippingFee() { return shippingFee; }
    public BigDecimal getDiscountAmount() { return discountAmount; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public PaymentMethod getPaymentMethod() { return paymentMethod; }
    public PaymentStatus getPaymentStatus() { return paymentStatus; }
    public OrderStatus getOrderStatus() { return orderStatus; }
    public String getNote() { return note; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }

    public void setOrderStatus(OrderStatus orderStatus) { this.orderStatus = orderStatus; }
}
