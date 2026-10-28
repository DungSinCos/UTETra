package com.UTETra.app.controller;

import com.UTETra.app.dto.AdminUserSummary;
import com.UTETra.app.entity.User;
import com.UTETra.app.service.UserAccountService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/users")
@PreAuthorize("hasRole('ADMIN')")
public class AdminUserController {

    private static final int PAGE_SIZE = 20;

    private final UserAccountService userAccountService;

    public AdminUserController(UserAccountService userAccountService) {
        this.userAccountService = userAccountService;
    }

    @GetMapping
    public String list(@RequestParam(required = false) String q,
                       @RequestParam(required = false) User.Status status,
                       @RequestParam(defaultValue = "0") int page,
                       Model model) {
        Pageable pageable = PageRequest.of(Math.max(page, 0), PAGE_SIZE,
                Sort.by(Sort.Direction.DESC, "createdAt"));
        Page<AdminUserSummary> users = userAccountService.searchUsers(q, status, pageable);
        model.addAttribute("userPage", users);
        model.addAttribute("query", q);
        model.addAttribute("selectedStatus", status);
        model.addAttribute("statuses", User.Status.values());
        return "admin/users/list";
    }

    @GetMapping("/{id}")
    public String detail(@PathVariable Long id, Model model) {
        model.addAttribute("user", userAccountService.getAdminUser(id));
        model.addAttribute("roles", User.Role.values());
        return "admin/users/detail";
    }

    @PostMapping("/{id}/status")
    public String updateStatus(@PathVariable Long id,
                               @RequestParam User.Status status,
                               Authentication authentication,
                               RedirectAttributes redirect) {
        try {
            Long actorId = userAccountService.getByEmail(authentication.getName()).getId();
            userAccountService.updateStatus(id, status, actorId);
            redirect.addFlashAttribute("message", "Đã cập nhật trạng thái tài khoản");
        } catch (IllegalArgumentException ex) {
            redirect.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/admin/users/" + id;
    }

    @PostMapping("/{id}/role")
    @PreAuthorize("hasRole('ADMIN')")
    public String updateRole(@PathVariable Long id,
                             @RequestParam User.Role role,
                             Authentication authentication,
                             RedirectAttributes redirect) {
        try {
            Long actorId = userAccountService.getByEmail(authentication.getName()).getId();
            userAccountService.updateRole(id, role, actorId);
            redirect.addFlashAttribute("message", "Đã cập nhật vai trò tài khoản");
        } catch (IllegalArgumentException ex) {
            redirect.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/admin/users/" + id;
    }
}
