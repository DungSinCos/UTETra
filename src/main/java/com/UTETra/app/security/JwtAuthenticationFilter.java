package com.UTETra.app.security;

import com.UTETra.app.entity.User;
import com.UTETra.app.repository.UserRepository;
import io.jsonwebtoken.Claims;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseCookie;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

/**
 * Reads the JWT from the {@value #COOKIE_NAME} cookie (or an {@code Authorization: Bearer} header)
 * and, if valid, populates the SecurityContext and request attributes for the current request.
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
            Optional<Claims> claimsOpt = jwtService.parse(token);
            if (claimsOpt.isPresent()) {
                boolean ok = authenticate(claimsOpt.get(), request);
                if (!ok) {
                    clearTokenCookie(request, response);
                }
            } else {
                // Token is expired or tampered -> destroy the stale cookie automatically
                clearTokenCookie(request, response);
            }
        }
        chain.doFilter(request, response);
    }

    private boolean authenticate(Claims claims, HttpServletRequest request) {
        Number uidNum = claims.get(JwtService.CLAIM_UID, Number.class);
        Long uid = uidNum != null ? uidNum.longValue() : null;
        User user = (uid != null && userRepository != null)
                ? userRepository.findById(uid).orElse(null)
                : null;

        if (user == null || user.getStatus() != User.Status.ACTIVE) {
            return false;
        }

        String role = user.getRole().name();
        var authorities = List.of(new SimpleGrantedAuthority("ROLE_" + role));
        var auth = new UsernamePasswordAuthenticationToken(user.getEmail(), null, authorities);
        auth.setDetails(claims);
        SecurityContextHolder.getContext().setAuthentication(auth);

        request.setAttribute("currentUser", user);
        request.setAttribute("currentUserName", user.getFullName());
        request.setAttribute("currentUserRole", role);
        request.setAttribute("currentUserAvatar", user.getAvatarUrl());
        return true;
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

    public static void clearTokenCookie(HttpServletRequest request, HttpServletResponse response) {
        ResponseCookie expired = ResponseCookie.from(COOKIE_NAME, "")
                .httpOnly(true)
                .secure(request.isSecure())
                .sameSite("Lax")
                .path("/")
                .maxAge(0)
                .build();
        response.addHeader(HttpHeaders.SET_COOKIE, expired.toString());
    }
}
