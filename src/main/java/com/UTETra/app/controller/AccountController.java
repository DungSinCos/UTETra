package com.UTETra.app.controller;

import com.UTETra.app.dto.AccountProfileForm;
import com.UTETra.app.dto.PasswordChangeForm;
import com.UTETra.app.entity.CustomerOrder;
import com.UTETra.app.entity.User;
import com.UTETra.app.service.OrderService;
import com.UTETra.app.service.UserAccountService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/account")
@PreAuthorize("isAuthenticated()")
public class AccountController {

    private static final int ORDER_PAGE_SIZE = 10;

    private final UserAccountService userAccountService;
    private final OrderService orderService;

    public AccountController(UserAccountService userAccountService, OrderService orderService) {
        this.userAccountService = userAccountService;
        this.orderService = orderService;
    }

    @GetMapping("/profile")
    public String profile(Authentication authentication, Model model) {
        User user = userAccountService.getByEmail(authentication.getName());
        model.addAttribute("profile", new AccountProfileForm(user.getFullName(), user.getPhone()));
        model.addAttribute("email", user.getEmail());
        return "account/profile";
    }

    @PostMapping("/profile")
    public String updateProfile(Authentication authentication,
                                @ModelAttribute("profile") AccountProfileForm profile,
                                Model model,
                                RedirectAttributes redirect) {
        try {
            userAccountService.updateProfile(authentication.getName(), profile);
            redirect.addFlashAttribute("message", "Đã cập nhật hồ sơ");
            return "redirect:/account/profile";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("error", ex.getMessage());
            model.addAttribute("email", userAccountService.getByEmail(authentication.getName()).getEmail());
            return "account/profile";
        }
    }

    @GetMapping("/change-password")
    public String changePassword(Model model) {
        model.addAttribute("passwordForm", new PasswordChangeForm());
        return "account/change-password";
    }

    @PostMapping("/change-password")
    public String updatePassword(Authentication authentication,
                                 @ModelAttribute("passwordForm") PasswordChangeForm passwordForm,
                                 Model model,
                                 RedirectAttributes redirect) {
        try {
            userAccountService.changePassword(authentication.getName(), passwordForm);
            redirect.addFlashAttribute("message", "Đã đổi mật khẩu");
            return "redirect:/account/profile";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("error", ex.getMessage());
            return "account/change-password";
        }
    }

    @GetMapping("/orders")
    public String orders(Authentication authentication,
                         @RequestParam(defaultValue = "0") int page,
                         Model model) {
        User user = userAccountService.getByEmail(authentication.getName());
        Page<CustomerOrder> orders = orderService.findForUser(user.getId(),
                PageRequest.of(Math.max(page, 0), ORDER_PAGE_SIZE, Sort.by(Sort.Direction.DESC, "createdAt")));
        model.addAttribute("orderPage", orders);
        return "account/orders";
    }
}
