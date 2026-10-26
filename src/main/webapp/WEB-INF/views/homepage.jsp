    <%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
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
            <jsp:include page="/WEB-INF/views/components/product-card.jsp">
                <jsp:param name="id" value="1"/>
                <jsp:param name="name" value="Trà Sữa Trân Châu Đường Đen"/>
                <jsp:param name="desc" value="Sữa tươi béo ngậy hòa quyện cùng trân châu đường đen dẻo thơm."/>
                <jsp:param name="price" value="45.000đ"/>
                <jsp:param name="image" value="https://images.unsplash.com/photo-1525385133512-2f3bdd039054?auto=format&fit=crop&w=600&q=80"/>
                <jsp:param name="badge" value="Bán chạy"/>
                <jsp:param name="category" value="tra-sua"/>
            </jsp:include>

            <jsp:include page="/WEB-INF/views/components/product-card.jsp">
                <jsp:param name="id" value="2"/>
                <jsp:param name="name" value="Trà Oolong Kem Cheese"/>
                <jsp:param name="desc" value="Oolong rang thơm nồng phủ lớp kem cheese mặn mịn béo."/>
                <jsp:param name="price" value="49.000đ"/>
                <jsp:param name="image" value="https://images.unsplash.com/photo-1541696490-8744a5dc0228?auto=format&fit=crop&w=600&q=80"/>
                <jsp:param name="badge" value="Mới"/>
                <jsp:param name="badgeClass" value="product-badge--new"/>
                <jsp:param name="category" value="kem-cheese"/>
            </jsp:include>

            <jsp:include page="/WEB-INF/views/components/product-card.jsp">
                <jsp:param name="id" value="3"/>
                <jsp:param name="name" value="Matcha Latte Đậu Đỏ"/>
                <jsp:param name="desc" value="Matcha Uji Nhật Bản kết hợp đậu đỏ ninh mềm ngọt dịu."/>
                <jsp:param name="price" value="52.000đ"/>
                <jsp:param name="image" value="https://images.unsplash.com/photo-1515823064-d6e0c04616a7?auto=format&fit=crop&w=600&q=80"/>
                <jsp:param name="category" value="matcha-latte"/>
            </jsp:include>

            <jsp:include page="/WEB-INF/views/components/product-card.jsp">
                <jsp:param name="id" value="4"/>
                <jsp:param name="name" value="Trà Đào Cam Sả"/>
                <jsp:param name="desc" value="Trà đen thanh mát cùng đào miếng, cam tươi và sả thơm."/>
                <jsp:param name="price" value="42.000đ"/>
                <jsp:param name="image" value="https://images.unsplash.com/photo-1556679343-c7306c1976bc?auto=format&fit=crop&w=600&q=80"/>
                <jsp:param name="badge" value="Bán chạy"/>
                <jsp:param name="category" value="tra-trai-cay"/>
            </jsp:include>
        </div>

        <div class="featured-more">
            <a class="hero-btn hero-btn--outline" href="${pageContext.request.contextPath}/products">Xem toàn bộ thực đơn</a>
        </div>
    </div>
</section>
</body>
</html>
