package com.UTETra.app.security;

import com.UTETra.app.entity.User;
import com.UTETra.app.repository.UserRepository;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.OAuth2Error;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;

/** Loads social-provider attributes and creates or links a local customer account. */
@Service
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public CustomOAuth2UserService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    @Transactional
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2User providerUser = super.loadUser(userRequest);
        Map<String, Object> attributes = providerUser.getAttributes();
        String registrationId = userRequest.getClientRegistration().getRegistrationId()
                .toUpperCase(Locale.ROOT);

        User.AuthProvider provider;
        try {
            provider = User.AuthProvider.valueOf(registrationId);
        } catch (IllegalArgumentException ex) {
            throw oauthError("Nhà cung cấp đăng nhập không được hỗ trợ");
        }

        String email = stringAttribute(attributes, "email");
        if (email == null || email.isBlank()) {
            throw oauthError("Nhà cung cấp không trả về email. Hãy cấp quyền email rồi thử lại.");
        }
        email = email.trim().toLowerCase(Locale.ROOT);

        // Google returns this claim for email scope; do not link an unverified Google address.
        if (provider == User.AuthProvider.GOOGLE
                && !Boolean.TRUE.equals(attributes.get("email_verified"))) {
            throw oauthError("Email Google chưa được xác minh.");
        }

        String normalizedEmail = email;
        User user = userRepository.findByEmailIgnoreCase(normalizedEmail).orElseGet(() -> {
            User created = new User();
            created.setEmail(normalizedEmail);
            created.setFullName(resolveName(attributes, normalizedEmail));
            // Keep the existing NOT NULL password_hash schema while making the random password unusable.
            created.setPasswordHash(passwordEncoder.encode(UUID.randomUUID().toString()));
            created.setRole(User.Role.CUSTOMER);
            created.setStatus(User.Status.ACTIVE);
            created.setAuthProvider(provider);
            return created;
        });

        if (user.getStatus() != User.Status.ACTIVE) {
            throw new LockedException("Tài khoản của bạn hiện không hoạt động.");
        }

        // Matching email links the provider to the existing local account.
        if (user.getAuthProvider() != provider) {
            user.setAuthProvider(provider);
        }
        String name = stringAttribute(attributes, "name");
        if ((user.getFullName() == null || user.getFullName().isBlank()) && name != null) {
            user.setFullName(name);
        }
        String avatar = resolveAvatar(attributes);
        if (avatar != null && (user.getAvatarUrl() == null || user.getAvatarUrl().isBlank())) {
            user.setAvatarUrl(avatar);
        }
        userRepository.save(user);

        String usernameAttribute = userRequest.getClientRegistration()
                .getProviderDetails().getUserInfoEndpoint().getUserNameAttributeName();
        if (usernameAttribute == null || !attributes.containsKey(usernameAttribute)) {
            throw oauthError("Thông tin tài khoản từ nhà cung cấp không hợp lệ.");
        }
        return new DefaultOAuth2User(
                List.of(new SimpleGrantedAuthority("ROLE_" + user.getRole().name())),
                attributes,
                usernameAttribute);
    }

    private String stringAttribute(Map<String, Object> attributes, String key) {
        Object value = attributes.get(key);
        return value instanceof String text ? text : null;
    }

    private String resolveAvatar(Map<String, Object> attributes) {
        Object picture = attributes.get("picture");
        if (picture instanceof String url && !url.isBlank()) {
            return url;
        }
        // Facebook Graph API returns {"picture": {"data": {"url": "https://..."}}}
        if (picture instanceof Map<?, ?> pictureMap) {
            Object data = pictureMap.get("data");
            if (data instanceof Map<?, ?> dataMap && dataMap.get("url") instanceof String url && !url.isBlank()) {
                return url;
            }
        }
        return null;
    }

    private String resolveName(Map<String, Object> attributes, String email) {
        String name = stringAttribute(attributes, "name");
        return name == null || name.isBlank() ? email.substring(0, email.indexOf('@')) : name.trim();
    }

    private OAuth2AuthenticationException oauthError(String description) {
        return new OAuth2AuthenticationException(new OAuth2Error("invalid_user_info", description, null));
    }
}
