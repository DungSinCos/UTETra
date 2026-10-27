<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head><title>Quản lý người dùng</title></head>
<body>
<section class="container py-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
        <h1 class="mb-0">Người dùng</h1>
        <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/dashboard">Về dashboard</a>
    </div>

    <form class="row g-2 align-items-end mb-4" method="get" action="${pageContext.request.contextPath}/admin/users">
        <div class="col-md-6">
            <label class="form-label" for="q">Tìm tên, email hoặc số điện thoại</label>
            <input class="form-control" id="q" name="q" value="<c:out value='${query}'/>" placeholder="Nhập thông tin cần tìm">
        </div>
        <div class="col-md-3">
            <label class="form-label" for="status">Trạng thái</label>
            <select class="form-select" id="status" name="status">
                <option value="">Tất cả</option>
                <c:forEach var="itemStatus" items="${statuses}">
                    <option value="${itemStatus}" ${selectedStatus eq itemStatus ? 'selected' : ''}><c:out value="${itemStatus.label}"/></option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-3 d-flex gap-2">
            <button class="btn btn-primary" type="submit">Tìm</button>
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/users">Xóa lọc</a>
        </div>
    </form>

    <div class="table-responsive">
        <table class="table table-hover align-middle">
            <thead><tr><th>Họ tên</th><th>Email</th><th>Điện thoại</th><th>Vai trò</th><th>Trạng thái</th><th></th></tr></thead>
            <tbody>
            <c:forEach var="user" items="${userPage.content}">
                <tr>
                    <td><c:out value="${user.fullName}"/></td>
                    <td><c:out value="${user.email}"/></td>
                    <td><c:out value="${user.phone}"/></td>
                    <td><c:out value="${user.role.label}"/></td>
                    <td><c:out value="${user.status.label}"/></td>
                    <td class="text-end"><a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/admin/users/${user.id}">Chi tiết</a></td>
                </tr>
            </c:forEach>
            <c:if test="${empty userPage.content}"><tr><td colspan="6" class="text-center text-muted py-4">Không tìm thấy người dùng.</td></tr></c:if>
            </tbody>
        </table>
    </div>
    <c:if test="${userPage.totalPages gt 1}">
        <nav aria-label="Phân trang người dùng"><ul class="pagination justify-content-center">
            <c:if test="${userPage.hasPrevious()}">
                <c:url var="previousUrl" value="/admin/users"><c:param name="page" value="${userPage.number - 1}"/><c:if test="${not empty query}"><c:param name="q" value="${query}"/></c:if><c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if></c:url>
                <li class="page-item"><a class="page-link" href="${previousUrl}">Trước</a></li>
            </c:if>
            <li class="page-item disabled"><span class="page-link">${userPage.number + 1} / ${userPage.totalPages}</span></li>
            <c:if test="${userPage.hasNext()}">
                <c:url var="nextUrl" value="/admin/users"><c:param name="page" value="${userPage.number + 1}"/><c:if test="${not empty query}"><c:param name="q" value="${query}"/></c:if><c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if></c:url>
                <li class="page-item"><a class="page-link" href="${nextUrl}">Sau</a></li>
            </c:if>
        </ul></nav>
    </c:if>
</section>
</body>
</html>
