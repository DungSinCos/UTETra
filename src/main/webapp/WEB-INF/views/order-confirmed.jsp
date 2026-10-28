<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Xác nhận đơn hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/checkout.css">
</head>
<body>
<section class="order-confirmed-page">
    <div class="site-container order-confirmed-container">
        <!-- Centered Confirmation Div -->
        <div class="order-confirmed-card" role="status" aria-live="polite">
            <div class="order-confirmed-tick" aria-hidden="true">
                <svg viewBox="0 0 24 24" width="40" height="40" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="20 6 9 17 4 12"></polyline>
                </svg>
            </div>

            <h1 class="order-confirmed-title">Đơn hàng của bạn đã được xác nhận!</h1>
            <p class="order-confirmed-text">
                Cảm ơn bạn đã tin tưởng và đặt thức uống tại <strong>UTETra</strong>.
                Cửa hàng đang chuẩn bị đồ uống tươi mới và sẽ giao đến bạn trong thời gian sớm nhất.
            </p>

            <c:if test="${not empty orderCode or not empty order}">
                <div class="order-confirmed-details">
                    <c:if test="${not empty orderCode}">
                        <div class="order-confirmed-row">
                            <span>Mã đơn hàng</span>
                            <strong><c:out value="${orderCode}"/></strong>
                        </div>
                    </c:if>
                    <c:if test="${not empty order}">
                        <div class="order-confirmed-row">
                            <span>Người nhận</span>
                            <strong><c:out value="${order.recipientName}"/> &bull; <c:out value="${order.recipientPhone}"/></strong>
                        </div>
                        <div class="order-confirmed-row">
                            <span>Địa chỉ giao</span>
                            <strong><c:out value="${order.shippingAddress}"/></strong>
                        </div>
                        <div class="order-confirmed-row">
                            <span>Tổng thanh toán</span>
                            <strong class="order-confirmed-price">
                                <fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0"/>đ
                            </strong>
                        </div>
                    </c:if>
                </div>
            </c:if>

            <div class="order-confirmed-actions">
                <c:if test="${isLoggedIn}">
                    <a class="order-confirmed-btn order-confirmed-btn--outline" href="${pageContext.request.contextPath}/account/orders">
                        Xem lịch sử đơn hàng
                    </a>
                </c:if>
                <a class="order-confirmed-btn order-confirmed-btn--primary" href="${pageContext.request.contextPath}/products">
                    Tiếp tục mua sắm
                </a>
            </div>
        </div>
    </div>
</section>
</body>
</html>
