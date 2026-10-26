<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Trang chủ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
</head>
<body>
<section class="hero">
    <div class="site-container hero-inner">
        <div class="hero-content">
            <span class="hero-tag">Mới ra mắt &bull; Trà Sữa Oolong Kem Cheese</span>
            <h1 class="hero-title">Trà sữa tươi <span>pha mỗi ngày</span> cho ngày dài thêm ngọt ngào</h1>
            <p class="hero-desc">Lá trà nguyên chất, sữa tươi thanh trùng cùng trân châu nấu thủ công mỗi sáng. UTETra mang đến ly trà sữa đậm vị, ít ngọt và luôn tươi mới.</p>
            <div class="hero-actions">
                <a class="hero-btn hero-btn--primary" href="${pageContext.request.contextPath}/products">Đặt ngay</a>
                <a class="hero-btn hero-btn--outline" href="${pageContext.request.contextPath}/products">Xem thực đơn</a>
            </div>
            <ul class="hero-stats">
                <li><strong>20+</strong><span>Cửa hàng</span></li>
                <li><strong>50+</strong><span>Món đồ uống</span></li>
                <li><strong>100K+</strong><span>Khách hàng</span></li>
            </ul>
        </div>
        <div class="hero-visual">
            <div class="hero-blob"></div>
            <img class="hero-img" src="https://images.unsplash.com/photo-1558857563-b371033873b8?auto=format&fit=crop&w=800&q=80" alt="Trà sữa UTETra">
            <div class="hero-badge hero-badge--top">
                <strong>4.9&#9733;</strong>
                <span>Đánh giá</span>
            </div>
            <div class="hero-badge hero-badge--bottom">
                <strong>Freeship</strong>
                <span>Đơn từ 99K</span>
            </div>
        </div>
    </div>
</section>

<section class="featured">
    <div class="site-container">
        <div class="section-head">
            <span class="section-tag">Được yêu thích nhất</span>
            <h2 class="section-title">Sản phẩm nổi bật</h2>
            <p class="section-desc">Những ly trà sữa được khách hàng UTETra lựa chọn nhiều nhất trong tháng.</p>
        </div>

        <div class="product-grid">
            <fmt:setLocale value="vi_VN"/>
            <c:forEach var="p" items="${featuredProducts}">
                <fmt:formatNumber value="${p.basePrice}" type="number" maxFractionDigits="0" var="formattedPrice"/>
                <jsp:include page="/WEB-INF/views/components/product-card.jsp">
                    <jsp:param name="id" value="${p.id}"/>
                    <jsp:param name="name" value="${p.name}"/>
                    <jsp:param name="desc" value="${p.description}"/>
                    <jsp:param name="price" value="${formattedPrice}đ"/>
                    <jsp:param name="image" value="${p.imageUrl}"/>
                    <jsp:param name="badge" value="${p.featured ? 'Nổi bật' : ''}"/>
                    <jsp:param name="category" value="${p.categoryId}"/>
                </jsp:include>
            </c:forEach>
        </div>

        <div class="featured-more">
            <a class="hero-btn hero-btn--outline" href="${pageContext.request.contextPath}/products">Xem toàn bộ thực đơn</a>
        </div>
    </div>
</section>
</body>
</html>
