package com.UTETra.app.controller;

import com.UTETra.app.dto.OrderDashboardSummary;
import com.UTETra.app.service.ProductService;
import com.UTETra.app.service.OrderService;
import java.math.BigDecimal;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;

/**
 * Admin entry point. Each admin module gets its own controller under /admin/** (products,
 * orders, users...) and registers a card on the dashboard by adding an attribute here.
 * Restricted to ADMIN and MANAGER roles via both SecurityConfig and @PreAuthorize.
 */
@Controller
@RequestMapping("/admin")
@PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
public class AdminController {

    private final ProductService productService;
    private final OrderService orderService;

    public AdminController(ProductService productService, OrderService orderService) {
        this.productService = productService;
        this.orderService = orderService;
    }

    @GetMapping
    public String index() {
        return "redirect:/admin/dashboard";
    }

    @GetMapping("/dashboard")
    public String dashboard(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to,
            Model model) {
        LocalDate today = LocalDate.now();
        if (to == null) {
            to = today;
        }
        if (from == null) {
            from = to.minusDays(29);
        }

        long total = productService.findAll().size();
        long active = productService.countActive();
        model.addAttribute("totalProducts", total);
        model.addAttribute("activeProducts", active);
        model.addAttribute("hiddenProducts", total - active);
        model.addAttribute("featuredProducts", productService.findFeatured().size());
        OrderDashboardSummary orders;
        try {
            orders = orderService.dashboardSummary(from, to);
        } catch (IllegalArgumentException ex) {
            orders = new OrderDashboardSummary(0, 0, BigDecimal.ZERO);
            model.addAttribute("dateError", ex.getMessage());
        }
        model.addAttribute("orderSummary", orders);
        model.addAttribute("from", from);
        model.addAttribute("to", to);
        return "admin/dashboard"; // /WEB-INF/views/admin/dashboard.jsp
    }
}
