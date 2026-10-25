package com.UTETra.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Chỉ hiển thị trang login / register.
 * Phần xử lý POST (kiểm tra tài khoản, lưu user, JWT) sẽ do người làm auth bổ sung.
 */
@Controller
public class AuthController {

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @GetMapping("/register")
    public String register() {
        return "register";
    }
}
