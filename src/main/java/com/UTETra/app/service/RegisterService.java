package com.UTETra.app.service;

import com.UTETra.app.entity.User;
import com.UTETra.app.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.regex.Pattern;

@Service
public class RegisterService {

    public static final String MSG_REGISTER_ERROR = "Có lỗi xảy ra khi tạo tài khoản, vui lòng thử lại";
    public static final String MSG_INVALID_EMAIL = "Email không hợp lệ";
    public static final String MSG_INVALID_PASSWORD = "Mật khẩu phải có ít nhất 8 ký tự";
    public static final String MSG_INVALID_NAME = "Vui lòng nhập họ và tên";
    public static final String MSG_EMAIL_EXISTS = "Email này đã được sử dụng";

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public RegisterService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public User register(String fullName, String email, String password) {
        if (fullName == null || fullName.trim().isEmpty()) {
            throw new IllegalArgumentException(MSG_INVALID_NAME);
        }

        String normalizedEmail = email == null ? "" : email.trim();
        if (normalizedEmail.isEmpty() || !EMAIL_PATTERN.matcher(normalizedEmail).matches()) {
            throw new IllegalArgumentException(MSG_INVALID_EMAIL);
        }

        if (password == null || password.length() < 8) {
            throw new IllegalArgumentException(MSG_INVALID_PASSWORD);
        }

        if (userRepository.existsByEmailIgnoreCase(normalizedEmail)) {
            throw new IllegalArgumentException(MSG_EMAIL_EXISTS);
        }

        User user = new User();
        user.setFullName(fullName.trim());
        user.setEmail(normalizedEmail);
        user.setPasswordHash(passwordEncoder.encode(password));
        user.setAuthProvider(User.AuthProvider.LOCAL);
        user.setRole(User.Role.CUSTOMER);
        user.setStatus(User.Status.ACTIVE);

        return userRepository.save(user);
    }
}
