<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý sản phẩm - UTETra Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>
<section class="admin-page">
    <div class="site-container">

        <%-- Admin Navigation Bar --%>
        <jsp:include page="/WEB-INF/views/components/admin-nav.jsp"/>

        <div class="admin-header">
            <div>
                <h1 class="admin-header__title">Quản lý sản phẩm</h1>
                <div class="admin-header__desc">Danh sách toàn bộ thức uống trên menu UTETra.</div>
            </div>
            <div>
                <a class="admin-btn admin-btn--primary" href="${pageContext.request.contextPath}/admin/products/new">+ Thêm sản phẩm mới</a>
            </div>
        </div>

        <c:if test="${not empty message}">
            <div class="alert alert-success" style="background:#dcfce7;color:#15803d;border-radius:12px;margin-bottom:1.5rem;font-weight:600;">
                &#10003; <c:out value="${message}"/>
            </div>
        </c:if>

        <div class="admin-card" style="padding:1.5rem;">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th style="width:72px">Ảnh</th>
                        <th>SKU</th>
                        <th>Tên sản phẩm</th>
                        <th class="text-end">Giá cơ bản</th>
                        <th>Trạng thái</th>
                        <th class="text-center" style="white-space:nowrap;width:140px;">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="p" items="${products}">
                        <tr>
                            <td>
                                <c:if test="${not empty p.imageUrl}">
                                    <img src="<c:out value='${p.imageUrl}'/>" alt="" width="56" height="56" style="object-fit:cover;border-radius:10px;border:1px solid #f0e2d3;">
                                </c:if>
                            </td>
                            <td><code><c:out value="${p.sku}"/></code></td>
                            <td><strong style="color:var(--ut-text, #2d1e15);"><c:out value="${p.name}"/></strong></td>
                            <td class="text-end fw-bold"><fmt:formatNumber value="${p.basePrice}" type="number" maxFractionDigits="0"/> đ</td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.active}"><span class="badge text-bg-success">Đang bán</span></c:when>
                                    <c:otherwise><span class="badge text-bg-secondary">Đã ẩn</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <a class="admin-btn admin-btn--outline" style="padding:5px 14px;font-size:0.85rem;"
                                   href="${pageContext.request.contextPath}/admin/products/${p.id}/edit">Sửa</a>
                                <form class="d-inline" method="post"
                                      action="${pageContext.request.contextPath}/admin/products/${p.id}/${p.active ? 'hide' : 'show'}">
                                    <button class="admin-btn admin-btn--outline" style="padding:5px 14px;font-size:0.85rem;border-color:#dc3545;color:#dc3545;" type="submit">
                                        ${p.active ? 'Ẩn' : 'Hiện'}
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty products}">
                        <tr><td colspan="6" class="text-center text-muted py-5">Chưa có sản phẩm nào.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</section>
</body>
</html>
