package com.UTETra.app.security;

import com.UTETra.app.entity.User;
import com.UTETra.app.repository.UserRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseCookie;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.time.Duration;

/** Issues the application's JWT cookie after a successful social login. */
@Component
public class OAuth2AuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    private final UserRepository userRepository;
    private final JwtService jwtService;

    public OAuth2AuthenticationSuccessHandler(UserRepository userRepository, JwtService jwtService) {
        this.userRepository = userRepository;
        this.jwtService = jwtService;
    }

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request,
                                        HttpServletResponse response,
                                        Authentication authentication) throws IOException, ServletException {
        if (!(authentication.getPrincipal() instanceof OAuth2User oauthUser)) {
            response.sendRedirect(request.getContextPath() + "/login?oauthError=true");
            return;
        }

        Object emailAttribute = oauthUser.getAttributes().get("email");
        if (!(emailAttribute instanceof String email)) {
            response.sendRedirect(request.getContextPath() + "/login?oauthError=true");
            return;
        }

        User user = userRepository.findByEmailIgnoreCase(email.trim())
                .filter(account -> account.getStatus() == User.Status.ACTIVE)
                .orElse(null);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?oauthError=true");
            return;
        }

        ResponseCookie cookie = ResponseCookie.from(JwtAuthenticationFilter.COOKIE_NAME,
                        jwtService.generateToken(user))
                .httpOnly(true)
                .secure(request.isSecure())
                .sameSite("Lax")
                .path("/")
                .maxAge(Duration.ofMillis(jwtService.getExpirationMs()))
                .build();
        response.addHeader(HttpHeaders.SET_COOKIE, cookie.toString());

        String destination = user.getRole() == User.Role.ADMIN || user.getRole() == User.Role.MANAGER
                ? "/admin/dashboard" : "/";
        response.sendRedirect(request.getContextPath() + destination);
    }
}
