package com.UTETra.app.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.math.BigDecimal;

@Entity
@Table(name = "product_sizes")
public class ProductSize {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "product_id", nullable = false)
    private Long productId;

    @Column(name = "size_name", nullable = false, length = 10)
    private String sizeName;

    @Column(name = "extra_price", nullable = false, precision = 12, scale = 2)
    private BigDecimal extraPrice = BigDecimal.ZERO;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }

    public String getSizeName() { return sizeName; }
    public void setSizeName(String sizeName) { this.sizeName = sizeName; }

    public BigDecimal getExtraPrice() { return extraPrice; }
    public void setExtraPrice(BigDecimal extraPrice) { this.extraPrice = extraPrice; }
}
