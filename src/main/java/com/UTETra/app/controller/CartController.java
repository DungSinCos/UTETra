package com.UTETra.app.controller;

import com.UTETra.app.dto.CartItemView;
import com.UTETra.app.entity.User;
import com.UTETra.app.service.CartService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.Map;

@Controller
@RequestMapping("/cart")
public class CartController {

    private final CartService cartService;

    public CartController(CartService cartService) {
        this.cartService = cartService;
    }

    @GetMapping
    public String cart(HttpServletRequest request, Model model) {
        User user = getCurrentUser(request);
        CartService.CartSummary summary = cartService.getCartSummary(user != null ? user.getId() : null);

        model.addAttribute("cartItems", summary.items());
        model.addAttribute("subtotal", summary.subtotal());
        model.addAttribute("deliveryFee", summary.deliveryFee());
        model.addAttribute("total", summary.total());
        model.addAttribute("isGuest", user == null);
        return "cart"; // -> /WEB-INF/views/cart.jsp
    }

    /**
     * Adds a product to the authenticated user's cart in the database (tables carts, cart_items).
     */
    @PostMapping(value = "/items", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<Map<String, Object>> addItem(
            @RequestParam Long productId,
            @RequestParam(defaultValue = "S") String size,
            @RequestParam(defaultValue = "1") int quantity,
            @RequestParam(required = false) Long branchId,
            HttpServletRequest request) {

        User user = getCurrentUser(request);
        if (user == null) {
            return unauthorizedResponse(request);
        }

        try {
            CartService.CartSummary summary = cartService.addProductToCart(
                    user.getId(), productId, size, quantity, branchId);
            Map<String, Object> payload = buildSuccessPayload("Đã thêm sản phẩm vào giỏ hàng", summary, null);
            String normalizedSize = size != null ? size.trim().toUpperCase() : "S";
            for (CartItemView item : summary.items()) {
                if (productId.equals(item.getProductId()) && normalizedSize.equalsIgnoreCase(item.getSizeName())) {
                    payload.put("productName", item.getName());
                    payload.put("itemQuantity", item.getQuantity());
                    payload.put("size", item.getSizeName());
                    break;
                }
            }
            return ResponseEntity.ok(payload);
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Map.of(
                            "success", false,
                            "message", ex.getMessage() != null ? ex.getMessage() : "Không thể thêm sản phẩm vào giỏ hàng"
                    ));
        }
    }

    /**
     * Updates the quantity of a cart_item in the database for the authenticated user.
     */
    @PostMapping(value = "/items/{itemId}/quantity", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateQuantity(
            @PathVariable Long itemId,
            @RequestParam int quantity,
            HttpServletRequest request) {

        User user = getCurrentUser(request);
        if (user == null) {
            return unauthorizedResponse(request);
        }

        try {
            CartService.CartSummary summary = cartService.updateItemQuantity(user.getId(), itemId, quantity);
            return ResponseEntity.ok(buildSuccessPayload("Đã cập nhật số lượng", summary, itemId));
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Map.of(
                            "success", false,
                            "message", ex.getMessage() != null ? ex.getMessage() : "Không thể cập nhật số lượng"
                    ));
        }
    }

    /**
     * Removes a cart_item from the database for the authenticated user.
     */
    @PostMapping(value = "/items/{itemId}/delete", produces = MediaType.APPLICATION_JSON_VALUE)
    @DeleteMapping(value = "/items/{itemId}", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<Map<String, Object>> removeItem(
            @PathVariable Long itemId,
            HttpServletRequest request) {

        User user = getCurrentUser(request);
        if (user == null) {
            return unauthorizedResponse(request);
        }

        CartService.CartSummary summary = cartService.removeItem(user.getId(), itemId);
        return ResponseEntity.ok(buildSuccessPayload("Đã xóa sản phẩm khỏi giỏ hàng", summary, null));
    }

    private User getCurrentUser(HttpServletRequest request) {
        Object attr = request.getAttribute("currentUser");
        return (attr instanceof User u) ? u : null;
    }

    private ResponseEntity<Map<String, Object>> unauthorizedResponse(HttpServletRequest request) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", false);
        body.put("message", "Vui lòng đăng nhập để sử dụng giỏ hàng");
        body.put("redirectUrl", request.getContextPath() + "/login");
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(body);
    }

    private Map<String, Object> buildSuccessPayload(String message, CartService.CartSummary summary, Long targetItemId) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", true);
        body.put("message", message);
        body.put("itemCount", summary.items().size());
        body.put("totalQuantity", summary.totalQuantity());
        body.put("subtotal", toLong(summary.subtotal()));
        body.put("deliveryFee", toLong(summary.deliveryFee()));
        body.put("total", toLong(summary.total()));

        if (targetItemId != null) {
            for (CartItemView item : summary.items()) {
                if (targetItemId.equals(item.getItemId())) {
                    body.put("itemQuantity", item.getQuantity());
                    body.put("itemUnitPrice", toLong(item.getUnitPrice()));
                    body.put("itemLineTotal", toLong(item.getLineTotal()));
                    break;
                }
            }
        }
        return body;
    }

    private static long toLong(BigDecimal val) {
        return val != null ? val.longValue() : 0L;
    }
}
