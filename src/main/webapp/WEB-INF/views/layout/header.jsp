<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="uri" value="${pageContext.request.requestURI}"/>

<nav class="navbar navbar-expand-lg bg-white border-bottom sticky-top">
    <div class="container">
        <a class="navbar-brand" href="${ctx}/">🧋 UTETra</a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                data-bs-target="#mainNav" aria-controls="mainNav" aria-expanded="false" aria-label="Mở menu">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="mainNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link ${uri eq ctx.concat('/') or fn:endsWith(uri, '/home') ? 'active' : ''}"
                       href="${ctx}/">Trang chủ</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${fn:endsWith(uri, '/products') ? 'active' : ''}"
                       href="${ctx}/products">Sản phẩm</a>
                </li>
            </ul>

            <div class="d-flex gap-2">
                <a class="btn btn-outline-brand btn-sm" href="${ctx}/login">Đăng nhập</a>
                <a class="btn btn-brand btn-sm" href="${ctx}/register">Đăng ký</a>
            </div>
        </div>
    </div>
</nav>
