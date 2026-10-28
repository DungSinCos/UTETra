<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Thông tin cá nhân - UTETra</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order.css">
    <style>
        .profile-container {
            max-width: 680px;
            margin: 0 auto;
        }
    </style>
</head>
<body>
<section class="order-page">
    <div class="site-container profile-container">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
            <h1 class="order-header__title">Tài khoản của tôi</h1>
            <a class="order-btn order-btn--outline" href="${pageContext.request.contextPath}/">Về trang chủ</a>
        </div>

        <c:if test="${not empty message}">
            <div class="alert alert-success" style="background:#dcfce7;color:#15803d;padding:1rem 1.25rem;border-radius:12px;margin-bottom:1.5rem;font-weight:600;">
                &#10003; <c:out value="${message}"/>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger" style="background:#fee2e2;color:#b91c1c;padding:1rem 1.25rem;border-radius:12px;margin-bottom:1.5rem;font-weight:600;">
                &#9888; <c:out value="${error}"/>
            </div>
        </c:if>

        <div class="d-flex flex-wrap gap-2 mb-4">
            <a class="order-btn order-btn--outline" href="${pageContext.request.contextPath}/account/orders">Lịch sử đơn hàng</a>
            <a class="order-btn order-btn--subtle" href="${pageContext.request.contextPath}/account/change-password">Đổi mật khẩu</a>
        </div>

        <div class="invoice-card">
            <h2 class="invoice-card__title">Thông tin cá nhân</h2>
            <form method="post" action="${pageContext.request.contextPath}/account/profile">
                <div class="tracking-field">
                    <label for="email">Địa chỉ Email</label>
                    <input id="email" value="<c:out value='${email}'/>" readonly style="opacity:0.8;cursor:not-allowed;">
                    <span style="font-size:0.82rem;color:var(--ut-muted, #7d6a5d);">Email đăng nhập không thể thay đổi.</span>
                </div>
                <div class="tracking-field">
                    <label for="fullName">Họ và tên</label>
                    <input id="fullName" name="fullName"
                           value="<c:out value='${profile.fullName}'/>" maxlength="100" required>
                </div>
                <div class="tracking-field" style="margin-bottom:2rem;">
                    <label for="phone">Số điện thoại</label>
                    <input id="phone" name="phone" type="tel"
                           value="<c:out value='${profile.phone}'/>" maxlength="20">
                </div>
                <button class="order-btn order-btn--primary" type="submit" style="width:100%;">
                    Lưu hồ sơ
                </button>
            </form>
        </div>
    </div>
</section>
</body>
</html>
