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

@Entity
@Table(name = "payment_transactions")
public class PaymentTransaction {

    public enum Provider {
        COD("COD"), MOMO("MoMo"), VNPAY("VNPay"), ZALOPAY("ZaloPay"), BANK_TRANSFER("Chuyển khoản");
        private final String label;
        Provider(String label) { this.label = label; }
        public String getLabel() { return label; }
    }
    public enum Status {
        PENDING("Đang xử lý"), SUCCESS("Thành công"), FAILED("Thất bại"), REFUNDED("Đã hoàn tiền");
        private final String label;
        Status(String label) { this.label = label; }
        public String getLabel() { return label; }
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "order_id", nullable = false)
    private CustomerOrder order;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Provider provider;

    @Column(name = "transaction_ref", unique = true, length = 100)
    private String transactionRef;

    @Column(nullable = false, precision = 12, scale = 2)
    private BigDecimal amount;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Status status;

    @Column(name = "paid_at")
    private LocalDateTime paidAt;

    @Column(name = "created_at", insertable = false, updatable = false)
    private LocalDateTime createdAt;

    public Long getId() { return id; }
    public CustomerOrder getOrder() { return order; }
    public Provider getProvider() { return provider; }
    public String getTransactionRef() { return transactionRef; }
    public BigDecimal getAmount() { return amount; }
    public Status getStatus() { return status; }
    public LocalDateTime getPaidAt() { return paidAt; }
    public LocalDateTime getCreatedAt() { return createdAt; }
}
