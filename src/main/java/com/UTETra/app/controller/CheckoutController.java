package com.UTETra.app.controller;

import com.UTETra.app.dto.CartItemView;
import com.UTETra.app.entity.Branch;
import com.UTETra.app.entity.Cart;
import com.UTETra.app.entity.CustomerOrder;
import com.UTETra.app.entity.OrderItem;
import com.UTETra.app.entity.PaymentTransaction;
import com.UTETra.app.entity.Product;
import com.UTETra.app.entity.User;
import com.UTETra.app.entity.UserAddress;
import com.UTETra.app.repository.BranchRepository;
import com.UTETra.app.repository.CartRepository;
import com.UTETra.app.repository.OrderItemRepository;
import com.UTETra.app.repository.OrderRepository;
import com.UTETra.app.repository.PaymentTransactionRepository;
import com.UTETra.app.repository.ProductRepository;
import com.UTETra.app.repository.UserAddressRepository;
import com.UTETra.app.service.CartService;
import com.UTETra.app.service.VNPayService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ThreadLocalRandom;

@Controller
@RequestMapping("/checkout")
public class CheckoutController {

    private final CartService cartService;
    private final UserAddressRepository userAddressRepository;
    private final BranchRepository branchRepository;
    private final CartRepository cartRepository;
    private final ProductRepository productRepository;
    private final OrderRepository orderRepository;
    private final OrderItemRepository orderItemRepository;
    private final PaymentTransactionRepository paymentTransactionRepository;
    private final VNPayService vnpayService;

    public CheckoutController(CartService cartService,
                              UserAddressRepository userAddressRepository,
                              BranchRepository branchRepository,
                              CartRepository cartRepository,
                              ProductRepository productRepository,
                              OrderRepository orderRepository,
                              OrderItemRepository orderItemRepository,
                              PaymentTransactionRepository paymentTransactionRepository,
                              VNPayService vnpayService) {
        this.cartService = cartService;
        this.userAddressRepository = userAddressRepository;
        this.branchRepository = branchRepository;
        this.cartRepository = cartRepository;
        this.productRepository = productRepository;
        this.orderRepository = orderRepository;
        this.orderItemRepository = orderItemRepository;
        this.paymentTransactionRepository = paymentTransactionRepository;
        this.vnpayService = vnpayService;
    }

    @GetMapping
    public String checkout(
            @RequestParam(required = false) Long productId,
            @RequestParam(defaultValue = "S") String size,
            @RequestParam(defaultValue = "1") int quantity,
            @RequestParam(required = false) Long branchId,
            HttpServletRequest request,
            Model model) {

        User user = getCurrentUser(request);
        boolean isLoggedIn = user != null;

        List<UserAddress> userAddresses = isLoggedIn
                ? userAddressRepository.findByUserIdOrderByDefaultAddressDescIdDesc(user.getId())
                : List.of();
        UserAddress currentAddress = userAddresses.isEmpty() ? null : userAddresses.get(0);

        boolean isDirectBuy = productId != null;
        CartService.CartSummary summary = isDirectBuy
                ? cartService.getDirectProductSummary(productId, size, quantity)
                : cartService.getCartSummary(isLoggedIn ? user.getId() : null);

        String defaultRecipientName = currentAddress != null
                ? currentAddress.getRecipientName()
                : (isLoggedIn && user.getFullName() != null ? user.getFullName() : "");
        String defaultRecipientPhone = currentAddress != null
                ? currentAddress.getRecipientPhone()
                : (isLoggedIn && user.getPhone() != null ? user.getPhone() : "");

        model.addAttribute("isLoggedIn", isLoggedIn);
        model.addAttribute("hasSavedAddress", currentAddress != null);
        model.addAttribute("currentAddress", currentAddress);
        model.addAttribute("userAddresses", userAddresses);
        model.addAttribute("defaultRecipientName", defaultRecipientName);
        model.addAttribute("defaultRecipientPhone", defaultRecipientPhone);

        model.addAttribute("checkoutItems", summary.items());
        model.addAttribute("subtotal", summary.subtotal());
        model.addAttribute("deliveryFee", summary.deliveryFee());
        model.addAttribute("total", summary.total());
        model.addAttribute("totalQuantity", summary.totalQuantity());

        model.addAttribute("checkoutMode", isDirectBuy ? "DIRECT" : "CART");
        model.addAttribute("directProductId", productId);
        model.addAttribute("directSize", size);
        model.addAttribute("directQuantity", quantity);
        model.addAttribute("selectedBranchId", branchId);

        return "checkout";
    }

    @PostMapping(consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    @Transactional
    public ResponseEntity<Map<String, Object>> placeOrder(
            @RequestParam(defaultValue = "CART") String checkoutMode,
            @RequestParam(required = false) Long directProductId,
            @RequestParam(defaultValue = "S") String directSize,
            @RequestParam(defaultValue = "1") int directQuantity,
            @RequestParam(required = false) Long branchId,
            @RequestParam(required = false) Long addressId,
            @RequestParam(required = false) String recipientName,
            @RequestParam(required = false) String recipientPhone,
            @RequestParam(required = false) String addressLine,
            @RequestParam(required = false) String ward,
            @RequestParam(required = false) String district,
            @RequestParam(required = false) String city,
            @RequestParam(required = false) String note,
            @RequestParam(defaultValue = "CASH") String paymentMethod,
            HttpServletRequest request) {

        User user = getCurrentUser(request);
        boolean isDirectBuy = "DIRECT".equalsIgnoreCase(checkoutMode) && directProductId != null;

        CartService.CartSummary summary = isDirectBuy
                ? cartService.getDirectProductSummary(directProductId, directSize, directQuantity)
                : cartService.getCartSummary(user != null ? user.getId() : null);

        if (summary.items().isEmpty()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("success", false, "message", "Đơn hàng của bạn không có sản phẩm nào"));
        }

        String finalName;
        String finalPhone;
        String finalShippingAddress;

        UserAddress existingAddr = null;
        if (user != null && addressId != null) {
            existingAddr = userAddressRepository.findById(addressId)
                    .filter(a -> user.getId().equals(a.getUserId()))
                    .orElse(null);
        }

        if (existingAddr != null && (addressLine == null || addressLine.isBlank())) {
            finalName = existingAddr.getRecipientName();
            finalPhone = existingAddr.getRecipientPhone();
            finalShippingAddress = existingAddr.getFullAddress();
        } else {
            finalName = recipientName != null ? recipientName.trim() : "";
            finalPhone = recipientPhone != null ? recipientPhone.trim() : "";
            String cleanAddressLine = addressLine != null ? addressLine.trim() : "";
            String cleanWard = ward != null ? ward.trim() : "";
            String cleanDistrict = district != null ? district.trim() : "";
            String cleanCity = city != null ? city.trim() : "";

            if (finalName.isEmpty() || finalPhone.isEmpty() || cleanAddressLine.isEmpty()
                    || cleanDistrict.isEmpty() || cleanCity.isEmpty()) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(Map.of("success", false, "message", "Vui lòng điền đầy đủ họ tên, số điện thoại và địa chỉ giao hàng"));
            }

            List<String> parts = new ArrayList<>();
            parts.add(cleanAddressLine);
            if (!cleanWard.isEmpty()) parts.add(cleanWard);
            parts.add(cleanDistrict);
            parts.add(cleanCity);
            finalShippingAddress = String.join(", ", parts);

            // If user is logged in and has no saved address yet, save this address as default
            if (user != null && userAddressRepository.findByUserIdOrderByDefaultAddressDescIdDesc(user.getId()).isEmpty()) {
                UserAddress newAddr = new UserAddress();
                newAddr.setUserId(user.getId());
                newAddr.setRecipientName(finalName);
                newAddr.setRecipientPhone(finalPhone);
                newAddr.setAddressLine(cleanAddressLine);
                newAddr.setWard(cleanWard.isEmpty() ? null : cleanWard);
                newAddr.setDistrict(cleanDistrict);
                newAddr.setCity(cleanCity);
                newAddr.setDefaultAddress(true);
                userAddressRepository.save(newAddr);
            }
        }

        Branch branch = resolveBranch(branchId, user);
        if (branch == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("success", false, "message", "Hiện chưa có chi nhánh hoạt động để xử lý đơn hàng"));
        }

        CustomerOrder.PaymentMethod selectedMethod;
        PaymentTransaction.Provider provider;
        if ("VNPAY".equalsIgnoreCase(paymentMethod)) {
            selectedMethod = CustomerOrder.PaymentMethod.VNPAY;
            provider = PaymentTransaction.Provider.VNPAY;
        } else if ("BANK_TRANSFER".equalsIgnoreCase(paymentMethod) || "PAYPAL".equalsIgnoreCase(paymentMethod)) {
            selectedMethod = CustomerOrder.PaymentMethod.BANK_TRANSFER;
            provider = PaymentTransaction.Provider.BANK_TRANSFER;
        } else {
            selectedMethod = CustomerOrder.PaymentMethod.COD;
            provider = PaymentTransaction.Provider.COD;
        }

        CustomerOrder order = new CustomerOrder();
        order.setOrderCode(generateOrderCode());
        order.setUser(user);
        order.setBranch(branch);
        order.setOrderType(CustomerOrder.OrderType.DELIVERY);
        order.setRecipientName(finalName);
        order.setRecipientPhone(finalPhone);
        order.setShippingAddress(finalShippingAddress);
        order.setSubtotalAmount(summary.subtotal());
        order.setShippingFee(summary.deliveryFee());
        order.setDiscountAmount(BigDecimal.ZERO);
        order.setTotalAmount(summary.total());
        order.setPaymentMethod(selectedMethod);
        order.setPaymentStatus(CustomerOrder.PaymentStatus.UNPAID);
        order.setOrderStatus(CustomerOrder.OrderStatus.PENDING);
        order.setNote(note != null && !note.isBlank() ? note.trim() : null);

        CustomerOrder savedOrder = orderRepository.save(order);

        for (CartItemView itemView : summary.items()) {
            Product product = productRepository.findById(itemView.getProductId()).orElse(null);
            OrderItem orderItem = new OrderItem();
            orderItem.setOrder(savedOrder);
            orderItem.setProduct(product);
            orderItem.setProductName(itemView.getName());
            orderItem.setSizeName(itemView.getSizeName());
            orderItem.setSugarLevel("100%");
            orderItem.setIceLevel("100%");
            orderItem.setUnitPrice(itemView.getUnitPrice());
            orderItem.setToppingTotalPrice(BigDecimal.ZERO);
            orderItem.setQuantity(itemView.getQuantity());
            orderItem.setLineTotal(itemView.getLineTotal());
            orderItemRepository.save(orderItem);
        }

        PaymentTransaction pt = new PaymentTransaction();
        pt.setOrder(savedOrder);
        pt.setProvider(provider);
        pt.setAmount(savedOrder.getTotalAmount());
        pt.setStatus(PaymentTransaction.Status.PENDING);
        pt.setTransactionRef(savedOrder.getOrderCode() + "-P1");
        paymentTransactionRepository.save(pt);

        if (!isDirectBuy && user != null) {
            cartService.clearUserCart(user.getId());
        }

        String redirectUrl;
        if (selectedMethod == CustomerOrder.PaymentMethod.VNPAY) {
            redirectUrl = vnpayService.createPaymentUrl(savedOrder, request);
        } else {
            redirectUrl = request.getContextPath() + "/orders/" + savedOrder.getOrderCode();
        }

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("success", true);
        response.put("message", "Đặt hàng thành công!");
        response.put("orderCode", savedOrder.getOrderCode());
        response.put("paymentMethod", selectedMethod.getLabel());
        response.put("total", summary.total().longValue());
        response.put("redirectUrl", redirectUrl);
        return ResponseEntity.ok(response);
    }

    private Branch resolveBranch(Long requestedBranchId, User user) {
        if (requestedBranchId != null) {
            Branch b = branchRepository.findById(requestedBranchId).orElse(null);
            if (b != null) {
                return b;
            }
        }
        if (user != null) {
            Long cartBranchId = cartRepository.findByUserId(user.getId())
                    .map(Cart::getBranchId)
                    .orElse(null);
            if (cartBranchId != null) {
                Branch b = branchRepository.findById(cartBranchId).orElse(null);
                if (b != null) {
                    return b;
                }
            }
        }
        List<Branch> activeBranches = branchRepository.findByActiveTrueOrderByIdAsc();
        return activeBranches.isEmpty() ? null : activeBranches.get(0);
    }

    private static String generateOrderCode() {
        String datePart = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyMMddHHmmss"));
        int rand = ThreadLocalRandom.current().nextInt(100, 999);
        return "UTE-" + datePart + "-" + rand;
    }

    private User getCurrentUser(HttpServletRequest request) {
        Object attr = request.getAttribute("currentUser");
        return (attr instanceof User u) ? u : null;
    }
}
