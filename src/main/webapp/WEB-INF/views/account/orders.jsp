<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý đơn hàng - UTETra</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order.css">
</head>
<body>
<section class="order-page">
    <div class="site-container">
        <div class="order-header">
            <div>
                <a class="back-link" href="${pageContext.request.contextPath}/account/profile" style="color:var(--ut-muted, #7d6a5d);text-decoration:none;font-size:0.9rem;font-weight:600;">&larr; Về tài khoản</a>
                <h1 class="order-header__title">Quản lý đơn hàng</h1>
                <div class="order-header__meta">Quản lý và theo dõi tiến trình các đơn hàng của bạn</div>
            </div>
            <div class="order-actions">
                <a class="order-btn order-btn--outline" href="${pageContext.request.contextPath}/orders/tracking">Tra cứu đơn khác</a>
                <a class="order-btn order-btn--primary" href="${pageContext.request.contextPath}/products">Đặt món mới</a>
            </div>
        </div>

        <div class="invoice-card" style="padding: 1.5rem;">
            <div class="table-responsive">
                <table class="invoice-table">
                    <thead>
                    <tr>
                        <th>Mã đơn</th>
                        <th>Ngày tạo</th>
                        <th>Loại đơn</th>
                        <th>Trạng thái đơn</th>
                        <th>Thanh toán</th>
                        <th style="text-align:right;">Tổng tiền</th>
                        <th style="text-align:center;">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="order" items="${orderPage.content}">
                        <tr>
                            <td><strong style="color:var(--ut-primary, #7b4a2b);"><c:out value="${order.orderCode}"/></strong></td>
                            <td><c:out value="${order.createdAt}"/></td>
                            <td><c:out value="${order.orderType.label}"/></td>
                            <td><span class="badge-status badge-unpaid"><c:out value="${order.orderStatus.label}"/></span></td>
                            <td>
                                <c:choose>
                                    <c:when test="${order.paymentStatus.name() == 'PAID'}">
                                        <span class="badge-status badge-paid"><c:out value="${order.paymentStatus.label}"/></span>
                                    </c:when>
                                    <c:when test="${order.paymentStatus.name() == 'FAILED'}">
                                        <span class="badge-status badge-failed"><c:out value="${order.paymentStatus.label}"/></span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-status badge-unpaid"><c:out value="${order.paymentStatus.label}"/></span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="text-align:right;"><strong><fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0"/> đ</strong></td>
                            <td style="text-align:center;">
                                <a class="order-btn order-btn--outline" style="padding:6px 16px;font-size:0.85rem;" href="${pageContext.request.contextPath}/orders/${order.orderCode}">
                                    Xem chi tiết
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty orderPage.content}">
                        <tr><td colspan="7" class="text-center text-muted py-5" style="text-align:center;padding:3rem 0;color:var(--ut-muted, #7d6a5d);">Bạn chưa có đơn hàng nào.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

            <c:if test="${orderPage.totalPages gt 1}">
                <nav aria-label="Phân trang lịch sử đơn hàng" style="margin-top:1.5rem;">
                    <ul class="pagination justify-content-center" style="display:flex;justify-content:center;gap:0.5rem;list-style:none;padding:0;">
                        <c:if test="${orderPage.hasPrevious()}">
                            <c:url var="previousUrl" value="/account/orders"><c:param name="page" value="${orderPage.number - 1}"/></c:url>
                            <li><a class="order-btn order-btn--subtle" style="padding:6px 14px;font-size:0.85rem;" href="${previousUrl}">Trước</a></li>
                        </c:if>
                        <li><span class="order-btn" style="background:var(--ut-cream, #fff8f0);padding:6px 14px;font-size:0.85rem;cursor:default;">${orderPage.number + 1} / ${orderPage.totalPages}</span></li>
                        <c:if test="${orderPage.hasNext()}">
                            <c:url var="nextUrl" value="/account/orders"><c:param name="page" value="${orderPage.number + 1}"/></c:url>
                            <li><a class="order-btn order-btn--subtle" style="padding:6px 14px;font-size:0.85rem;" href="${nextUrl}">Sau</a></li>
                        </c:if>
                    </ul>
                </nav>
            </c:if>
        </div>
    </div>
</section>
</body>
</html>
