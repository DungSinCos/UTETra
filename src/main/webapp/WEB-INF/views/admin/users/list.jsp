<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý người dùng - UTETra Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>
<section class="admin-page">
    <div class="site-container">

        <%-- Admin Navigation Bar --%>
        <jsp:include page="/WEB-INF/views/components/admin-nav.jsp"/>

        <div class="admin-header">
            <div>
                <h1 class="admin-header__title">Quản lý người dùng</h1>
                <div class="admin-header__desc">Danh sách tài khoản khách hàng, nhân viên và quản trị viên.</div>
            </div>
            <div>
                <a class="admin-btn admin-btn--outline" href="${pageContext.request.contextPath}/admin/dashboard">&larr; Bảng điều khiển</a>
            </div>
        </div>

        <div class="admin-card mb-4" style="padding:1.25rem 1.5rem;">
            <form class="row g-2 align-items-end" method="get" action="${pageContext.request.contextPath}/admin/users">
                <div class="col-md-6">
                    <label class="form-label small fw-bold text-muted" for="q">Tìm tên, email hoặc số điện thoại</label>
                    <input class="admin-input-date w-100" id="q" name="q" value="<c:out value='${query}'/>" placeholder="Nhập từ khóa tìm kiếm...">
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-bold text-muted" for="status">Trạng thái</label>
                    <select class="admin-input-date w-100" id="status" name="status">
                        <option value="">-- Tất cả trạng thái --</option>
                        <c:forEach var="itemStatus" items="${statuses}">
                            <option value="${itemStatus}" ${selectedStatus eq itemStatus ? 'selected' : ''}><c:out value="${itemStatus.label}"/></option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3 d-flex gap-2">
                    <button class="admin-btn admin-btn--primary" style="padding:8px 18px;" type="submit">Tìm kiếm</button>
                    <a class="admin-btn admin-btn--outline" style="padding:8px 14px;" href="${pageContext.request.contextPath}/admin/users">Xóa lọc</a>
                </div>
            </form>
        </div>

        <div class="admin-card" style="padding:1.5rem;">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th>Họ tên</th>
                        <th>Email</th>
                        <th>Điện thoại</th>
                        <th>Vai trò</th>
                        <th>Trạng thái</th>
                        <th class="text-center" style="white-space:nowrap;width:120px;">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="user" items="${userPage.content}">
                        <tr>
                            <td><strong style="color:var(--ut-text, #2d1e15);"><c:out value="${user.fullName}"/></strong></td>
                            <td><c:out value="${user.email}"/></td>
                            <td><c:out value="${user.phone}"/></td>
                            <td><span class="badge text-bg-light" style="border:1px solid #e2e8f0;"><c:out value="${user.role.label}"/></span></td>
                            <td>
                                <c:choose>
                                    <c:when test="${user.status.name() == 'ACTIVE'}"><span class="badge text-bg-success">Hoạt động</span></c:when>
                                    <c:otherwise><span class="badge text-bg-danger">Bị khóa</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <a class="admin-btn admin-btn--outline" style="padding:5px 14px;font-size:0.85rem;" href="${pageContext.request.contextPath}/admin/users/${user.id}">Chi tiết</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty userPage.content}">
                        <tr><td colspan="6" class="text-center text-muted py-5">Không tìm thấy người dùng phù hợp.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

            <c:if test="${userPage.totalPages gt 1}">
                <nav aria-label="Phân trang người dùng" class="mt-4">
                    <ul class="pagination justify-content-center mb-0" style="display:flex;gap:0.5rem;list-style:none;padding:0;">
                        <c:if test="${userPage.hasPrevious()}">
                            <c:url var="previousUrl" value="/admin/users"><c:param name="page" value="${userPage.number - 1}"/><c:if test="${not empty query}"><c:param name="q" value="${query}"/></c:if><c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if></c:url>
                            <li><a class="admin-btn admin-btn--outline" style="padding:6px 14px;font-size:0.85rem;" href="${previousUrl}">Trước</a></li>
                        </c:if>
                        <li><span class="admin-btn" style="background:var(--ut-cream, #fff8f0);padding:6px 14px;font-size:0.85rem;cursor:default;">${userPage.number + 1} / ${userPage.totalPages}</span></li>
                        <c:if test="${userPage.hasNext()}">
                            <c:url var="nextUrl" value="/admin/users"><c:param name="page" value="${userPage.number + 1}"/><c:if test="${not empty query}"><c:param name="q" value="${query}"/></c:if><c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if></c:url>
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
