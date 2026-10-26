package com.UTETra.app.security;

import com.UTETra.app.entity.User;
import com.UTETra.app.repository.UserRepository;
import io.jsonwebtoken.Claims;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;

/**
 * Reads the JWT from the {@value #COOKIE_NAME} cookie (or an {@code Authorization: Bearer} header)
 * and, if valid, populates the SecurityContext for the current request.
 */
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    public static final String COOKIE_NAME = "ACCESS_TOKEN";

    private final JwtService jwtService;
    private final UserRepository userRepository;

    public JwtAuthenticationFilter(JwtService jwtService, UserRepository userRepository) {
        this.jwtService = jwtService;
        this.userRepository = userRepository;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {

        String token = resolveToken(request);
        if (token != null && SecurityContextHolder.getContext().getAuthentication() == null) {
            jwtService.parse(token).ifPresent(claims -> authenticate(claims, request));
        }
        chain.doFilter(request, response);
    }

    private void authenticate(Claims claims, HttpServletRequest request) {
        Number uidNum = claims.get(JwtService.CLAIM_UID, Number.class);
        Long uid = uidNum != null ? uidNum.longValue() : null;
        User user = (uid != null && userRepository != null)
                ? userRepository.findById(uid).orElse(null)
                : null;

        if (user != null && user.getStatus() != User.Status.ACTIVE) {
            return;
        }

        String role = user != null ? user.getRole().name() : claims.get(JwtService.CLAIM_ROLE, String.class);
        var authorities = role == null ? List.<SimpleGrantedAuthority>of()
                : List.of(new SimpleGrantedAuthority("ROLE_" + role));
        var auth = new UsernamePasswordAuthenticationToken(claims.getSubject(), null, authorities);
        auth.setDetails(claims);
        SecurityContextHolder.getContext().setAuthentication(auth);

        String fullName = user != null ? user.getFullName() : claims.get(JwtService.CLAIM_NAME, String.class);
        String avatarUrl = user != null ? user.getAvatarUrl() : null;

        request.setAttribute("currentUser", user);
        request.setAttribute("currentUserName", fullName);
        request.setAttribute("currentUserAvatar", avatarUrl);
    }

    private String resolveToken(HttpServletRequest request) {
        String header = request.getHeader("Authorization");
        if (header != null && header.startsWith("Bearer ")) {
            return header.substring(7);
        }
        if (request.getCookies() != null) {
            for (Cookie c : request.getCookies()) {
                if (COOKIE_NAME.equals(c.getName()) && !c.getValue().isBlank()) {
                    return c.getValue();
                }
            }
        }
        return null;
    }
}
