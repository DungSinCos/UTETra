package com.UTETra.app.controller;

import com.UTETra.app.dto.AdminOrderDetail;
import com.UTETra.app.entity.CustomerOrder;
import com.UTETra.app.entity.User;
import com.UTETra.app.exception.ResourceNotFoundException;
import com.UTETra.app.repository.OrderRepository;
import com.UTETra.app.service.OrderService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Controller
@RequestMapping("/orders")
public class OrderController {

    private final OrderService orderService;
    private final OrderRepository orderRepository;
    private final String bankId;
    private final String bankAccountNo;
    private final String bankAccountName;

    public OrderController(OrderService orderService,
                           OrderRepository orderRepository,
                           @Value("${bank.id:MB}") String bankId,
                           @Value("${bank.account-no:0901234567}") String bankAccountNo,
                           @Value("${bank.account-name:UTETRA MILKTEA}") String bankAccountName) {
        this.orderService = orderService;
        this.orderRepository = orderRepository;
        this.bankId = bankId;
        this.bankAccountNo = bankAccountNo;
        this.bankAccountName = bankAccountName;
    }

    @GetMapping("/{orderCode}")
    public String orderDetail(@PathVariable String orderCode,
                              HttpServletRequest request,
                              Model model) {
        try {
            AdminOrderDetail detail = orderService.getDetailByCode(orderCode);
            CustomerOrder order = detail.order();
            User currentUser = getCurrentUser(request);

            boolean isOwner = (currentUser != null && order.getUser() != null && currentUser.getId().equals(order.getUser().getId()))
                    || order.getUser() == null
                    || (currentUser != null && (currentUser.getRole() == User.Role.ADMIN || currentUser.getRole() == User.Role.MANAGER));

            boolean canCancel = order.getOrderStatus() == CustomerOrder.OrderStatus.PENDING
                    && order.getPaymentStatus() != CustomerOrder.PaymentStatus.PAID;
            boolean canConfirmReceived = order.getOrderStatus() == CustomerOrder.OrderStatus.SHIPPING;

            boolean isBankTransferPending = order.getPaymentMethod() == CustomerOrder.PaymentMethod.BANK_TRANSFER
                    && order.getPaymentStatus() != CustomerOrder.PaymentStatus.PAID;

            String vietQrUrl = null;
            if (isBankTransferPending) {
                String safeAccountName = URLEncoder.encode(bankAccountName, StandardCharsets.UTF_8);
                String safeAddInfo = URLEncoder.encode(order.getOrderCode(), StandardCharsets.UTF_8);
                vietQrUrl = String.format("https://img.vietqr.io/image/%s-%s-compact2.png?amount=%s&addInfo=%s&accountName=%s",
                        bankId, bankAccountNo, order.getTotalAmount().toBigInteger().toString(), safeAddInfo, safeAccountName);
            }

            model.addAttribute("order", order);
            model.addAttribute("items", detail.items());
            model.addAttribute("payments", detail.payments());
            model.addAttribute("isOwner", isOwner);
            model.addAttribute("canCancel", canCancel);
            model.addAttribute("canConfirmReceived", canConfirmReceived);
            model.addAttribute("isBankTransferPending", isBankTransferPending);
            model.addAttribute("vietQrUrl", vietQrUrl);
            model.addAttribute("bankId", bankId);
            model.addAttribute("bankAccountNo", bankAccountNo);
            model.addAttribute("bankAccountName", bankAccountName);

            return "order-detail";
        } catch (ResourceNotFoundException ex) {
            model.addAttribute("error", "Không tìm thấy đơn hàng với mã " + orderCode);
            return "order-tracking";
        }
    }

    @PostMapping("/{orderCode}/cancel")
    public String cancelOrder(@PathVariable String orderCode,
                              @RequestParam(required = false) String phone,
                              HttpServletRequest request,
                              RedirectAttributes redirect) {
        User currentUser = getCurrentUser(request);
        Long userId = currentUser != null ? currentUser.getId() : null;
        try {
            orderService.customerCancelOrder(orderCode, userId, phone);
            redirect.addFlashAttribute("message", "Đã hủy đơn hàng thành công!");
        } catch (Exception ex) {
            redirect.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/orders/" + orderCode;
    }

    @PostMapping("/{orderCode}/confirm-received")
    public String confirmReceived(@PathVariable String orderCode,
                                  @RequestParam(required = false) String phone,
                                  HttpServletRequest request,
                                  RedirectAttributes redirect) {
        User currentUser = getCurrentUser(request);
        Long userId = currentUser != null ? currentUser.getId() : null;
        try {
            orderService.customerConfirmReceived(orderCode, userId, phone);
            redirect.addFlashAttribute("message", "Cảm ơn bạn! Đơn hàng đã được ghi nhận hoàn tất.");
        } catch (Exception ex) {
            redirect.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/orders/" + orderCode;
    }

    @GetMapping("/tracking")
    public String trackingPage() {
        return "order-tracking";
    }

    @PostMapping("/tracking")
    public String trackOrder(@RequestParam String orderCode,
                             @RequestParam String phone,
                             RedirectAttributes redirect) {
        String cleanCode = orderCode != null ? orderCode.trim() : "";
        String cleanPhone = phone != null ? phone.trim() : "";

        if (cleanCode.isEmpty() || cleanPhone.isEmpty()) {
            redirect.addFlashAttribute("error", "Vui lòng nhập cả mã đơn hàng và số điện thoại đặt hàng.");
            return "redirect:/orders/tracking";
        }

        CustomerOrder order = orderRepository.findByOrderCodeAndRecipientPhone(cleanCode, cleanPhone).orElse(null);
        if (order == null) {
            // Also check by orderCode case-insensitively
            order = orderRepository.findByOrderCode(cleanCode)
                    .filter(o -> cleanPhone.equals(o.getRecipientPhone()))
                    .orElse(null);
        }

        if (order == null) {
            redirect.addFlashAttribute("error", "Không tìm thấy đơn hàng khớp với mã đơn và số điện thoại trên.");
            redirect.addFlashAttribute("searchedCode", cleanCode);
            redirect.addFlashAttribute("searchedPhone", cleanPhone);
            return "redirect:/orders/tracking";
        }

        return "redirect:/orders/" + order.getOrderCode();
    }

    private User getCurrentUser(HttpServletRequest request) {
        Object attr = request.getAttribute("currentUser");
        return (attr instanceof User u) ? u : null;
    }
}
