package com.UTETra.app.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import java.math.BigDecimal;

@Entity
@Table(name = "order_item_toppings")
public class OrderItemTopping {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "order_item_id", nullable = false)
    private OrderItem orderItem;

    @Column(name = "topping_id")
    private Long toppingId;

    @Column(name = "topping_name", nullable = false, length = 100)
    private String toppingName;

    @Column(name = "topping_price", nullable = false, precision = 12, scale = 2)
    private BigDecimal toppingPrice;

    @Column(nullable = false)
    private int quantity;

    public Long getId() { return id; }
    public OrderItem getOrderItem() { return orderItem; }
    public Long getToppingId() { return toppingId; }
    public String getToppingName() { return toppingName; }
    public BigDecimal getToppingPrice() { return toppingPrice; }
    public int getQuantity() { return quantity; }
}
