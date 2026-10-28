package com.UTETra.app.controller;

import com.UTETra.app.entity.Branch;
import com.UTETra.app.service.BranchService;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

/**
 * Admin CRUD management for UTETra store branches.
 * Restricted to ADMIN and MANAGER roles.
 */
@Controller
@RequestMapping("/admin/branches")
@PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
public class AdminBranchController {

    private static final String FORM_VIEW = "admin/branches/form";

    private final BranchService branchService;

    public AdminBranchController(BranchService branchService) {
        this.branchService = branchService;
    }

    @GetMapping
    public String list(Model model) {
        List<Branch> branches = branchService.findAll();
        long activeCount = branches.stream().filter(Branch::isActive).count();
        long inactiveCount = branches.size() - activeCount;

        model.addAttribute("branches", branches);
        model.addAttribute("totalCount", branches.size());
        model.addAttribute("activeCount", activeCount);
        model.addAttribute("inactiveCount", inactiveCount);
        return "admin/branches/list";
    }

    @GetMapping("/new")
    public String createForm(Model model) {
        Branch branch = new Branch();
        branch.setCity("TP. Hồ Chí Minh");
        model.addAttribute("branch", branch);
        model.addAttribute("formAction", "/admin/branches");
        return FORM_VIEW;
    }

    @PostMapping
    public String create(@ModelAttribute("branch") Branch branch,
                         Model model,
                         RedirectAttributes redirect) {
        try {
            branchService.create(branch);
        } catch (IllegalArgumentException ex) {
            model.addAttribute("error", ex.getMessage());
            model.addAttribute("formAction", "/admin/branches");
            return FORM_VIEW;
        }
        redirect.addFlashAttribute("message", "Đã thêm chi nhánh mới thành công!");
        return "redirect:/admin/branches";
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Long id, Model model) {
        model.addAttribute("branch", branchService.getById(id));
        model.addAttribute("formAction", "/admin/branches/" + id);
        return FORM_VIEW;
    }

    @PostMapping("/{id}")
    public String update(@PathVariable Long id,
                         @ModelAttribute("branch") Branch branch,
                         Model model,
                         RedirectAttributes redirect) {
        try {
            branchService.update(id, branch);
        } catch (IllegalArgumentException ex) {
            branch.setId(id);
            model.addAttribute("error", ex.getMessage());
            model.addAttribute("formAction", "/admin/branches/" + id);
            return FORM_VIEW;
        }
        redirect.addFlashAttribute("message", "Đã cập nhật thông tin chi nhánh thành công!");
        return "redirect:/admin/branches";
    }

    @PostMapping("/{id}/hide")
    public String hide(@PathVariable Long id, RedirectAttributes redirect) {
        branchService.deactivate(id);
        redirect.addFlashAttribute("message", "Đã tạm dừng hoạt động chi nhánh");
        return "redirect:/admin/branches";
    }

    @PostMapping("/{id}/show")
    public String show(@PathVariable Long id, RedirectAttributes redirect) {
        branchService.activate(id);
        redirect.addFlashAttribute("message", "Đã kích hoạt hoạt động chi nhánh");
        return "redirect:/admin/branches";
    }
}
