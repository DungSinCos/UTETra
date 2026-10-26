package com.UTETra.app.controller;

import com.UTETra.app.service.ProductService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Collections;

/**
 * Public, read-only product pages. Writes live in AdminProductController (/admin/products).
 */
@Controller
@RequestMapping("/products")
public class ProductController {

    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    /** GET /products or GET /products?category=tra-sua */
    @GetMapping
    public String list(@RequestParam(required = false) Long categoryId,
                       @RequestParam(required = false) String category,
                       Model model) {
        try {
            model.addAttribute("products",
                    categoryId == null
                            ? productService.findActive()
                            : productService.findActiveByCategory(categoryId));
        } catch (Exception ignored) {
            model.addAttribute("products", Collections.emptyList());
        }
        model.addAttribute("categoryId", categoryId);
        model.addAttribute("selectedCategory", category != null ? category : "all");
        return "products/list"; // /WEB-INF/views/products/list.jsp
    }

    /** GET /products/{id} */
    @GetMapping("/{id}")
    public String detail(@PathVariable("id") Long id, Model model) {
        model.addAttribute("productId", id);
        try {
            model.addAttribute("product", productService.getById(id));
        } catch (Exception ignored) {
            // Fallback to mocked product data in detail.jsp when DB has no record
        }
        return "products/detail"; // /WEB-INF/views/products/detail.jsp
    }
}

