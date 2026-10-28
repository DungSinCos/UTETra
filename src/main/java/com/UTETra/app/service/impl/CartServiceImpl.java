package com.UTETra.app.service.impl;

import com.UTETra.app.dto.CartItemView;
import com.UTETra.app.entity.Branch;
import com.UTETra.app.entity.Cart;
import com.UTETra.app.entity.CartItem;
import com.UTETra.app.entity.Product;
import com.UTETra.app.entity.ProductSize;
import com.UTETra.app.exception.ResourceNotFoundException;
import com.UTETra.app.repository.BranchRepository;
import com.UTETra.app.repository.CartItemRepository;
import com.UTETra.app.repository.CartRepository;
import com.UTETra.app.repository.ProductRepository;
import com.UTETra.app.repository.ProductSizeRepository;
import com.UTETra.app.service.CartService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
public class CartServiceImpl implements CartService {

    private static final BigDecimal DEFAULT_DELIVERY_FEE = BigDecimal.valueOf(15000);
    private static final Set<String> VALID_SIZES = Set.of("S", "M", "L");

    private final CartRepository cartRepository;
    private final CartItemRepository cartItemRepository;
    private final ProductRepository productRepository;
    private final ProductSizeRepository productSizeRepository;
    private final BranchRepository branchRepository;

    public CartServiceImpl(CartRepository cartRepository,
                           CartItemRepository cartItemRepository,
                           ProductRepository productRepository,
                           ProductSizeRepository productSizeRepository,
                           BranchRepository branchRepository) {
        this.cartRepository = cartRepository;
        this.cartItemRepository = cartItemRepository;
        this.productRepository = productRepository;
        this.productSizeRepository = productSizeRepository;
        this.branchRepository = branchRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public CartSummary getCartSummary(Long userId) {
        if (userId == null) {
            return emptySummary();
        }
        Optional<Cart> cartOpt = cartRepository.findByUserId(userId);
        if (cartOpt.isEmpty()) {
            return emptySummary();
        }
        return buildSummary(cartOpt.get().getId());
    }

    @Override
    @Transactional
    public CartSummary addProductToCart(Long userId, Long productId, String sizeName, int quantity, Long branchId) {
        Product product = productRepository.findById(productId)
                .filter(Product::isActive)
                .orElseThrow(() -> new ResourceNotFoundException("Product", productId));

        String normalizedSize = normalizeSize(sizeName);
        int safeQty = Math.max(1, quantity);

        Cart cart = cartRepository.findByUserId(userId).orElseGet(() -> {
            Cart newCart = new Cart();
            newCart.setUserId(userId);
            newCart.setBranchId(resolveBranchId(branchId));
            return cartRepository.save(newCart);
        });

        if (branchId != null && !branchId.equals(cart.getBranchId())) {
            cart.setBranchId(branchId);
            cartRepository.save(cart);
        } else if (cart.getBranchId() == null) {
            cart.setBranchId(resolveBranchId(null));
            cartRepository.save(cart);
        }

        Optional<CartItem> existingOpt = cartItemRepository
                .findByCartIdAndProductIdAndSizeName(cart.getId(), product.getId(), normalizedSize);

        if (existingOpt.isPresent()) {
            CartItem existing = existingOpt.get();
            existing.setQuantity(existing.getQuantity() + safeQty);
            cartItemRepository.save(existing);
        } else {
            CartItem item = new CartItem();
            item.setCartId(cart.getId());
            item.setProductId(product.getId());
            item.setSizeName(normalizedSize);
            item.setSugarLevel("100%");
            item.setIceLevel("100%");
            item.setQuantity(safeQty);
            cartItemRepository.save(item);
        }

        return buildSummary(cart.getId());
    }

    @Override
    @Transactional
    public CartSummary updateItemQuantity(Long userId, Long itemId, int quantity) {
        Cart cart = cartRepository.findByUserId(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Cart", userId));

        CartItem item = cartItemRepository.findByIdAndCartId(itemId, cart.getId())
                .orElseThrow(() -> new ResourceNotFoundException("CartItem", itemId));

        if (quantity <= 0) {
            cartItemRepository.delete(item);
        } else {
            item.setQuantity(quantity);
            cartItemRepository.save(item);
        }

        return buildSummary(cart.getId());
    }

    @Override
    @Transactional
    public CartSummary removeItem(Long userId, Long itemId) {
        Optional<Cart> cartOpt = cartRepository.findByUserId(userId);
        if (cartOpt.isEmpty()) {
            return emptySummary();
        }
        Cart cart = cartOpt.get();
        cartItemRepository.findByIdAndCartId(itemId, cart.getId())
                .ifPresent(cartItemRepository::delete);

        return buildSummary(cart.getId());
    }

    private CartSummary buildSummary(Long cartId) {
        List<CartItem> rows = cartItemRepository.findByCartIdOrderByIdAsc(cartId);
        if (rows.isEmpty()) {
            return emptySummary();
        }

        List<CartItemView> views = new ArrayList<>(rows.size());
        BigDecimal subtotal = BigDecimal.ZERO;
        int totalQty = 0;

        for (CartItem row : rows) {
            Optional<Product> productOpt = productRepository.findById(row.getProductId());
            if (productOpt.isEmpty()) {
                continue;
            }
            Product product = productOpt.get();
            BigDecimal basePrice = product.getBasePrice() != null ? product.getBasePrice() : BigDecimal.ZERO;
            BigDecimal extraPrice = productSizeRepository
                    .findByProductIdAndSizeName(product.getId(), row.getSizeName())
                    .map(ProductSize::getExtraPrice)
                    .orElse(BigDecimal.ZERO);

            BigDecimal unitPrice = basePrice.add(extraPrice);
            BigDecimal lineTotal = unitPrice.multiply(BigDecimal.valueOf(row.getQuantity()));

            views.add(new CartItemView(
                    row.getId(),
                    product.getId(),
                    product.getName(),
                    product.getImageUrl(),
                    row.getSizeName(),
                    row.getQuantity(),
                    unitPrice,
                    lineTotal
            ));

            subtotal = subtotal.add(lineTotal);
            totalQty += row.getQuantity();
        }

        if (views.isEmpty()) {
            return emptySummary();
        }

        BigDecimal deliveryFee = DEFAULT_DELIVERY_FEE;
        BigDecimal total = subtotal.add(deliveryFee);

        return new CartSummary(views, totalQty, subtotal, deliveryFee, total);
    }

    private Long resolveBranchId(Long requestedBranchId) {
        if (requestedBranchId != null) {
            return requestedBranchId;
        }
        List<Branch> branches = branchRepository.findByActiveTrueOrderByIdAsc();
        return branches.isEmpty() ? null : branches.get(0).getId();
    }

    private static String normalizeSize(String sizeName) {
        if (sizeName == null || sizeName.isBlank()) {
            return "S";
        }
        String upper = sizeName.trim().toUpperCase();
        return VALID_SIZES.contains(upper) ? upper : "S";
    }

    private static CartSummary emptySummary() {
        return new CartSummary(List.of(), 0, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO);
    }
}
