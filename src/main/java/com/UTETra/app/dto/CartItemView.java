package com.UTETra.app.dto;

import java.math.BigDecimal;

/**
 * View DTO representing a cart item on the /cart page, enriched with product details and calculated prices.
 */
public class CartItemView {

    private final Long itemId;
    private final Long productId;
    private final String name;
    private final String imageUrl;
    private final String sizeName;
    private final int quantity;
    private final BigDecimal unitPrice;
    private final BigDecimal lineTotal;

    public CartItemView(Long itemId,
                        Long productId,
                        String name,
                        String imageUrl,
                        String sizeName,
                        int quantity,
                        BigDecimal unitPrice,
                        BigDecimal lineTotal) {
        this.itemId = itemId;
        this.productId = productId;
        this.name = name;
        this.imageUrl = imageUrl;
        this.sizeName = sizeName;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.lineTotal = lineTotal;
    }

    public Long getItemId() { return itemId; }
    public Long getProductId() { return productId; }
    public String getName() { return name; }
    public String getImageUrl() { return imageUrl; }
    public String getSizeName() { return sizeName; }
    public int getQuantity() { return quantity; }
    public BigDecimal getUnitPrice() { return unitPrice; }
    public BigDecimal getLineTotal() { return lineTotal; }
}
