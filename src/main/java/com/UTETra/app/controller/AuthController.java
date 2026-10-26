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

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    /**
     * Receives the credentials posted by login.jsp (form-encoded), validates them and,
     * on success, stores the JWT in an HttpOnly cookie that acts as the session.
     * Redirects ADMIN / MANAGER users to /admin/dashboard, and others to /.
     */
    @PostMapping(value = "/login", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<AuthResponse> doLogin(@RequestParam(required = false) String email,
                                                @RequestParam(required = false) String password,
                                                @RequestParam(name = "remember-me", defaultValue = "false") boolean rememberMe,
                                                HttpServletRequest request) {
        AuthService.LoginResult result = authService.authenticate(email, password);

        ResponseCookie cookie = ResponseCookie.from(JwtAuthenticationFilter.COOKIE_NAME, result.token())
                .httpOnly(true)
                .secure(request.isSecure())
                .sameSite("Lax")
                .path("/")
                .maxAge(rememberMe ? Duration.ofMillis(jwtService.getExpirationMs()) : Duration.ofSeconds(-1))
                .build();

        User.Role role = result.user().getRole();
        String targetPath = (role == User.Role.ADMIN || role == User.Role.MANAGER)
                ? "/admin/dashboard"
                : "/";

        return ResponseEntity.ok()
                .header(HttpHeaders.SET_COOKIE, cookie.toString())
                .body(AuthResponse.ok(request.getContextPath() + targetPath));
    }

    @GetMapping("/register")
    public String register() {
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
}
