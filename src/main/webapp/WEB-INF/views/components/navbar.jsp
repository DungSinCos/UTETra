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
                <a class="nav-item" href="${pageContext.request.contextPath}/branches" data-path="/branches">Chi nhánh</a>
                <a class="nav-item" href="${pageContext.request.contextPath}/about" data-path="/about">Về UTETra</a>
                <a class="nav-item" href="${pageContext.request.contextPath}/support" data-path="/support">Hỗ Trợ</a>

                <%-- Icon Giỏ hàng theo hình vẽ --%>
                <a class="nav-item nav-item--cart" href="${pageContext.request.contextPath}/cart" data-path="/cart" title="Giỏ hàng" aria-label="Giỏ hàng">
                    <svg class="nav-cart-icon" width="22" height="22" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M2.5 3.5H5.2L7.3 14.2C7.45 14.9 8.1 15.5 8.8 15.5H18.5C19.2 15.5 19.8 15 20 14.3L21.8 7.5H5.8" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>
                        <circle cx="9.5" cy="19.5" r="1.8" fill="currentColor"/>
                        <circle cx="17.5" cy="19.5" r="1.8" fill="currentColor"/>
                    </svg>
                </a>

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
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/account/orders">Quản lý đơn hàng</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/account/change-password">Đổi mật khẩu</a></li>

                                <%-- Option Quản trị: CHỈ hiện khi đăng nhập và có quyền ADMIN hoặc MANAGER --%>
                                <c:if test="${currentUserRole == 'ADMIN' || currentUserRole == 'MANAGER'}">
                                    <li><hr class="dropdown-divider"></li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard" style="color:var(--ut-primary, #7b4a2b);font-weight:700;">
                                            Trang quản trị
                                        </a>
                                    </li>
                                </c:if>

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
