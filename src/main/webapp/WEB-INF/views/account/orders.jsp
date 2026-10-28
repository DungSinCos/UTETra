<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head><title>Lịch sử đơn hàng</title></head>
<body>
<section class="container py-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
        <h1 class="mb-0">Lịch sử đơn hàng</h1>
        <div class="d-flex flex-wrap gap-2">
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/account/profile">Về tài khoản</a>
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/">Về trang chủ</a>
        </div>
    </div>
    <div class="table-responsive">
        <table class="table table-hover align-middle">
            <thead><tr><th>Mã đơn</th><th>Ngày tạo</th><th>Loại đơn</th><th>Trạng thái đơn</th><th>Thanh toán</th><th class="text-end">Tổng tiền</th></tr></thead>
            <tbody>
            <c:forEach var="order" items="${orderPage.content}">
                <tr>
                    <td><strong><c:out value="${order.orderCode}"/></strong></td>
                    <td><c:out value="${order.createdAt}"/></td>
                    <td><c:out value="${order.orderType.label}"/></td>
                    <td><span class="badge text-bg-secondary"><c:out value="${order.orderStatus.label}"/></span></td>
                    <td><c:out value="${order.paymentStatus.label}"/></td>
                    <td class="text-end"><fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0"/> đ</td>
                </tr>
            </c:forEach>
            <c:if test="${empty orderPage.content}">
                <tr><td colspan="6" class="text-center text-muted py-4">Bạn chưa có đơn hàng nào.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
    <c:if test="${orderPage.totalPages gt 1}">
        <nav aria-label="Phân trang lịch sử đơn hàng">
            <ul class="pagination justify-content-center">
                <c:if test="${orderPage.hasPrevious()}">
                    <c:url var="previousUrl" value="/account/orders"><c:param name="page" value="${orderPage.number - 1}"/></c:url>
                    <li class="page-item"><a class="page-link" href="${previousUrl}">Trước</a></li>
                </c:if>
                <li class="page-item disabled"><span class="page-link">${orderPage.number + 1} / ${orderPage.totalPages}</span></li>
                <c:if test="${orderPage.hasNext()}">
                    <c:url var="nextUrl" value="/account/orders"><c:param name="page" value="${orderPage.number + 1}"/></c:url>
                    <li class="page-item"><a class="page-link" href="${nextUrl}">Sau</a></li>
                </c:if>
            </ul>
        </nav>
    </c:if>
</section>
</body>
</html>
