package com.UTETra.app.service;

import com.UTETra.app.dto.AccountProfileForm;
import com.UTETra.app.dto.AdminUserSummary;
import com.UTETra.app.dto.PasswordChangeForm;
import com.UTETra.app.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface UserAccountService {

    User getByEmail(String email);

    void updateProfile(String email, AccountProfileForm form);

    void changePassword(String email, PasswordChangeForm form);

    Page<AdminUserSummary> searchUsers(String query, User.Status status, Pageable pageable);

    AdminUserSummary getAdminUser(Long id);

    void updateStatus(Long targetId, User.Status status, Long actorId);

    void updateRole(Long targetId, User.Role role, Long actorId);
}
