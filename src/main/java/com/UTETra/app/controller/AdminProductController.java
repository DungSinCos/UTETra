package com.UTETra.app.controller;

import com.UTETra.app.entity.Product;
import com.UTETra.app.exception.FileStorageException;
import com.UTETra.app.service.ProductService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * Product management for admins (list, create, edit, show/hide).
 * Products are hidden rather than deleted so past orders keep a valid reference.
 * See the TODO in AdminController about protecting /admin/**.
 */
@Controller
@RequestMapping("/admin/products")
public class AdminProductController {

    private static final String FORM_VIEW = "admin/products/form";

    private final ProductService productService;

    public AdminProductController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping
    public String list(Model model) {
        model.addAttribute("products", productService.findAll());
        return "admin/products/list";
    }

    @GetMapping("/new")
    public String createForm(Model model) {
        model.addAttribute("product", new Product());
        model.addAttribute("formAction", "/admin/products");
        return FORM_VIEW;
    }

    @PostMapping
    public String create(@ModelAttribute("product") Product product,
                         @RequestParam(value = "image", required = false) MultipartFile image,
                         Model model,
                         RedirectAttributes redirect) {
        try {
            productService.create(product, image);
        } catch (IllegalArgumentException | FileStorageException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("formAction", "/admin/products");
            return FORM_VIEW; // redisplay with what the admin already typed
        }
        redirect.addFlashAttribute("message", "Đã thêm sản phẩm");
        return "redirect:/admin/products";
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Long id, Model model) {
        model.addAttribute("product", productService.getById(id));
        model.addAttribute("formAction", "/admin/products/" + id);
        return FORM_VIEW;
    }

    @PostMapping("/{id}")
    public String update(@PathVariable Long id,
                         @ModelAttribute("product") Product product,
                         @RequestParam(value = "image", required = false) MultipartFile image,
                         Model model,
                         RedirectAttributes redirect) {
        try {
            productService.update(id, product, image);
        } catch (IllegalArgumentException | FileStorageException e) {
            product.setId(id);
            model.addAttribute("error", e.getMessage());
            model.addAttribute("formAction", "/admin/products/" + id);
            return FORM_VIEW;
        }
        redirect.addFlashAttribute("message", "Đã cập nhật sản phẩm");
        return "redirect:/admin/products";
    }

    @PostMapping("/{id}/hide")
    public String hide(@PathVariable Long id, RedirectAttributes redirect) {
        productService.deactivate(id);
        redirect.addFlashAttribute("message", "Đã ẩn sản phẩm khỏi thực đơn");
        return "redirect:/admin/products";
    }

    @PostMapping("/{id}/show")
    public String show(@PathVariable Long id, RedirectAttributes redirect) {
        productService.activate(id);
        redirect.addFlashAttribute("message", "Đã hiển thị lại sản phẩm");
        return "redirect:/admin/products";
    }
}
