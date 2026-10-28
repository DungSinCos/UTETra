package com.UTETra.app.controller;

import com.UTETra.app.dto.AuthResponse;
import com.UTETra.app.entity.User;
import com.UTETra.app.security.JwtAuthenticationFilter;
import com.UTETra.app.security.JwtService;
import com.UTETra.app.service.AuthService;
import com.UTETra.app.service.RegisterService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseCookie;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.ui.Model;

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
    public String login(HttpServletRequest request,
                        @RequestParam(defaultValue = "false") boolean oauthError,
                        Model model) {
        Object current = request.getAttribute("currentUser");
        if (current instanceof User user) {
            return "redirect:" + resolveHomePath(user.getRole());
        }
        if (oauthError) {
            model.addAttribute("oauthError", "Không thể đăng nhập qua mạng xã hội. Vui lòng thử lại.");
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

        // Persist the cookie for the JWT lifetime (24h by default, or 7 days when remember-me is checked)
        // so the user stays logged in automatically on subsequent visits without re-entering credentials.
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

    @PostMapping(value = "/register", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<AuthResponse> doRegister(@RequestParam(required = false) String fullName,
                                                   @RequestParam(required = false) String email,
                                                   @RequestParam(required = false) String password,
                                                   HttpServletRequest request) {
        try {
            registerService.register(fullName, email, password);
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(new AuthResponse(true, "Tạo tài khoản thành công!", request.getContextPath() + "/login"));
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
