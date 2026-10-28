<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý danh mục - UTETra Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>
<section class="admin-page">
    <div class="site-container">

        <%-- Admin Navigation Bar --%>
        <jsp:include page="/WEB-INF/views/components/admin-nav.jsp"/>

        <div class="admin-header">
            <div>
                <h1 class="admin-header__title">Quản lý danh mục</h1>
                <div class="admin-header__desc">Phân nhóm menu trà sữa, trà trái cây và sắp xếp thứ tự hiển thị.</div>
            </div>
            <div>
                <a class="admin-btn admin-btn--primary" href="${pageContext.request.contextPath}/admin/categories/new">+ Thêm danh mục mới</a>
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
                        <th>Tên danh mục</th>
                        <th>Đường dẫn tĩnh (Slug)</th>
                        <th class="text-center">Thứ tự</th>
                        <th>Trạng thái</th>
                        <th class="text-center" style="white-space:nowrap;width:140px;">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="category" items="${categories}">
                        <tr>
                            <td><strong style="color:var(--ut-text, #2d1e15);"><c:out value="${category.name}"/></strong></td>
                            <td><code><c:out value="${category.slug}"/></code></td>
                            <td class="text-center fw-bold"><c:out value="${category.displayOrder}"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${category.active}"><span class="badge text-bg-success">Đang hiển thị</span></c:when>
                                    <c:otherwise><span class="badge text-bg-secondary">Đã ẩn</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <a class="admin-btn admin-btn--outline" style="padding:5px 14px;font-size:0.85rem;"
                                   href="${pageContext.request.contextPath}/admin/categories/${category.id}/edit">Sửa</a>
                                <form class="d-inline" method="post"
                                      action="${pageContext.request.contextPath}/admin/categories/${category.id}/${category.active ? 'hide' : 'show'}">
                                    <button class="admin-btn admin-btn--outline" style="padding:5px 14px;font-size:0.85rem;border-color:${category.active ? '#dc3545' : '#15803d'};color:${category.active ? '#dc3545' : '#15803d'};" type="submit">
                                        ${category.active ? 'Ẩn' : 'Hiện'}
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty categories}">
                        <tr><td colspan="5" class="text-center text-muted py-5">Chưa có danh mục nào.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <p class="text-muted small"><em>Lưu ý: Danh mục được ẩn thay vì xóa để bảo toàn tham chiếu sản phẩm trong thực đơn.</em></p>
    </div>
</section>
</body>
</html>
