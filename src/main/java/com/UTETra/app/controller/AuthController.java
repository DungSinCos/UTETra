package com.UTETra.app.controller;

import com.UTETra.app.dto.AuthResponse;
import com.UTETra.app.entity.User;
import com.UTETra.app.security.JwtAuthenticationFilter;
import com.UTETra.app.security.JwtService;
import com.UTETra.app.service.AuthService;
import com.UTETra.app.service.RegisterService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseCookie;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.Duration;

@Controller
public class AuthController {

    private final AuthService authService;
    private final RegisterService registerService;
    private final JwtService jwtService;

    public AuthController(AuthService authService, RegisterService registerService, JwtService jwtService) {
        this.authService = authService;
        this.registerService = registerService;
        this.jwtService = jwtService;
    }

    /**
     * Renders the login page, or automatically redirects if the user already has a valid JWT cookie.
     */
    @GetMapping("/login")
    public String login(HttpServletRequest request) {
        Object current = request.getAttribute("currentUser");
        if (current instanceof User user) {
            return "redirect:" + resolveHomePath(user.getRole());
        }
        return "login";
    }

    /**
     * Validates email and password from /login, issues a signed JWT, stores it in an HttpOnly
     * persistent cookie so future visits automatically authenticate, and returns JSON to the client.
     */
    @PostMapping(value = "/login", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<AuthResponse> doLogin(@RequestParam(required = false) String email,
                                                @RequestParam(required = false) String password,
                                                @RequestParam(name = "remember-me", defaultValue = "false") boolean rememberMe,
                                                HttpServletRequest request) {
        AuthService.LoginResult result = authService.authenticate(email, password);

        Duration cookieLifetime = rememberMe
                ? Duration.ofDays(7)
                : Duration.ofMillis(jwtService.getExpirationMs());

        ResponseCookie cookie = ResponseCookie.from(JwtAuthenticationFilter.COOKIE_NAME, result.token())
                .httpOnly(true)
                .secure(request.isSecure())
                .sameSite("Lax")
                .path("/")
                .maxAge(cookieLifetime)
                .build();

        String targetPath = resolveHomePath(result.user().getRole());

        return ResponseEntity.ok()
                .header(HttpHeaders.SET_COOKIE, cookie.toString())
                .body(new AuthResponse(true, "Đăng nhập thành công!", request.getContextPath() + targetPath));
    }

    /**
     * Renders the registration page, or redirects if the user is already logged in.
     */
    @GetMapping("/register")
    public String register(HttpServletRequest request) {
        Object current = request.getAttribute("currentUser");
        if (current instanceof User user) {
            return "redirect:" + resolveHomePath(user.getRole());
        }
        return "register";
    }

    /**
     * Step 1 of registration: validates credentials, sends a 6-digit verification code via Google Mail,
     * and redirects the client to /verify-email.
     */
    @PostMapping(value = "/register", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<AuthResponse> doRegister(@RequestParam(required = false) String fullName,
                                                   @RequestParam(required = false) String email,
                                                   @RequestParam(required = false) String password,
                                                   HttpServletRequest request) {
        try {
            String normalizedEmail = registerService.initiateRegistration(fullName, email, password);
            String redirectUrl = request.getContextPath() + "/verify-email?email="
                    + URLEncoder.encode(normalizedEmail, StandardCharsets.UTF_8);
            return ResponseEntity.ok(
                    new AuthResponse(true, "Mã xác thực 6 chữ số đã được gửi tới email của bạn!", redirectUrl)
            );
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(AuthResponse.error(RegisterService.MSG_REGISTER_ERROR));
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(AuthResponse.error(RegisterService.MSG_REGISTER_ERROR));
        }
    }

    /**
     * Renders the /verify-email page where the user enters the 6-digit verification code.
     */
    @GetMapping("/verify-email")
    public String verifyEmailPage(@RequestParam(required = false) String email,
                                  HttpServletRequest request,
                                  Model model) {
        Object current = request.getAttribute("currentUser");
        if (current instanceof User user) {
            return "redirect:" + resolveHomePath(user.getRole());
        }
        if (email == null || email.isBlank()) {
            return "redirect:/register";
        }
        model.addAttribute("verifyEmail", email.trim());
        return "verify-email";
    }

    /**
     * Step 2 of registration: verifies the 6-digit code and creates the active user in the database.
     */
    @PostMapping(value = "/verify-email", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<AuthResponse> doVerifyEmail(@RequestParam(required = false) String email,
                                                      @RequestParam(required = false) String code,
                                                      HttpServletRequest request) {
        try {
            registerService.verifyCodeAndCreateUser(email, code);
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(new AuthResponse(true, "Xác thực tài khoản thành công!", request.getContextPath() + "/login"));
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(AuthResponse.error(ex.getMessage()));
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(AuthResponse.error(RegisterService.MSG_REGISTER_ERROR));
        }
    }

    /**
     * Resends a fresh 6-digit verification code to the pending email address.
     */
    @PostMapping(value = "/verify-email/resend", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<AuthResponse> resendVerificationCode(@RequestParam(required = false) String email) {
        try {
            registerService.resendVerificationCode(email);
            return ResponseEntity.ok(new AuthResponse(true, "Đã gửi lại mã xác thực 6 chữ số tới email của bạn!", null));
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(AuthResponse.error(ex.getMessage()));
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(AuthResponse.error("Không thể gửi lại mã xác thực, vui lòng thử lại."));
        }
    }

    @GetMapping("/403")
    public String accessDenied(HttpServletResponse response) {
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        return "error/403";
    }

    @ExceptionHandler(AuthenticationException.class)
    @ResponseBody
    public ResponseEntity<AuthResponse> handleAuthError(AuthenticationException ex) {
        HttpStatus status = ex instanceof BadCredentialsException ? HttpStatus.UNAUTHORIZED : HttpStatus.FORBIDDEN;
        return ResponseEntity.status(status)
                .contentType(MediaType.APPLICATION_JSON)
                .body(AuthResponse.error(ex.getMessage()));
    }

    private String resolveHomePath(User.Role role) {
        return (role == User.Role.ADMIN || role == User.Role.MANAGER) ? "/admin/dashboard" : "/";
    }
}
