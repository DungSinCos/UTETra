package com.UTETra.app.controller;

import com.UTETra.app.service.ProductService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Public, read-only product pages. Writes live in AdminProductController (/admin/products).
 * <p>
 * TODO(HomePage / Cart owners): add GET /products/{slug} (detail page) when its JSP exists;
 * ProductService.getBySlug(...) is ready.
 */
@Controller
@RequestMapping("/products")
public class ProductController {

    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    /** GET /products or GET /products?categoryId=3 */
    @GetMapping
    public String list(@RequestParam(required = false) Long categoryId, Model model) {
        model.addAttribute("products",
                categoryId == null
                        ? productService.findActive()
                        : productService.findActiveByCategory(categoryId));
        model.addAttribute("categoryId", categoryId);
        return "products/list"; // /WEB-INF/views/products/list.jsp
    }
}
