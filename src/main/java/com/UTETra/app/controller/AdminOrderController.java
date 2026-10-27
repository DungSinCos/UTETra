package com.UTETra.app.controller;

import com.UTETra.app.dto.AdminOrderDetail;
import com.UTETra.app.entity.CustomerOrder;
import com.UTETra.app.service.OrderService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;

@Controller
@RequestMapping("/admin/orders")
@PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
public class AdminOrderController {

    private static final int PAGE_SIZE = 20;

    private final OrderService orderService;

    public AdminOrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    @GetMapping
    public String list(@RequestParam(required = false) String orderCode,
                       @RequestParam(required = false) CustomerOrder.OrderStatus status,
                       @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
                       @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to,
                       @RequestParam(defaultValue = "0") int page,
                       Model model) {
        Pageable pageable = PageRequest.of(Math.max(page, 0), PAGE_SIZE,
                Sort.by(Sort.Direction.DESC, "createdAt"));
        Page<CustomerOrder> orders;
        try {
            orders = orderService.search(orderCode, status, from, to, pageable);
        } catch (IllegalArgumentException ex) {
            orders = Page.empty(pageable);
            model.addAttribute("error", ex.getMessage());
        }
        model.addAttribute("orderPage", orders);
        model.addAttribute("orderStatuses", CustomerOrder.OrderStatus.values());
        model.addAttribute("orderCode", orderCode);
        model.addAttribute("selectedStatus", status);
        model.addAttribute("from", from);
        model.addAttribute("to", to);
        return "admin/orders/list";
    }

    @GetMapping("/{id}")
    public String detail(@PathVariable Long id, Model model) {
        AdminOrderDetail detail = orderService.getDetail(id);
        model.addAttribute("order", detail.order());
        model.addAttribute("items", detail.items());
        model.addAttribute("payments", detail.payments());
        model.addAttribute("nextStatuses", detail.nextStatuses());
        return "admin/orders/detail";
    }

    @PostMapping("/{id}/status")
    public String updateStatus(@PathVariable Long id,
                               @RequestParam CustomerOrder.OrderStatus status,
                               RedirectAttributes redirect) {
        try {
            orderService.updateStatus(id, status);
            redirect.addFlashAttribute("message", "Đã cập nhật trạng thái đơn hàng");
        } catch (IllegalArgumentException ex) {
            redirect.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/admin/orders/" + id;
    }
}
