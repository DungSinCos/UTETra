<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Chi tiết đơn hàng #${order.orderCode} - UTETra Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>
<section class="admin-page">
    <div class="site-container">

        <%-- Admin Navigation Bar --%>
        <jsp:include page="/WEB-INF/views/components/admin-nav.jsp"/>

        <div class="admin-header">
            <div>
                <h1 class="admin-header__title">Chi tiết đơn hàng #${order.orderCode}</h1>
                <div class="admin-header__desc">Khởi tạo lúc: <strong><c:out value="${order.createdAt}"/></strong></div>
            </div>
            <div>
                <a class="admin-btn admin-btn--outline" href="${pageContext.request.contextPath}/admin/orders">&larr; Danh sách đơn</a>
            </div>
        </div>

        <c:if test="${not empty message}"><div class="alert alert-success" style="background:#dcfce7;color:#15803d;border-radius:12px;margin-bottom:1.5rem;font-weight:600;">&#10003; <c:out value="${message}"/></div></c:if>
        <c:if test="${not empty error}"><div class="alert alert-danger" style="background:#fee2e2;color:#b91c1c;border-radius:12px;margin-bottom:1.5rem;font-weight:600;">&#9888; <c:out value="${error}"/></div></c:if>

        <div class="row g-4 mb-4">
            <div class="col-lg-6">
                <div class="admin-card">
                    <h3 class="admin-section-title mb-3">&#128230; Thông tin nhận hàng</h3>
                    <div class="d-flex flex-column gap-2" style="font-size:0.95rem;">
                        <div><span class="text-muted">Người nhận:</span> <strong><c:out value="${order.recipientName}"/></strong></div>
                        <div><span class="text-muted">Điện thoại:</span> <strong><c:out value="${order.recipientPhone}"/></strong></div>
                        <div><span class="text-muted">Loại đơn:</span> <span class="badge text-bg-light" style="border:1px solid #e2e8f0;"><c:out value="${order.orderType.label}"/></span></div>
                        <div><span class="text-muted">Chi nhánh:</span> <strong><c:out value="${order.branch.name}"/></strong></div>
                        <c:if test="${not empty order.shippingAddress}"><div><span class="text-muted">Địa chỉ:</span> <c:out value="${order.shippingAddress}"/></div></c:if>
                        <c:if test="${not empty order.note}"><div><span class="text-muted">Ghi chú:</span> <em>&ldquo;<c:out value="${order.note}"/>&rdquo;</em></div></c:if>
                        <c:if test="${not empty order.user}"><div><span class="text-muted">Tài khoản đặt:</span> <c:out value="${order.user.email}"/></div></c:if>
                    </div>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="admin-card">
                    <h3 class="admin-section-title mb-3">&#9881; Trạng thái &amp; Thanh toán</h3>
                    <div class="d-flex flex-column gap-2" style="font-size:0.95rem;">
                        <div><span class="text-muted">Trạng thái hiện tại:</span> <span class="badge text-bg-secondary"><c:out value="${order.orderStatus.label}"/></span></div>
                        <div><span class="text-muted">Thanh toán:</span>
                            <c:choose>
                                <c:when test="${order.paymentStatus.name() == 'PAID'}"><span class="badge text-bg-success">Đã thanh toán</span></c:when>
                                <c:otherwise><span class="badge text-bg-warning">Chưa thanh toán</span></c:otherwise>
                            </c:choose>
                        </div>
                        <div><span class="text-muted">Phương thức:</span> <strong><c:out value="${order.paymentMethod.label}"/></strong></div>

                        <c:if test="${not empty nextStatuses}">
                            <div class="mt-3 pt-3" style="border-top:1px dashed var(--ut-border, #f0e2d3);">
                                <label class="form-label small fw-bold text-muted mb-1">Cập nhật bước tiếp theo:</label>
                                <form class="d-flex gap-2" method="post"
                                      action="${pageContext.request.contextPath}/admin/orders/${order.id}/status">
                                    <select class="admin-input-date flex-grow-1" name="status" required>
                                        <c:forEach var="nextStatus" items="${nextStatuses}">
                                            <option value="${nextStatus}"><c:out value="${nextStatus.label}"/></option>
                                        </c:forEach>
                                    </select>
                                    <button class="admin-btn admin-btn--primary" style="padding:6px 20px;font-size:0.88rem;" type="submit">Cập nhật</button>
                                </form>
                            </div>
                        </c:if>
                        <c:if test="${empty nextStatuses}">
                            <p class="text-muted small mt-3 mb-0">Đơn đã ở trạng thái kết thúc, không thể chuyển tiếp.</p>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <div class="admin-card mb-4">
            <h3 class="admin-section-title mb-3">&#127861; Sản phẩm trong đơn</h3>
            <div class="table-responsive">
                <table class="table align-middle mb-0">
                    <thead class="table-light"><tr><th>Món</th><th>Tùy chọn</th><th class="text-end">Đơn giá</th><th class="text-center">SL</th><th class="text-end">Thành tiền</th></tr></thead>
                    <tbody>
                    <c:forEach var="item" items="${items}">
                        <tr>
                            <td><strong><c:out value="${item.productName}"/></strong></td>
                            <td>
                                <div>Size <c:out value="${item.sizeName}"/> · Đường <c:out value="${item.sugarLevel}"/> · Đá <c:out value="${item.iceLevel}"/></div>
                                <c:forEach var="topping" items="${item.toppings}">
                                    <div class="small text-muted">+ <c:out value="${topping.toppingName}"/> × <c:out value="${topping.quantity}"/></div>
                                </c:forEach>
                                <c:if test="${not empty item.note}"><div class="small text-muted">Ghi chú: <c:out value="${item.note}"/></div></c:if>
                            </td>
                            <td class="text-end"><fmt:formatNumber value="${item.unitPrice + item.toppingTotalPrice}" type="number" maxFractionDigits="0"/> đ</td>
                            <td class="text-center">x<c:out value="${item.quantity}"/></td>
                            <td class="text-end fw-bold"><fmt:formatNumber value="${item.lineTotal}" type="number" maxFractionDigits="0"/> đ</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty items}"><tr><td colspan="5" class="text-center text-muted">Đơn hàng chưa có dòng sản phẩm.</td></tr></c:if>
                    </tbody>
                </table>
            </div>
            <div class="ms-auto mt-3 pt-3" style="min-width:320px;max-width:380px;border-top:1.5px dashed var(--ut-border, #f0e2d3);">
                <div class="d-flex justify-content-between mb-1"><span>Tạm tính</span><span><fmt:formatNumber value="${order.subtotalAmount}" type="number" maxFractionDigits="0"/> đ</span></div>
                <div class="d-flex justify-content-between mb-1"><span>Phí giao hàng</span><span><fmt:formatNumber value="${order.shippingFee}" type="number" maxFractionDigits="0"/> đ</span></div>
                <div class="d-flex justify-content-between mb-1"><span>Giảm giá</span><span>- <fmt:formatNumber value="${order.discountAmount}" type="number" maxFractionDigits="0"/> đ</span></div>
                <hr>
                <div class="d-flex justify-content-between fw-bold" style="font-size:1.2rem;color:var(--ut-primary, #7b4a2b);"><span>Tổng thanh toán</span><span><fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0"/> đ</span></div>
            </div>
        </div>

        <div class="admin-card">
            <h3 class="admin-section-title mb-3">&#128179; Lịch sử giao dịch thanh toán</h3>
            <div class="table-responsive">
                <table class="table align-middle mb-0">
                    <thead class="table-light"><tr><th>Thời gian</th><th>Nhà cung cấp</th><th>Mã giao dịch</th><th>Trạng thái</th><th class="text-end">Số tiền</th></tr></thead>
                    <tbody>
                    <c:forEach var="payment" items="${payments}">
                        <tr>
                            <td><c:out value="${payment.createdAt}"/></td>
                            <td><c:out value="${payment.provider.label}"/></td>
                            <td><code><c:out value="${payment.transactionRef}"/></code></td>
                            <td>
                                <c:choose>
                                    <c:when test="${payment.status.name() == 'SUCCESS'}"><span class="badge text-bg-success">Thành công</span></c:when>
                                    <c:when test="${payment.status.name() == 'FAILED'}"><span class="badge text-bg-danger">Thất bại</span></c:when>
                                    <c:otherwise><span class="badge text-bg-warning">Đang xử lý</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end fw-bold"><fmt:formatNumber value="${payment.amount}" type="number" maxFractionDigits="0"/> đ</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty payments}"><tr><td colspan="5" class="text-center text-muted py-3">Chưa có giao dịch thanh toán.</td></tr></c:if>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</section>
</body>
</html>
