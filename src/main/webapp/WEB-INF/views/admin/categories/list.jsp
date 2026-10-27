<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý danh mục</title>
</head>
<body>
<section class="container py-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
        <h1 class="mb-0">Danh mục sản phẩm</h1>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/categories/new">+ Thêm danh mục</a>
    </div>

    <c:if test="${not empty message}">
        <div class="alert alert-success"><c:out value="${message}"/></div>
    </c:if>

    <div class="table-responsive">
        <table class="table align-middle">
            <thead>
            <tr>
                <th>Tên</th>
                <th>Slug</th>
                <th class="text-center">Thứ tự</th>
                <th>Trạng thái</th>
                <th class="text-end">Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="category" items="${categories}">
                <tr>
                    <td><c:out value="${category.name}"/></td>
                    <td><code><c:out value="${category.slug}"/></code></td>
                    <td class="text-center"><c:out value="${category.displayOrder}"/></td>
                    <td>
                        <c:choose>
                            <c:when test="${category.active}"><span class="badge text-bg-success">Đang hiển thị</span></c:when>
                            <c:otherwise><span class="badge text-bg-secondary">Đã ẩn</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td class="text-end">
                        <a class="btn btn-sm btn-outline-secondary"
                           href="${pageContext.request.contextPath}/admin/categories/${category.id}/edit">Sửa</a>
                        <form class="d-inline" method="post"
                              action="${pageContext.request.contextPath}/admin/categories/${category.id}/${category.active ? 'hide' : 'show'}">
                            <button class="btn btn-sm ${category.active ? 'btn-outline-danger' : 'btn-outline-success'}" type="submit">
                                ${category.active ? 'Ẩn' : 'Hiện'}
                            </button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty categories}">
                <tr><td colspan="5" class="text-center text-muted py-4">Chưa có danh mục nào.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
    <p class="text-muted small">Danh mục được ẩn thay vì xóa để giữ nguyên tham chiếu của sản phẩm.</p>
</section>
</body>
</html>
