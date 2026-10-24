<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý sản phẩm</title>
</head>
<body>
<section class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="mb-0">Sản phẩm</h1>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/products/new">+ Thêm sản phẩm</a>
    </div>

    <c:if test="${not empty message}">
        <div class="alert alert-success"><c:out value="${message}"/></div>
    </c:if>

    <div class="table-responsive">
        <table class="table align-middle">
            <thead>
            <tr>
                <th style="width:72px">Ảnh</th>
                <th>SKU</th>
                <th>Tên</th>
                <th class="text-end">Giá</th>
                <th>Trạng thái</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="p" items="${products}">
                <tr>
                    <td>
                        <c:if test="${not empty p.imageUrl}">
                            <img src="<c:out value='${p.imageUrl}'/>" alt="" width="56" height="56" style="object-fit:cover" class="rounded">
                        </c:if>
                    </td>
                    <td><c:out value="${p.sku}"/></td>
                    <td><c:out value="${p.name}"/></td>
                    <td class="text-end"><fmt:formatNumber value="${p.basePrice}" type="number" maxFractionDigits="0"/> đ</td>
                    <td>
                        <c:choose>
                            <c:when test="${p.active}"><span class="badge text-bg-success">Đang bán</span></c:when>
                            <c:otherwise><span class="badge text-bg-secondary">Đã ẩn</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td class="text-end">
                        <a class="btn btn-sm btn-outline-secondary"
                           href="${pageContext.request.contextPath}/admin/products/${p.id}/edit">Sửa</a>
                        <form class="d-inline" method="post"
                              action="${pageContext.request.contextPath}/admin/products/${p.id}/${p.active ? 'hide' : 'show'}">
                            <button class="btn btn-sm btn-outline-danger" type="submit">
                                ${p.active ? 'Ẩn' : 'Hiện'}
                            </button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty products}">
                <tr><td colspan="6" class="text-center text-muted py-4">Chưa có sản phẩm nào.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</section>
</body>
</html>
