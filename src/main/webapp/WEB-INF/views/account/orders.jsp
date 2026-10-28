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
            <div class="order-actions" style="display:flex; flex-wrap:wrap; gap:0.75rem; align-items:center;">
                <a class="order-btn order-btn--outline" style="padding:10px 22px; white-space:nowrap; text-align:center; justify-content:center;" href="${pageContext.request.contextPath}/orders/tracking">Tra cứu đơn khác</a>
                <a class="order-btn order-btn--primary" style="padding:10px 24px; white-space:nowrap; text-align:center; justify-content:center;" href="${pageContext.request.contextPath}/products">Đặt món mới</a>
            </div>
        </div>

        <div class="invoice-card" style="padding: 1.5rem;">
            <div class="table-responsive">
                <table class="invoice-table">
                    <thead>
                    <tr>
                        <th style="white-space:nowrap;">Mã đơn</th>
                        <th style="white-space:nowrap;">Ngày tạo</th>
                        <th style="white-space:nowrap;">Loại đơn</th>
                        <th style="white-space:nowrap;">Trạng thái đơn</th>
                        <th style="white-space:nowrap;">Thanh toán</th>
                        <th style="text-align:right; white-space:nowrap;">Tổng tiền</th>
                        <th style="text-align:center; white-space:nowrap; min-width:140px; width:140px;">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="order" items="${orderPage.content}">
                        <tr>
                            <td style="white-space:nowrap;"><strong style="color:var(--ut-primary, #7b4a2b);"><c:out value="${order.orderCode}"/></strong></td>
                            <td style="white-space:nowrap;"><c:out value="${order.createdAt}"/></td>
                            <td style="white-space:nowrap;"><c:out value="${order.orderType.label}"/></td>
                            <td style="white-space:nowrap;"><span class="badge-status badge-unpaid"><c:out value="${order.orderStatus.label}"/></span></td>
                            <td style="white-space:nowrap;">
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
                            <td style="text-align:right; white-space:nowrap;"><strong><fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0"/> đ</strong></td>
                            <td style="text-align:center; white-space:nowrap; vertical-align:middle;">
                                <a class="order-btn order-btn--outline" style="padding:8px 20px; font-size:0.88rem; min-width:120px; white-space:nowrap; display:inline-flex; justify-content:center; align-items:center; text-align:center;" href="${pageContext.request.contextPath}/orders/${order.orderCode}">
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
                <nav aria-label="Phân trang lịch sử đơn hàng" style="margin-top:1.75rem;">
                    <ul class="pagination justify-content-center" style="display:flex;justify-content:center;align-items:center;gap:0.5rem;list-style:none;padding:0;margin:0;">
                        <c:if test="${orderPage.hasPrevious()}">
                            <c:url var="previousUrl" value="/account/orders"><c:param name="page" value="${orderPage.number - 1}"/></c:url>
                            <li><a class="order-btn order-btn--subtle" style="padding:8px 18px; font-size:0.88rem; white-space:nowrap; display:inline-flex; justify-content:center; align-items:center; text-align:center;" href="${previousUrl}">Trước</a></li>
                        </c:if>
                        <li><span class="order-btn" style="background:var(--ut-cream, #fff8f0); padding:8px 18px; font-size:0.88rem; cursor:default; white-space:nowrap; display:inline-flex; justify-content:center; align-items:center; text-align:center;">${orderPage.number + 1} / ${orderPage.totalPages}</span></li>
                        <c:if test="${orderPage.hasNext()}">
                            <c:url var="nextUrl" value="/account/orders"><c:param name="page" value="${orderPage.number + 1}"/></c:url>
                            <li><a class="order-btn order-btn--subtle" style="padding:8px 18px; font-size:0.88rem; white-space:nowrap; display:inline-flex; justify-content:center; align-items:center; text-align:center;" href="${nextUrl}">Sau</a></li>
                        </c:if>
                    </ul>
                </nav>
            </c:if>
        </div>
    </div>
</section>
</body>
</html>
