<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Đổi mật khẩu - UTETra</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order.css">
    <style>
        .change-pwd-container {
            max-width: 580px;
            margin: 0 auto;
        }
    </style>
</head>
<body>
<section class="order-page">
    <div class="site-container change-pwd-container">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
            <h1 class="order-header__title">Đổi mật khẩu</h1>
            <a class="order-btn order-btn--outline" href="${pageContext.request.contextPath}/account/profile">Về tài khoản</a>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" style="background:#fee2e2;color:#b91c1c;padding:1rem 1.25rem;border-radius:12px;margin-bottom:1.5rem;font-weight:600;">
                &#9888; <c:out value="${error}"/>
            </div>
        </c:if>

        <div class="invoice-card">
            <form method="post" action="${pageContext.request.contextPath}/account/change-password">
                <div class="tracking-field">
                    <label for="currentPassword">Mật khẩu hiện tại <span style="color:#e11d48;">*</span></label>
                    <input type="password" id="currentPassword" name="currentPassword" autocomplete="current-password" required>
                </div>
                <div class="tracking-field">
                    <label for="newPassword">Mật khẩu mới <span style="color:#e11d48;">*</span></label>
                    <input type="password" id="newPassword" name="newPassword" minlength="8" autocomplete="new-password" placeholder="Tối thiểu 8 ký tự" required>
                </div>
                <div class="tracking-field" style="margin-bottom:2rem;">
                    <label for="confirmPassword">Nhập lại mật khẩu mới <span style="color:#e11d48;">*</span></label>
                    <input type="password" id="confirmPassword" name="confirmPassword" minlength="8" autocomplete="new-password" placeholder="Nhập lại mật khẩu mới" required>
                </div>
                <div style="display:flex;gap:1rem;">
                    <button class="order-btn order-btn--primary" type="submit" style="flex:1;">
                        Cập nhật mật khẩu
                    </button>
                    <a class="order-btn order-btn--subtle" href="${pageContext.request.contextPath}/account/profile" style="flex:0 0 auto;">
                        Hủy
                    </a>
                </div>
            </form>
        </div>
    </div>
</section>
</body>
</html>
