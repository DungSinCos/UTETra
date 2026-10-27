package com.UTETra.app.service.impl;

import com.UTETra.app.dto.AccountProfileForm;
import com.UTETra.app.dto.AdminUserSummary;
import com.UTETra.app.dto.PasswordChangeForm;
import com.UTETra.app.entity.User;
import com.UTETra.app.exception.ResourceNotFoundException;
import com.UTETra.app.repository.UserRepository;
import com.UTETra.app.service.UserAccountService;
import jakarta.persistence.criteria.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

@Service
@Transactional
public class UserAccountServiceImpl implements UserAccountService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public UserAccountServiceImpl(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    @Transactional(readOnly = true)
    public User getByEmail(String email) {
        if (email == null || email.isBlank()) {
            throw new ResourceNotFoundException("User", email);
        }
        return userRepository.findByEmailIgnoreCase(email.trim())
                .orElseThrow(() -> new ResourceNotFoundException("User", email));
    }

    @Override
    public void updateProfile(String email, AccountProfileForm form) {
        if (form == null || form.getFullName() == null || form.getFullName().isBlank()) {
            throw new IllegalArgumentException("Vui lòng nhập họ và tên");
        }
        String fullName = form.getFullName().trim();
        if (fullName.length() > 100) {
            throw new IllegalArgumentException("Họ và tên tối đa 100 ký tự");
        }

        User user = getByEmail(email);
        String phone = form.getPhone() == null || form.getPhone().isBlank()
                ? null : form.getPhone().trim();
        if (phone != null && phone.length() > 20) {
            throw new IllegalArgumentException("Số điện thoại tối đa 20 ký tự");
        }
        if (phone != null && userRepository.existsByPhoneAndIdNot(phone, user.getId())) {
            throw new IllegalArgumentException("Số điện thoại này đã được sử dụng");
        }

        user.setFullName(fullName);
        user.setPhone(phone);
        userRepository.save(user);
    }

    @Override
    public void changePassword(String email, PasswordChangeForm form) {
        if (form == null || form.getCurrentPassword() == null || form.getCurrentPassword().isEmpty()) {
            throw new IllegalArgumentException("Vui lòng nhập mật khẩu hiện tại");
        }
        String newPassword = form.getNewPassword();
        if (newPassword == null || newPassword.length() < 8) {
            throw new IllegalArgumentException("Mật khẩu mới phải có ít nhất 8 ký tự");
        }
        if (!newPassword.equals(form.getConfirmPassword())) {
            throw new IllegalArgumentException("Mật khẩu xác nhận không khớp");
        }

        User user = getByEmail(email);
        if (!passwordEncoder.matches(form.getCurrentPassword(), user.getPasswordHash())) {
            throw new IllegalArgumentException("Mật khẩu hiện tại không đúng");
        }
        if (passwordEncoder.matches(newPassword, user.getPasswordHash())) {
            throw new IllegalArgumentException("Mật khẩu mới phải khác mật khẩu hiện tại");
        }

        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }

    @Override
    @Transactional(readOnly = true)
    @PreAuthorize("hasRole('ADMIN')")
    public Page<AdminUserSummary> searchUsers(String query, User.Status status, Pageable pageable) {
        String normalized = query == null || query.isBlank() ? null : query.trim().toLowerCase(Locale.ROOT);
        Specification<User> specification = (root, criteriaQuery, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (normalized != null) {
                String pattern = "%" + normalized + "%";
                predicates.add(cb.or(
                        cb.like(cb.lower(root.get("fullName")), pattern),
                        cb.like(cb.lower(root.get("email")), pattern),
                        cb.like(cb.lower(root.get("phone")), pattern)));
            }
            if (status != null) {
                predicates.add(cb.equal(root.get("status"), status));
            }
            return cb.and(predicates.toArray(Predicate[]::new));
        };
        return userRepository.findAll(specification, pageable).map(this::toAdminSummary);
    }

    @Override
    @Transactional(readOnly = true)
    @PreAuthorize("hasRole('ADMIN')")
    public AdminUserSummary getAdminUser(Long id) {
        return toAdminSummary(findUser(id));
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public void updateStatus(Long targetId, User.Status status, Long actorId) {
        if (status != User.Status.ACTIVE && status != User.Status.LOCKED) {
            throw new IllegalArgumentException("Chỉ có thể mở khóa hoặc khóa tài khoản");
        }
        if (targetId.equals(actorId) && status == User.Status.LOCKED) {
            throw new IllegalArgumentException("Bạn không thể tự khóa tài khoản đang đăng nhập");
        }
        User user = findUser(targetId);
        user.setStatus(status);
        userRepository.save(user);
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public void updateRole(Long targetId, User.Role role, Long actorId) {
        if (role == null) {
            throw new IllegalArgumentException("Vui lòng chọn vai trò");
        }
        if (targetId.equals(actorId) && role != User.Role.ADMIN) {
            throw new IllegalArgumentException("Không thể tự hạ quyền tài khoản Admin đang đăng nhập");
        }
        User user = findUser(targetId);
        user.setRole(role);
        userRepository.save(user);
    }

    private User findUser(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User", id));
    }

    private AdminUserSummary toAdminSummary(User user) {
        return new AdminUserSummary(user.getId(), user.getFullName(), user.getEmail(), user.getPhone(),
                user.getAvatarUrl(), user.getRole(), user.getStatus(), user.getLoyaltyPoints(), user.getCreatedAt());
    }
}
