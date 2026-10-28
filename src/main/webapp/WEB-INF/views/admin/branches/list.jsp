<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý chi nhánh - UTETra</title>
</head>
<body>
<section class="container py-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <div class="d-flex align-items-center gap-2 mb-1">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-sm btn-outline-secondary">&larr; Bảng điều khiển</a>
                <h1 class="h3 mb-0">Quản lý chi nhánh</h1>
            </div>
            <p class="text-muted mb-0 small">
                Tổng cộng: <strong>${totalCount}</strong> chi nhánh
                (<span class="text-success">${activeCount} đang hoạt động</span>,
                 <span class="text-secondary">${inactiveCount} tạm dừng</span>)
            </p>
        </div>
        <div class="d-flex gap-2">
            <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/branches" target="_blank">
                Xem trang khách hàng &nearr;
            </a>
            <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/branches/new">
                + Thêm chi nhánh mới
            </a>
        </div>
    </div>

    <c:if test="${not empty message}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <c:out value="${message}"/>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th style="width: 70px" class="text-center">#</th>
                        <th style="width: 140px">Mã CN</th>
                        <th>Tên chi nhánh</th>
                        <th>Địa chỉ</th>
                        <th>Quận / Huyện</th>
                        <th>Điện thoại</th>
                        <th style="width: 130px" class="text-center">Trạng thái</th>
                        <th style="width: 180px" class="text-end pe-3">Thao tác</th>
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
                                <strong><c:out value="${branch.name}"/></strong>
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
                                        <a href="tel:${branch.phone}" class="text-decoration-none text-nowrap">
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
                                        <span class="badge text-bg-success">Hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge text-bg-secondary">Tạm dừng</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end pe-3 text-nowrap">
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
    </div>

    <div class="mt-3 text-muted small">
        * Chi nhánh được tạm dừng thay vì xóa hẳn để bảo toàn dữ liệu lịch sử đơn hàng và báo cáo thống kê.
    </div>
</section>
</body>
</html>
