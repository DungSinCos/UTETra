package com.UTETra.app.controller;

import com.UTETra.app.service.ProductService;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

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

    public AdminController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping
    public String index() {
        return "redirect:/admin/dashboard";
    }

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("activeProducts", productService.countActive());
        // TODO: orders today, revenue, new users... add attributes as those modules appear
        return "admin/dashboard"; // /WEB-INF/views/admin/dashboard.jsp
    }
}
