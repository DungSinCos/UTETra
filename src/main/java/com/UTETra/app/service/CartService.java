package com.UTETra.app.service;

import com.UTETra.app.dto.CartItemView;

import java.math.BigDecimal;
import java.util.List;

public interface CartService {

    record CartSummary(
            List<CartItemView> items,
            int totalQuantity,
            BigDecimal subtotal,
            BigDecimal deliveryFee,
            BigDecimal total
    ) {}

    CartSummary getCartSummary(Long userId);

    CartSummary addProductToCart(Long userId, Long productId, String sizeName, int quantity, Long branchId);

    CartSummary updateItemQuantity(Long userId, Long itemId, int quantity);

    CartSummary removeItem(Long userId, Long itemId);
}
