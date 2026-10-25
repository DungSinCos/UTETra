<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<footer class="site-footer mt-5 py-4">
    <div class="container">
        <div class="row gy-3">
            <div class="col-md-4">
                <h6 class="fw-bold text-white mb-2">🧋 UTETra</h6>
                <small>Trà sữa pha mới mỗi ngày, giao tận nơi.</small>
            </div>
            <div class="col-md-4">
                <h6 class="fw-bold text-white mb-2">Liên kết</h6>
                <ul class="list-unstyled mb-0 small">
                    <li><a href="${ctx}/">Trang chủ</a></li>
                    <li><a href="${ctx}/products">Sản phẩm</a></li>
                    <li><a href="${ctx}/login">Đăng nhập</a></li>
                </ul>
            </div>
            <div class="col-md-4">
                <h6 class="fw-bold text-white mb-2">Liên hệ</h6>
                <small class="d-block">Hotline: 0900 000 000</small>
                <small class="d-block">Email: hello@utetra.vn</small>
            </div>
        </div>
        <hr class="border-light opacity-25 my-3">
        <small>&copy; 2026 UTETra</small>
    </div>
</footer>
