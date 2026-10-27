package com.UTETra.app.dto;

import com.UTETra.app.entity.User;

import java.time.LocalDateTime;

/** Safe user data for Admin pages; deliberately excludes passwordHash. */
public class AdminUserSummary {

    private final Long id;
    private final String fullName;
    private final String email;
    private final String phone;
    private final String avatarUrl;
    private final User.Role role;
    private final User.Status status;
    private final int loyaltyPoints;
    private final LocalDateTime createdAt;

    public AdminUserSummary(Long id, String fullName, String email, String phone, String avatarUrl,
                            User.Role role, User.Status status, int loyaltyPoints, LocalDateTime createdAt) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.avatarUrl = avatarUrl;
        this.role = role;
        this.status = status;
        this.loyaltyPoints = loyaltyPoints;
        this.createdAt = createdAt;
    }

    public Long getId() { return id; }
    public String getFullName() { return fullName; }
    public String getEmail() { return email; }
    public String getPhone() { return phone; }
    public String getAvatarUrl() { return avatarUrl; }
    public User.Role getRole() { return role; }
    public User.Status getStatus() { return status; }
    public int getLoyaltyPoints() { return loyaltyPoints; }
    public LocalDateTime getCreatedAt() { return createdAt; }
}
