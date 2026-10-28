<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý đơn hàng - UTETra Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>
<section class="admin-page">
    <div class="site-container">

        <%-- Admin Navigation Bar --%>
        <jsp:include page="/WEB-INF/views/components/admin-nav.jsp"/>

        <div class="admin-header">
            <div>
                <h1 class="admin-header__title">Quản lý đơn hàng</h1>
                <div class="admin-header__desc">Tra cứu, lọc và cập nhật trạng thái đơn hàng của hệ thống.</div>
            </div>
            <div>
                <a class="admin-btn admin-btn--outline" href="${pageContext.request.contextPath}/admin/dashboard">&larr; Bảng điều khiển</a>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" style="background:#fee2e2;color:#b91c1c;border-radius:12px;margin-bottom:1.5rem;font-weight:600;">
                &#9888; <c:out value="${error}"/>
            </div>
        </c:if>

        <div class="admin-card mb-4" style="padding:1.25rem 1.5rem;">
            <form class="row g-2 align-items-end" method="get" action="${pageContext.request.contextPath}/admin/orders">
                <div class="col-md-3">
                    <label class="form-label small fw-bold text-muted" for="orderCode">Mã đơn hàng</label>
                    <input class="admin-input-date w-100" id="orderCode" name="orderCode" value="<c:out value='${orderCode}'/>" placeholder="Nhập mã đơn...">
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-bold text-muted" for="status">Trạng thái</label>
                    <select class="admin-input-date w-100" id="status" name="status">
                        <option value="">-- Tất cả trạng thái --</option>
                        <c:forEach var="itemStatus" items="${orderStatuses}">
                            <option value="${itemStatus}" ${selectedStatus eq itemStatus ? 'selected' : ''}><c:out value="${itemStatus.label}"/></option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label small fw-bold text-muted" for="from">Từ ngày</label>
                    <input class="admin-input-date w-100" type="date" id="from" name="from" value="${from}">
                </div>
                <div class="col-md-2">
                    <label class="form-label small fw-bold text-muted" for="to">Đến ngày</label>
                    <input class="admin-input-date w-100" type="date" id="to" name="to" value="${to}">
                </div>
                <div class="col-md-2 d-flex gap-2">
                    <button class="admin-btn admin-btn--primary" style="padding:8px 18px;" type="submit">Lọc</button>
                    <a class="admin-btn admin-btn--outline" style="padding:8px 14px;" href="${pageContext.request.contextPath}/admin/orders">Đặt lại</a>
                </div>
            </form>
        </div>

        <div class="admin-card" style="padding:1.5rem;">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th>Mã đơn</th>
                        <th>Khách hàng</th>
                        <th>Chi nhánh</th>
                        <th>Ngày tạo</th>
                        <th class="text-end">Tổng tiền</th>
                        <th>Thanh toán</th>
                        <th>Trạng thái đơn</th>
                        <th class="text-center" style="white-space:nowrap;width:120px;">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="order" items="${orderPage.content}">
                        <tr>
                            <td><strong style="color:var(--ut-primary, #7b4a2b);"><c:out value="${order.orderCode}"/></strong></td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty order.user}"><strong><c:out value="${order.user.fullName}"/></strong></c:when>
                                    <c:otherwise><c:out value="${order.recipientName}"/> <span class="badge text-bg-light">khách vãng lai</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td><c:out value="${order.branch.name}"/></td>
                            <td><c:out value="${order.createdAt}"/></td>
                            <td class="text-end fw-bold"><fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0"/> đ</td>
                            <td>
                                <c:choose>
                                    <c:when test="${order.paymentStatus.name() == 'PAID'}"><span class="badge text-bg-success">Đã thanh toán</span></c:when>
                                    <c:otherwise><span class="badge text-bg-warning">Chưa thanh toán</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td><span class="badge text-bg-secondary"><c:out value="${order.orderStatus.label}"/></span></td>
                            <td class="text-center">
                                <a class="admin-btn admin-btn--outline" style="padding:6px 16px;font-size:0.85rem;" href="${pageContext.request.contextPath}/admin/orders/${order.id}">Chi tiết</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty orderPage.content}">
                        <tr><td colspan="8" class="text-center text-muted py-5">Không tìm thấy đơn hàng phù hợp.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

            <c:if test="${orderPage.totalPages gt 1}">
                <nav aria-label="Phân trang đơn hàng" class="mt-4">
                    <ul class="pagination justify-content-center mb-0" style="display:flex;gap:0.5rem;list-style:none;padding:0;">
                        <c:if test="${orderPage.hasPrevious()}">
                            <c:url var="previousUrl" value="/admin/orders">
                                <c:param name="page" value="${orderPage.number - 1}"/>
                                <c:if test="${not empty orderCode}"><c:param name="orderCode" value="${orderCode}"/></c:if>
                                <c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if>
                                <c:if test="${not empty from}"><c:param name="from" value="${from}"/></c:if>
                                <c:if test="${not empty to}"><c:param name="to" value="${to}"/></c:if>
                            </c:url>
                            <li><a class="admin-btn admin-btn--outline" style="padding:6px 14px;font-size:0.85rem;" href="${previousUrl}">Trước</a></li>
                        </c:if>
                        <li><span class="admin-btn" style="background:var(--ut-cream, #fff8f0);padding:6px 14px;font-size:0.85rem;cursor:default;">${orderPage.number + 1} / ${orderPage.totalPages}</span></li>
                        <c:if test="${orderPage.hasNext()}">
                            <c:url var="nextUrl" value="/admin/orders">
                                <c:param name="page" value="${orderPage.number + 1}"/>
                                <c:if test="${not empty orderCode}"><c:param name="orderCode" value="${orderCode}"/></c:if>
                                <c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if>
                                <c:if test="${not empty from}"><c:param name="from" value="${from}"/></c:if>
                                <c:if test="${not empty to}"><c:param name="to" value="${to}"/></c:if>
                            </c:url>
                            <li><a class="admin-btn admin-btn--outline" style="padding:6px 14px;font-size:0.85rem;" href="${nextUrl}">Sau</a></li>
                        </c:if>
                    </ul>
                </nav>
            </c:if>
        </div>

    </div>
</section>
</body>
</html>
