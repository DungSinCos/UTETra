package com.UTETra.app.controller;

import com.UTETra.app.service.ProductService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Admin entry point. Each admin module gets its own controller under /admin/** (products,
 * orders, users...) and registers a card on the dashboard by adding an attribute here.
 * <p>
 * TODO(Auth owner): /admin/** is NOT protected yet. Once login is merged, restrict it in
 * SecurityConfig, e.g. .requestMatchers("/admin/**").hasRole("ADMIN"), instead of checking
 * the session inside controllers.
 */
@Controller
@RequestMapping("/admin")
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
