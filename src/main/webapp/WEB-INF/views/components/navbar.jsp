<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<header class="site-header">
    <div class="site-container header-inner">
        <a class="brand" href="${pageContext.request.contextPath}/">UTETra</a>

        <button class="nav-toggle" type="button" aria-label="Mở menu" aria-expanded="false" data-nav-toggle>
            <span></span>
            <span></span>
            <span></span>
        </button>

        <div class="nav-collapse" data-nav-collapse>
            <nav class="nav-menu">
                <a class="nav-item" href="${pageContext.request.contextPath}/" data-path="/">Trang chủ</a>
                <a class="nav-item" href="${pageContext.request.contextPath}/products" data-path="/products">Thực Đơn</a>
                <a class="nav-item" href="${pageContext.request.contextPath}/about" data-path="/about">Về UTETra</a>
                <a class="nav-item" href="${pageContext.request.contextPath}/support" data-path="/support">Hỗ Trợ</a>
                <a class="nav-item" href="${pageContext.request.contextPath}/cart" data-path="/cart">Giỏ hàng</a>
                <c:if test="${currentUserRole == 'ADMIN' || currentUserRole == 'MANAGER'}">
                    <a class="nav-item" href="${pageContext.request.contextPath}/admin/dashboard" data-path="/admin">Quản trị</a>
                </c:if>
            </nav>

            <div class="nav-actions">
                <c:choose>
                    <c:when test="${not empty currentUser}">
                        <a class="action-btn action-btn--ghost" href="${pageContext.request.contextPath}/account/profile">Tài khoản</a>
                        <span class="nav-user-greeting">
                            Xin chào, <strong><c:out value="${currentUserName}"/></strong>
                        </span>
                        <a class="action-btn action-btn--ghost" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
                    </c:when>
                    <c:otherwise>
                        <a class="action-btn action-btn--ghost" href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                        <a class="action-btn action-btn--solid" href="${pageContext.request.contextPath}/register">Đăng ký</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</header>
