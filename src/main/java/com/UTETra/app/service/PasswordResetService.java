package com.UTETra.app.service;

import com.UTETra.app.entity.PasswordResetToken;
import com.UTETra.app.entity.User;
import com.UTETra.app.repository.PasswordResetTokenRepository;
import com.UTETra.app.repository.UserRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.util.UriComponentsBuilder;

import java.time.LocalDateTime;
import java.util.Locale;
import java.util.UUID;

/** Creates time-limited password reset links and consumes them once. */
@Service
public class PasswordResetService {

    private static final int TOKEN_LIFETIME_MINUTES = 30;

    private final UserRepository userRepository;
    private final PasswordResetTokenRepository tokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final JavaMailSender mailSender;
    private final String mailFrom;
    private final String baseUrl;

    public PasswordResetService(UserRepository userRepository,
                                PasswordResetTokenRepository tokenRepository,
                                PasswordEncoder passwordEncoder,
                                JavaMailSender mailSender,
                                @Value("${app.mail.from:no-reply@utetra.local}") String mailFrom,
                                @Value("${app.password-reset.base-url:http://localhost:8080}") String baseUrl) {
        this.userRepository = userRepository;
        this.tokenRepository = tokenRepository;
        this.passwordEncoder = passwordEncoder;
        this.mailSender = mailSender;
        this.mailFrom = mailFrom;
        this.baseUrl = baseUrl;
    }

    /** Unknown addresses intentionally receive no email; the controller displays one generic response. */
    @Transactional
    public void requestReset(String email) {
        if (email == null || email.isBlank()) {
            throw new IllegalArgumentException("Vui lòng nhập email");
        }

        User user = userRepository.findByEmailIgnoreCase(email.trim().toLowerCase(Locale.ROOT)).orElse(null);
        if (user == null || user.getStatus() != User.Status.ACTIVE) {
            return;
        }

        tokenRepository.deleteByUserAndUsedFalse(user);
        String tokenValue = UUID.randomUUID().toString();
        PasswordResetToken token = new PasswordResetToken();
        token.setToken(tokenValue);
        token.setUser(user);
        token.setExpiryDate(LocalDateTime.now().plusMinutes(TOKEN_LIFETIME_MINUTES));
        token.setUsed(false);
        tokenRepository.save(token);

        String resetUrl = UriComponentsBuilder.fromUriString(baseUrl)
                .path("/reset-password")
                .queryParam("token", tokenValue)
                .build().toUriString();
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom(mailFrom);
        message.setTo(user.getEmail());
        message.setSubject("Đặt lại mật khẩu UTETra");
        message.setText("Xin chào " + user.getFullName() + ",\n\n"
                + "Mở liên kết sau trong vòng " + TOKEN_LIFETIME_MINUTES + " phút để đặt mật khẩu mới:\n"
                + resetUrl + "\n\nNếu bạn không yêu cầu, hãy bỏ qua email này.");
        try {
            mailSender.send(message);
        } catch (MailException ex) {
            throw new IllegalStateException("Không gửi được email đặt lại mật khẩu. Hãy kiểm tra cấu hình SMTP.", ex);
        }
    }

    @Transactional(readOnly = true)
    public boolean isTokenValid(String tokenValue) {
        if (tokenValue == null || tokenValue.isBlank()) {
            return false;
        }
        return tokenRepository.findByTokenAndUsedFalse(tokenValue.trim())
                .filter(token -> token.getExpiryDate().isAfter(LocalDateTime.now()))
                .isPresent();
    }

    @Transactional
    public void resetPassword(String tokenValue, String newPassword) {
        if (newPassword == null || newPassword.length() < 8) {
            throw new IllegalArgumentException("Mật khẩu phải có ít nhất 8 ký tự");
        }
        PasswordResetToken token = tokenRepository.findByTokenAndUsedFalse(
                        tokenValue == null ? "" : tokenValue.trim())
                .filter(candidate -> candidate.getExpiryDate().isAfter(LocalDateTime.now()))
                .orElseThrow(() -> new IllegalArgumentException("Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn"));

        User user = token.getUser();
        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(user);
        token.setUsed(true);
        tokenRepository.save(token);
    }
}
