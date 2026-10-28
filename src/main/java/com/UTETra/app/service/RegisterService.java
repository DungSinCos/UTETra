package com.UTETra.app.service;

import com.UTETra.app.entity.User;
import com.UTETra.app.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.Instant;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.regex.Pattern;

@Service
public class RegisterService {

    public static final String MSG_REGISTER_ERROR = "Có lỗi xảy ra khi tạo tài khoản, vui lòng thử lại";
    public static final String MSG_INVALID_EMAIL = "Email không hợp lệ";
    public static final String MSG_INVALID_PASSWORD = "Mật khẩu phải có ít nhất 8 ký tự";
    public static final String MSG_INVALID_NAME = "Vui lòng nhập họ và tên";
    public static final String MSG_EMAIL_EXISTS = "Email này đã được sử dụng";
    public static final String MSG_INVALID_OTP = "Mã xác thực không đúng hoặc đã hết hạn";

    private static final long OTP_TTL_SECONDS = 600; // 10 minutes

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    public record PendingRegistration(
            String fullName,
            String email,
            String passwordHash,
            String code,
            Instant expiresAt
    ) {
        public boolean isExpired() {
            return Instant.now().isAfter(expiresAt);
        }
    }

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final EmailService emailService;
    private final SecureRandom secureRandom = new SecureRandom();
    private final Map<String, PendingRegistration> pendingRegistrations = new ConcurrentHashMap<>();

    public RegisterService(UserRepository userRepository,
                           PasswordEncoder passwordEncoder,
                           EmailService emailService) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.emailService = emailService;
    }

    /**
     * Step 1: Validates credentials from /register, stores a pending registration with a 6-digit code,
     * and sends the verification email via Google Mail.
     *
     * @return the normalized email address to verify
     */
    @Transactional(readOnly = true)
    public String initiateRegistration(String fullName, String email, String password) {
        if (fullName == null || fullName.trim().isEmpty()) {
            throw new IllegalArgumentException(MSG_INVALID_NAME);
        }

        String normalizedEmail = email == null ? "" : email.trim().toLowerCase();
        if (normalizedEmail.isEmpty() || !EMAIL_PATTERN.matcher(normalizedEmail).matches()) {
            throw new IllegalArgumentException(MSG_INVALID_EMAIL);
        }

        if (password == null || password.length() < 8) {
            throw new IllegalArgumentException(MSG_INVALID_PASSWORD);
        }

        if (userRepository.existsByEmailIgnoreCase(normalizedEmail)) {
            throw new IllegalArgumentException(MSG_EMAIL_EXISTS);
        }

        String code = generateSixDigitCode();
        String trimmedName = fullName.trim();
        PendingRegistration pending = new PendingRegistration(
                trimmedName,
                normalizedEmail,
                passwordEncoder.encode(password),
                code,
                Instant.now().plusSeconds(OTP_TTL_SECONDS)
        );
        pendingRegistrations.put(normalizedEmail, pending);

        emailService.sendVerificationCode(normalizedEmail, trimmedName, code);
        return normalizedEmail;
    }

    /**
     * Step 2: Verifies the 6-digit code entered at /verify-email and inserts the user into the database.
     */
    @Transactional
    public User verifyCodeAndCreateUser(String email, String code) {
        String normalizedEmail = email == null ? "" : email.trim().toLowerCase();
        String normalizedCode = code == null ? "" : code.trim();

        if (normalizedEmail.isEmpty() || !normalizedCode.matches("^\\d{6}$")) {
            throw new IllegalArgumentException(MSG_INVALID_OTP);
        }

        PendingRegistration pending = pendingRegistrations.get(normalizedEmail);
        if (pending == null || pending.isExpired() || !pending.code().equals(normalizedCode)) {
            throw new IllegalArgumentException(MSG_INVALID_OTP);
        }

        if (userRepository.existsByEmailIgnoreCase(normalizedEmail)) {
            pendingRegistrations.remove(normalizedEmail);
            throw new IllegalArgumentException(MSG_EMAIL_EXISTS);
        }

        User user = new User();
        user.setFullName(pending.fullName());
        user.setEmail(pending.email());
        user.setPasswordHash(pending.passwordHash());
        user.setRole(User.Role.CUSTOMER);
        user.setStatus(User.Status.ACTIVE);

        User saved = userRepository.save(user);
        pendingRegistrations.remove(normalizedEmail);
        return saved;
    }

    /**
     * Generates and sends a fresh 6-digit verification code for an existing pending registration.
     */
    public void resendVerificationCode(String email) {
        String normalizedEmail = email == null ? "" : email.trim().toLowerCase();
        PendingRegistration existing = pendingRegistrations.get(normalizedEmail);
        if (existing == null) {
            throw new IllegalArgumentException("Không tìm thấy yêu cầu đăng ký cho email này. Vui lòng đăng ký lại.");
        }

        String newCode = generateSixDigitCode();
        PendingRegistration updated = new PendingRegistration(
                existing.fullName(),
                existing.email(),
                existing.passwordHash(),
                newCode,
                Instant.now().plusSeconds(OTP_TTL_SECONDS)
        );
        pendingRegistrations.put(normalizedEmail, updated);
        emailService.sendVerificationCode(normalizedEmail, existing.fullName(), newCode);
    }

    public boolean hasPendingRegistration(String email) {
        if (email == null || email.isBlank()) {
            return false;
        }
        PendingRegistration pending = pendingRegistrations.get(email.trim().toLowerCase());
        return pending != null && !pending.isExpired();
    }

    private String generateSixDigitCode() {
        return String.format("%06d", secureRandom.nextInt(1_000_000));
    }
}
