package com.UTETra.app.service;

import com.UTETra.app.entity.User;
import com.UTETra.app.repository.UserRepository;
import com.UTETra.app.security.JwtService;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
public class AuthService {

    public static final String MSG_BAD_CREDENTIALS = "Email hoặc mật khẩu không đúng";
    public static final String MSG_LOCKED = "Tài khoản của bạn đã bị khóa";
    public static final String MSG_INACTIVE = "Tài khoản của bạn chưa được kích hoạt";

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final String dummyHash;

    public AuthService(UserRepository userRepository, PasswordEncoder passwordEncoder, JwtService jwtService) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
        this.dummyHash = passwordEncoder.encode(UUID.randomUUID().toString());
    }

    public record LoginResult(User user, String token) {}

    @Transactional(readOnly = true)
    public LoginResult authenticate(String email, String password) {
        if (email == null || email.isBlank() || password == null || password.isEmpty()) {
            throw new BadCredentialsException(MSG_BAD_CREDENTIALS);
        }

        User user = userRepository.findByEmailIgnoreCase(email.trim()).orElse(null);
        if (user == null) {
            passwordEncoder.matches(password, dummyHash);
            throw new BadCredentialsException(MSG_BAD_CREDENTIALS);
        }
        if (user.getPasswordHash() == null || !passwordEncoder.matches(password, user.getPasswordHash())) {
            throw new BadCredentialsException(MSG_BAD_CREDENTIALS);
        }

        switch (user.getStatus()) {
            case LOCKED -> throw new LockedException(MSG_LOCKED);
            case INACTIVE -> throw new DisabledException(MSG_INACTIVE);
            default -> { }
        }

        return new LoginResult(user, jwtService.generateToken(user));
    }

    @Transactional(readOnly = true)
    public String login(String email, String password) {
        return authenticate(email, password).token();
    }
}
