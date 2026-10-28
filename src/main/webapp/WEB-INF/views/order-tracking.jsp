<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Tra cứu đơn hàng - UTETra</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order.css">
</head>
<body>
<section class="order-page">
    <div class="site-container">
        <div class="tracking-card">
            <h1 class="tracking-title">Tra cứu đơn hàng</h1>
            <p class="tracking-desc">Nhập mã đơn hàng và số điện thoại người nhận để kiểm tra tiến trình giao hàng</p>

            <c:if test="${not empty error}">
                <div class="alert alert-danger" style="background:#fdf2f2;border:1.5px solid #fecaca;color:#b91c1c;padding:0.9rem 1.25rem;border-radius:12px;margin-bottom:1.5rem;font-size:0.92rem;font-weight:600;">
                    &#9888; <c:out value="${error}"/>
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/orders/tracking">
                <div class="tracking-field">
                    <label for="orderCode">Mã đơn hàng <span style="color:#e11d48;">*</span></label>
                    <input type="text"
                           id="orderCode"
                           name="orderCode"
                           value="<c:out value='${searchedCode}'/>"
                           placeholder="Ví dụ: UTE-261028123456-789"
                           required>
                </div>

                <div class="tracking-field">
                    <label for="phone">Số điện thoại đặt hàng <span style="color:#e11d48;">*</span></label>
                    <input type="tel"
                           id="phone"
                           name="phone"
                           value="<c:out value='${searchedPhone}'/>"
                           placeholder="Ví dụ: 0901234567"
                           required>
                </div>

                <button type="submit" class="tracking-submit-btn">
                    Tra cứu tiến độ đơn hàng
                </button>
            </form>

            <c:if test="${not empty currentUser}">
                <div style="margin-top: 2rem; padding-top: 1.5rem; border-top: 1.5px solid var(--ut-border, #f0e2d3); text-align: center;">
                    <p style="font-size: 0.9rem; color: var(--ut-muted, #7d6a5d); margin: 0;">
                        <a href="${pageContext.request.contextPath}/account/orders" style="color:var(--ut-primary, #7b4a2b);text-decoration:none;font-weight:700;">Xem danh sách quản lý đơn hàng của bạn</a>
                    </p>
                </div>
            </c:if>
        </div>
    </div>
</section>
</body>
</html>
