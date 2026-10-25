<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Trang chủ</title>
</head>
<body>
    <!-- Hero banner -->
    <section class="hero py-5">
        <div class="container">
            <div class="row align-items-center gy-4">
                <div class="col-md-7">
                    <h1 class="display-5 mb-3">Trà sữa pha mới,<br>uống là mê.</h1>
                    <p class="lead text-secondary mb-4">
                        Trà ủ mỗi sáng, trân châu nấu tại quầy. Chọn mức đường, mức đá theo ý bạn.
                    </p>
                    <a class="btn btn-brand btn-lg me-2" href="${pageContext.request.contextPath}/products">Xem thực đơn</a>
                    <a class="btn btn-outline-brand btn-lg" href="${pageContext.request.contextPath}/register">Tạo tài khoản</a>
                </div>
                <div class="col-md-5">
                    <div class="hero-cup">🧋</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Món bán chạy (tạm hardcode, sau này lấy từ DB) -->
    <section class="container py-5">
        <div class="d-flex justify-content-between align-items-end mb-3">
            <h2 class="h4 mb-0">Món bán chạy</h2>
            <a href="${pageContext.request.contextPath}/products">Xem tất cả</a>
        </div>
        <div class="row g-3">
            <div class="col-md-4">
                <div class="card product-card h-100">
                    <div class="product-thumb">🧋</div>
                    <div class="card-body">
                        <h3 class="h6">Trà sữa trân châu đường đen</h3>
                        <div class="product-price">45.000đ</div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card product-card h-100">
                    <div class="product-thumb">🍑</div>
                    <div class="card-body">
                        <h3 class="h6">Trà đào cam sả</h3>
                        <div class="product-price">42.000đ</div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card product-card h-100">
                    <div class="product-thumb">🍵</div>
                    <div class="card-body">
                        <h3 class="h6">Matcha latte</h3>
                        <div class="product-price">49.000đ</div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</body>
</html>
