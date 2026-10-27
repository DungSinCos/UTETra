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
import jakarta.persistence.OneToMany;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "order_items")
public class OrderItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "order_id", nullable = false)
    private CustomerOrder order;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id")
    private Product product;

    @Column(name = "product_name", nullable = false, length = 150)
    private String productName;

    @Column(name = "size_name", nullable = false, length = 10)
    private String sizeName;

    @Column(name = "sugar_level", nullable = false, length = 10)
    private String sugarLevel;

    @Column(name = "ice_level", nullable = false, length = 10)
    private String iceLevel;

    @Column(name = "unit_price", nullable = false, precision = 12, scale = 2)
    private BigDecimal unitPrice;

    @Column(name = "topping_total_price", nullable = false, precision = 12, scale = 2)
    private BigDecimal toppingTotalPrice;

    @Column(nullable = false)
    private int quantity;

    @Column(name = "line_total", nullable = false, precision = 12, scale = 2)
    private BigDecimal lineTotal;

    @Column(length = 255)
    private String note;

    @OneToMany(mappedBy = "orderItem")
    private List<OrderItemTopping> toppings = new ArrayList<>();

    public Long getId() { return id; }
    public CustomerOrder getOrder() { return order; }
    public Product getProduct() { return product; }
    public String getProductName() { return productName; }
    public String getSizeName() { return sizeName; }
    public String getSugarLevel() { return sugarLevel; }
    public String getIceLevel() { return iceLevel; }
    public BigDecimal getUnitPrice() { return unitPrice; }
    public BigDecimal getToppingTotalPrice() { return toppingTotalPrice; }
    public int getQuantity() { return quantity; }
    public BigDecimal getLineTotal() { return lineTotal; }
    public String getNote() { return note; }
    public List<OrderItemTopping> getToppings() { return toppings; }
}
