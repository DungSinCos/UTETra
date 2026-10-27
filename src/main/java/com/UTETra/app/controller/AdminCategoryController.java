package com.UTETra.app.controller;

import com.UTETra.app.entity.Category;
import com.UTETra.app.service.CategoryService;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/** Admin CRUD for categories. Deactivation is used instead of physical deletion. */
@Controller
@RequestMapping("/admin/categories")
@PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
public class AdminCategoryController {

    private static final String FORM_VIEW = "admin/categories/form";

    private final CategoryService categoryService;

    public AdminCategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @GetMapping
    public String list(Model model) {
        model.addAttribute("categories", categoryService.findAll());
        return "admin/categories/list";
    }

    @GetMapping("/new")
    public String createForm(Model model) {
        model.addAttribute("category", new Category());
        model.addAttribute("formAction", "/admin/categories");
        return FORM_VIEW;
    }

    @PostMapping
    public String create(@ModelAttribute("category") Category category,
                         Model model,
                         RedirectAttributes redirect) {
        try {
            categoryService.create(category);
        } catch (IllegalArgumentException ex) {
            model.addAttribute("error", ex.getMessage());
            model.addAttribute("formAction", "/admin/categories");
            return FORM_VIEW;
        }
        redirect.addFlashAttribute("message", "Đã thêm danh mục");
        return "redirect:/admin/categories";
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Long id, Model model) {
        model.addAttribute("category", categoryService.getById(id));
        model.addAttribute("formAction", "/admin/categories/" + id);
        return FORM_VIEW;
    }

    @PostMapping("/{id}")
    public String update(@PathVariable Long id,
                         @ModelAttribute("category") Category category,
                         Model model,
                         RedirectAttributes redirect) {
        try {
            categoryService.update(id, category);
        } catch (IllegalArgumentException ex) {
            category.setId(id);
            model.addAttribute("error", ex.getMessage());
            model.addAttribute("formAction", "/admin/categories/" + id);
            return FORM_VIEW;
        }
        redirect.addFlashAttribute("message", "Đã cập nhật danh mục");
        return "redirect:/admin/categories";
    }

    @PostMapping("/{id}/hide")
    public String hide(@PathVariable Long id, RedirectAttributes redirect) {
        categoryService.deactivate(id);
        redirect.addFlashAttribute("message", "Đã ẩn danh mục khỏi thực đơn");
        return "redirect:/admin/categories";
    }

    @PostMapping("/{id}/show")
    public String show(@PathVariable Long id, RedirectAttributes redirect) {
        categoryService.activate(id);
        redirect.addFlashAttribute("message", "Đã hiển thị lại danh mục");
        return "redirect:/admin/categories";
    }
}
