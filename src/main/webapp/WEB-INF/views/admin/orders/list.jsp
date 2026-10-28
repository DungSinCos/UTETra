<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý đơn hàng</title>
</head>
<body>
<section class="container py-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
        <h1 class="mb-0">Đơn hàng</h1>
        <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/dashboard">Về dashboard</a>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger"><c:out value="${error}"/></div>
    </c:if>

    <form class="row g-2 align-items-end mb-4" method="get" action="${pageContext.request.contextPath}/admin/orders">
        <div class="col-md-3">
            <label class="form-label" for="orderCode">Mã đơn</label>
            <input class="form-control" id="orderCode" name="orderCode" value="<c:out value='${orderCode}'/>" placeholder="Nhập mã đơn">
        </div>
        <div class="col-md-3">
            <label class="form-label" for="status">Trạng thái</label>
            <select class="form-select" id="status" name="status">
                <option value="">Tất cả</option>
                <c:forEach var="itemStatus" items="${orderStatuses}">
                    <option value="${itemStatus}" ${selectedStatus eq itemStatus ? 'selected' : ''}><c:out value="${itemStatus}"/></option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-2">
            <label class="form-label" for="from">Từ ngày</label>
            <input class="form-control" type="date" id="from" name="from" value="${from}">
        </div>
        <div class="col-md-2">
            <label class="form-label" for="to">Đến ngày</label>
            <input class="form-control" type="date" id="to" name="to" value="${to}">
        </div>
        <div class="col-md-2 d-flex gap-2">
            <button class="btn btn-primary" type="submit">Lọc</button>
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/orders">Xóa lọc</a>
        </div>
    </form>

    <div class="table-responsive">
        <table class="table table-hover align-middle">
            <thead>
            <tr>
                <th>Mã đơn</th>
                <th>Khách hàng</th>
                <th>Chi nhánh</th>
                <th>Ngày tạo</th>
                <th class="text-end">Tổng tiền</th>
                <th>Thanh toán</th>
                <th>Trạng thái đơn</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="order" items="${orderPage.content}">
                <tr>
                    <td><strong><c:out value="${order.orderCode}"/></strong></td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty order.user}"><c:out value="${order.user.fullName}"/></c:when>
                            <c:otherwise><c:out value="${order.recipientName}"/> (khách vãng lai)</c:otherwise>
                        </c:choose>
                    </td>
                    <td><c:out value="${order.branch.name}"/></td>
                    <td><c:out value="${order.createdAt}"/></td>
                    <td class="text-end"><fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0"/> đ</td>
                    <td><c:out value="${order.paymentStatus}"/></td>
                    <td><span class="badge text-bg-secondary"><c:out value="${order.orderStatus.label}"/></span></td>
                    <td class="text-end">
                        <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/admin/orders/${order.id}">Chi tiết</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty orderPage.content}">
                <tr><td colspan="8" class="text-center text-muted py-4">Không tìm thấy đơn hàng phù hợp.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <c:if test="${orderPage.totalPages gt 1}">
        <nav aria-label="Phân trang đơn hàng">
            <ul class="pagination justify-content-center">
                <c:if test="${orderPage.hasPrevious()}">
                    <c:url var="previousUrl" value="/admin/orders">
                        <c:param name="page" value="${orderPage.number - 1}"/>
                        <c:if test="${not empty orderCode}"><c:param name="orderCode" value="${orderCode}"/></c:if>
                        <c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if>
                        <c:if test="${not empty from}"><c:param name="from" value="${from}"/></c:if>
                        <c:if test="${not empty to}"><c:param name="to" value="${to}"/></c:if>
                    </c:url>
                    <li class="page-item"><a class="page-link" href="${previousUrl}">Trước</a></li>
                </c:if>
                <li class="page-item disabled"><span class="page-link">${orderPage.number + 1} / ${orderPage.totalPages}</span></li>
                <c:if test="${orderPage.hasNext()}">
                    <c:url var="nextUrl" value="/admin/orders">
                        <c:param name="page" value="${orderPage.number + 1}"/>
                        <c:if test="${not empty orderCode}"><c:param name="orderCode" value="${orderCode}"/></c:if>
                        <c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if>
                        <c:if test="${not empty from}"><c:param name="from" value="${from}"/></c:if>
                        <c:if test="${not empty to}"><c:param name="to" value="${to}"/></c:if>
                    </c:url>
                    <li class="page-item"><a class="page-link" href="${nextUrl}">Sau</a></li>
                </c:if>
            </ul>
        </nav>
    </c:if>
</section>
</body>
</html>
