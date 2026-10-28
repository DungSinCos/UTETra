<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý chi nhánh - UTETra Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>
<section class="admin-page">
    <div class="site-container">

        <%-- Admin Navigation Bar --%>
        <jsp:include page="/WEB-INF/views/components/admin-nav.jsp"/>

        <%-- Admin Header --%>
        <div class="admin-header">
            <div>
                <h1 class="admin-header__title">Quản lý chi nhánh</h1>
                <div class="admin-header__desc">
                    Hệ thống hiện có <strong>${totalCount}</strong> chi nhánh
                    (<span style="color:#15803d;font-weight:600;">${activeCount} đang hoạt động</span>,
                     <span style="color:#64748b;font-weight:600;">${inactiveCount} tạm dừng</span>).
                </div>
            </div>
            <div class="d-flex gap-2">
                <a class="admin-btn admin-btn--filter" href="${pageContext.request.contextPath}/branches" target="_blank">
                    Xem trang chi nhánh &#8599;
                </a>
                <a class="admin-btn admin-btn--primary" href="${pageContext.request.contextPath}/admin/branches/new">
                    + Thêm chi nhánh mới
                </a>
            </div>
        </div>

        <c:if test="${not empty message}">
            <div class="alert alert-success" style="background:#dcfce7;color:#15803d;border-radius:12px;margin-bottom:1.5rem;font-weight:600;">
                &#10003; <c:out value="${message}"/>
            </div>
        </c:if>

        <div class="admin-card mb-4" style="padding:1.5rem;">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th style="width: 60px" class="text-center">#</th>
                        <th style="width: 130px">Mã CN</th>
                        <th>Tên chi nhánh</th>
                        <th>Địa chỉ</th>
                        <th>Quận / Huyện</th>
                        <th>Điện thoại</th>
                        <th style="width: 130px" class="text-center">Trạng thái</th>
                        <th style="width: 160px" class="text-center">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="branch" items="${branches}">
                        <tr>
                            <td class="text-center text-muted">${branch.id}</td>
                            <td>
                                <span class="badge bg-light text-dark border font-monospace">
                                    <c:out value="${branch.code}"/>
                                </span>
                            </td>
                            <td>
                                <strong style="color:var(--ut-text, #2d1e15);"><c:out value="${branch.name}"/></strong>
                            </td>
                            <td>
                                <span class="text-secondary"><c:out value="${branch.addressLine}"/></span>
                            </td>
                            <td>
                                <span class="badge text-bg-light border"><c:out value="${branch.district}"/></span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty branch.phone}">
                                        <a href="tel:${branch.phone}" class="text-decoration-none text-nowrap" style="color:var(--ut-primary, #7b4a2b);">
                                            <c:out value="${branch.phone}"/>
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted small">--</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <c:choose>
                                    <c:when test="${branch.active}">
                                        <span class="badge text-bg-success">Đang hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge text-bg-secondary">Tạm dừng</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center text-nowrap">
                                <a class="btn btn-sm btn-outline-secondary me-1"
                                   href="${pageContext.request.contextPath}/admin/branches/${branch.id}/edit">
                                    Sửa
                                </a>
                                <form class="d-inline" method="post"
                                      action="${pageContext.request.contextPath}/admin/branches/${branch.id}/${branch.active ? 'hide' : 'show'}">
                                    <button class="btn btn-sm ${branch.active ? 'btn-outline-danger' : 'btn-outline-success'}"
                                            type="submit"
                                            onclick="return confirm('${branch.active ? 'Tạm dừng hoạt động chi nhánh này?' : 'Kích hoạt lại chi nhánh này?'}');">
                                        ${branch.active ? 'Tạm dừng' : 'Kích hoạt'}
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty branches}">
                        <tr>
                            <td colspan="8" class="text-center text-muted py-5">
                                Chưa có chi nhánh nào trong hệ thống.
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <p class="text-muted small mb-0">
            * Chi nhánh được tạm dừng thay vì xóa để bảo toàn lịch sử đơn hàng và thống kê hệ thống.
        </p>
    </div>
</section>
</body>
</html>
