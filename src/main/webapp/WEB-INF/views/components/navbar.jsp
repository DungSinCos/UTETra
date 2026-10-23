<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
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
                <a class="nav-item" href="${pageContext.request.contextPath}/menu" data-path="/menu">Thực Đơn</a>
                <a class="nav-item" href="${pageContext.request.contextPath}/about" data-path="/about">Về UTETra</a>
                <a class="nav-item" href="${pageContext.request.contextPath}/support" data-path="/support">Hỗ Trợ</a>
            </nav>

            <div class="nav-actions">
                <a class="action-btn action-btn--ghost" href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                <a class="action-btn action-btn--solid" href="${pageContext.request.contextPath}/register">Đăng ký</a>
            </div>
        </div>
    </div>
</header>
