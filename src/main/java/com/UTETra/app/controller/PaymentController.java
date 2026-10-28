package com.UTETra.app.controller;

import com.UTETra.app.entity.CustomerOrder;
import com.UTETra.app.entity.PaymentTransaction;
import com.UTETra.app.repository.OrderRepository;
import com.UTETra.app.repository.PaymentTransactionRepository;
import com.UTETra.app.service.VNPayService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/payment")
public class PaymentController {

    private final VNPayService vnpayService;
    private final OrderRepository orderRepository;
    private final PaymentTransactionRepository paymentTransactionRepository;

    public PaymentController(VNPayService vnpayService,
                             OrderRepository orderRepository,
                             PaymentTransactionRepository paymentTransactionRepository) {
        this.vnpayService = vnpayService;
        this.orderRepository = orderRepository;
        this.paymentTransactionRepository = paymentTransactionRepository;
    }

    @GetMapping("/vnpay-return")
    public String vnpayReturn(HttpServletRequest request, RedirectAttributes redirect) {
        Map<String, String> params = new HashMap<>();
        Enumeration<String> parameterNames = request.getParameterNames();
        while (parameterNames.hasMoreElements()) {
            String paramName = parameterNames.nextElement();
            params.put(paramName, request.getParameter(paramName));
        }

        boolean validSignature = vnpayService.verifySignature(params);
        String orderCode = vnpayService.getOrderCode(params);

        if (!validSignature || orderCode == null) {
            redirect.addFlashAttribute("error", "Chữ ký xác thực thanh toán không hợp lệ!");
            return "redirect:/orders/tracking";
        }

        CustomerOrder order = orderRepository.findByOrderCode(orderCode).orElse(null);
        if (order == null) {
            redirect.addFlashAttribute("error", "Không tìm thấy đơn hàng tương ứng với mã: " + orderCode);
            return "redirect:/orders/tracking";
        }

        boolean success = vnpayService.isPaymentSuccess(params);
        String transactionRef = vnpayService.getTransactionRef(params);

        PaymentTransaction transaction = paymentTransactionRepository
                .findTopByOrder_IdOrderByCreatedAtDesc(order.getId())
                .orElseGet(() -> {
                    PaymentTransaction pt = new PaymentTransaction();
                    pt.setOrder(order);
                    pt.setProvider(PaymentTransaction.Provider.VNPAY);
                    pt.setAmount(order.getTotalAmount());
                    return pt;
                });

        transaction.setTransactionRef(transactionRef != null ? transactionRef : "VNP-" + System.currentTimeMillis());
        if (success) {
            order.setPaymentStatus(CustomerOrder.PaymentStatus.PAID);
            transaction.setStatus(PaymentTransaction.Status.SUCCESS);
            transaction.setPaidAt(LocalDateTime.now());
            orderRepository.save(order);
            paymentTransactionRepository.save(transaction);
            redirect.addFlashAttribute("paymentSuccessMsg", "Thanh toán qua VNPay thành công!");
            return "redirect:/orders/" + orderCode + "?paymentSuccess=true";
        } else {
            String responseCode = params.get("vnp_ResponseCode");
            String reason = vnpayService.getResponseDescription(responseCode);
            order.setPaymentStatus(CustomerOrder.PaymentStatus.FAILED);
            transaction.setStatus(PaymentTransaction.Status.FAILED);
            orderRepository.save(order);
            paymentTransactionRepository.save(transaction);
            redirect.addFlashAttribute("paymentErrorMsg", "Thanh toán VNPay không thành công: " + reason);
            return "redirect:/orders/" + orderCode + "?paymentFailed=true";
        }
    }
}
