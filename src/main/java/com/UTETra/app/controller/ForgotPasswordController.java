package com.UTETra.app.controller;

import com.UTETra.app.service.PasswordResetService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class ForgotPasswordController {

    private final PasswordResetService passwordResetService;

    public ForgotPasswordController(PasswordResetService passwordResetService) {
        this.passwordResetService = passwordResetService;
    }

    @GetMapping("/forgot-password")
    public String forgotPassword() {
        return "forgot-password";
    }

    @PostMapping("/forgot-password")
    public String requestReset(@RequestParam(required = false) String email,
                               Model model,
                               RedirectAttributes redirect) {
        try {
            passwordResetService.requestReset(email);
            redirect.addFlashAttribute("message",
                    "Nếu email thuộc tài khoản đang hoạt động, hướng dẫn đặt lại mật khẩu sẽ được gửi đến hộp thư.");
            return "redirect:/forgot-password";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("error", ex.getMessage());
            model.addAttribute("email", email);
            return "forgot-password";
        } catch (IllegalStateException ex) {
            model.addAttribute("error", "Chưa gửi được email. Vui lòng thử lại sau hoặc liên hệ quản trị viên.");
            model.addAttribute("email", email);
            return "forgot-password";
        }
    }

    @GetMapping("/reset-password")
    public String resetPasswordForm(@RequestParam(required = false) String token, Model model) {
        boolean valid = passwordResetService.isTokenValid(token);
        model.addAttribute("token", token);
        model.addAttribute("validToken", valid);
        if (!valid) {
            model.addAttribute("error", "Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.");
        }
        return "reset-password";
    }

    @PostMapping("/reset-password")
    public String resetPassword(@RequestParam(required = false) String token,
                                @RequestParam(required = false) String newPassword,
                                @RequestParam(required = false) String confirmPassword,
                                Model model,
                                RedirectAttributes redirect) {
        if (newPassword == null || !newPassword.equals(confirmPassword)) {
            model.addAttribute("error", "Mật khẩu xác nhận không khớp.");
            model.addAttribute("token", token);
            model.addAttribute("validToken", passwordResetService.isTokenValid(token));
            return "reset-password";
        }
        try {
            passwordResetService.resetPassword(token, newPassword);
            redirect.addFlashAttribute("message", "Đặt lại mật khẩu thành công. Hãy đăng nhập bằng mật khẩu mới.");
            return "redirect:/login";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("error", ex.getMessage());
            model.addAttribute("token", token);
            model.addAttribute("validToken", passwordResetService.isTokenValid(token));
            return "reset-password";
        }
    }
}
