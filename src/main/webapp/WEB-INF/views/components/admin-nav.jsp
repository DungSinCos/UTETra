<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="admin-navbar-wrap">
    <nav class="admin-nav-bar" aria-label="Thanh điều hướng Quản trị">
        <a class="admin-nav-link ${pageContext.request.requestURI.endsWith('dashboard.jsp') or pageContext.request.servletPath eq '/admin/dashboard' ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/admin/dashboard">
            Bảng điều khiển
        </a>
        <a class="admin-nav-link ${pageContext.request.requestURI.contains('/admin/orders') ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/admin/orders">
            Quản lý đơn hàng
        </a>
        <a class="admin-nav-link ${pageContext.request.requestURI.contains('/admin/products') ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/admin/products">
            Quản lý sản phẩm
        </a>
        <a class="admin-nav-link ${pageContext.request.requestURI.contains('/admin/categories') ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/admin/categories">
            Quản lý danh mục
        </a>
        <a class="admin-nav-link ${pageContext.request.requestURI.contains('/admin/branches') ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/admin/branches">
            Quản lý chi nhánh
        </a>
        <c:if test="${currentUserRole == 'ADMIN'}">
            <a class="admin-nav-link ${pageContext.request.requestURI.contains('/admin/users') ? 'is-active' : ''}"
               href="${pageContext.request.contextPath}/admin/users">
                Quản lý người dùng
            </a>
        </c:if>
        <a class="admin-nav-link admin-nav-link--store"
           href="${pageContext.request.contextPath}/products" target="_blank" title="Mở trang thực đơn công khai">
            Xem thực đơn &#8599;
        </a>
    </nav>
</div>
