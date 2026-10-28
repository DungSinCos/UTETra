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
                        <div class="dropdown profile-dropdown">
                            <button class="action-btn action-btn--solid dropdown-toggle profile-dropdown-toggle"
                                    type="button" id="profileDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                <span>Xin chào, <strong><c:out value="${currentUserName}"/></strong></span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end profile-dropdown-menu" aria-labelledby="profileDropdown">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/account/profile">Thông tin cá nhân</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/account/orders">Lịch sử mua hàng</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/account/change-password">Đổi mật khẩu</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item profile-dropdown-logout" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                            </ul>
                        </div>
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
