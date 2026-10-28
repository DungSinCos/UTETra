package com.UTETra.app.config;

import com.UTETra.app.repository.UserRepository;
import com.UTETra.app.security.CustomOAuth2UserService;
import com.UTETra.app.security.JwtAuthenticationFilter;
import com.UTETra.app.security.JwtService;
import com.UTETra.app.security.OAuth2AuthenticationSuccessHandler;
import jakarta.servlet.DispatcherType;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

/**
 * Stateless JWT security configuration with role-based authorization for /admin/**.
 */
@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http,
                                           JwtService jwtService,
                                           UserRepository userRepository,
                                           CustomOAuth2UserService customOAuth2UserService,
                                           OAuth2AuthenticationSuccessHandler oauth2SuccessHandler) throws Exception {
        http
            .csrf(AbstractHttpConfigurer::disable)
            .sessionManagement(s -> s.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .headers(h -> h.frameOptions(f -> f.sameOrigin()))
            .authorizeHttpRequests(a -> a
                // Allow internal Servlet FORWARD dispatches to /WEB-INF/views/*.jsp after controller authorization
                .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.ERROR).permitAll()
                .requestMatchers("/account/**").authenticated()
                // Only ADMIN and MANAGER roles can access /admin and /admin/** (blocks STAFF, CUSTOMER, and guests)
                .requestMatchers("/admin", "/admin/**").hasAnyRole("ADMIN", "MANAGER")
                // All other public pages and static assets remain accessible
                .anyRequest().permitAll()
            )
            .exceptionHandling(e -> e
                // Unauthenticated user (not logged in) trying to access /admin/** -> redirect to /login
                .authenticationEntryPoint((request, response, authException) -> {
                    String accept = request.getHeader(HttpHeaders.ACCEPT);
                    if (accept != null && accept.contains(MediaType.APPLICATION_JSON_VALUE)) {
                        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
                        response.setCharacterEncoding("UTF-8");
                        response.getWriter().write("{\"success\":false,\"message\":\"Vui lòng đăng nhập để tiếp tục\"}");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/login");
                    }
                })
                // Authenticated user without ADMIN/MANAGER role (e.g. CUSTOMER or STAFF) -> 403 Forbidden
                .accessDeniedHandler((request, response, accessDeniedException) -> {
                    String accept = request.getHeader(HttpHeaders.ACCEPT);
                    if (accept != null && accept.contains(MediaType.APPLICATION_JSON_VALUE)) {
                        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
                        response.setCharacterEncoding("UTF-8");
                        response.getWriter().write("{\"success\":false,\"message\":\"Bạn không có quyền truy cập trang này\"}");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/403");
                    }
                })
            )
            .oauth2Login(oauth -> oauth
                .userInfoEndpoint(userInfo -> userInfo.userService(customOAuth2UserService))
                .successHandler(oauth2SuccessHandler)
                .failureUrl("/login?oauthError=true"))
            .formLogin(AbstractHttpConfigurer::disable)
            .httpBasic(AbstractHttpConfigurer::disable)
            .logout(l -> l
                // Support both GET /logout (links) and POST /logout (forms)
                .logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
                .invalidateHttpSession(true)
                .clearAuthentication(true)
                .deleteCookies(JwtAuthenticationFilter.COOKIE_NAME)
                .addLogoutHandler((request, response, auth) ->
                        JwtAuthenticationFilter.clearTokenCookie(request, response))
                .logoutSuccessUrl("/login"))
            .addFilterBefore(new JwtAuthenticationFilter(jwtService, userRepository), UsernamePasswordAuthenticationFilter.class);
        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
