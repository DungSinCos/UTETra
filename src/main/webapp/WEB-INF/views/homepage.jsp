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
                <a class="hero-btn hero-btn--primary" href="${pageContext.request.contextPath}/menu">Đặt ngay</a>
                <a class="hero-btn hero-btn--outline" href="${pageContext.request.contextPath}/menu">Xem thực đơn</a>
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
            <article class="product-item">
                <div class="product-thumb">
                    <span class="product-badge">Bán chạy</span>
                    <img src="https://images.unsplash.com/photo-1525385133512-2f3bdd039054?auto=format&fit=crop&w=600&q=80" alt="Trà Sữa Trân Châu Đường Đen">
                </div>
                <div class="product-body">
                    <h3 class="product-name">Trà Sữa Trân Châu Đường Đen</h3>
                    <p class="product-desc">Sữa tươi béo ngậy hòa quyện cùng trân châu đường đen dẻo thơm.</p>
                    <div class="product-footer">
                        <span class="product-price">45.000đ</span>
                        <a class="product-add" href="${pageContext.request.contextPath}/menu" aria-label="Thêm vào giỏ">+</a>
                    </div>
                </div>
            </article>

            <article class="product-item">
                <div class="product-thumb">
                    <span class="product-badge product-badge--new">Mới</span>
                    <img src="https://images.unsplash.com/photo-1541696490-8744a5dc0228?auto=format&fit=crop&w=600&q=80" alt="Trà Oolong Kem Cheese">
                </div>
                <div class="product-body">
                    <h3 class="product-name">Trà Oolong Kem Cheese</h3>
                    <p class="product-desc">Oolong rang thơm nồng phủ lớp kem cheese mặn mịn béo.</p>
                    <div class="product-footer">
                        <span class="product-price">49.000đ</span>
                        <a class="product-add" href="${pageContext.request.contextPath}/menu" aria-label="Thêm vào giỏ">+</a>
                    </div>
                </div>
            </article>

            <article class="product-item">
                <div class="product-thumb">
                    <img src="https://images.unsplash.com/photo-1515823064-d6e0c04616a7?auto=format&fit=crop&w=600&q=80" alt="Matcha Latte Đậu Đỏ">
                </div>
                <div class="product-body">
                    <h3 class="product-name">Matcha Latte Đậu Đỏ</h3>
                    <p class="product-desc">Matcha Uji Nhật Bản kết hợp đậu đỏ ninh mềm ngọt dịu.</p>
                    <div class="product-footer">
                        <span class="product-price">52.000đ</span>
                        <a class="product-add" href="${pageContext.request.contextPath}/menu" aria-label="Thêm vào giỏ">+</a>
                    </div>
                </div>
            </article>

            <article class="product-item">
                <div class="product-thumb">
                    <span class="product-badge">Bán chạy</span>
                    <img src="https://images.unsplash.com/photo-1556679343-c7306c1976bc?auto=format&fit=crop&w=600&q=80" alt="Trà Đào Cam Sả">
                </div>
                <div class="product-body">
                    <h3 class="product-name">Trà Đào Cam Sả</h3>
                    <p class="product-desc">Trà đen thanh mát cùng đào miếng, cam tươi và sả thơm.</p>
                    <div class="product-footer">
                        <span class="product-price">42.000đ</span>
                        <a class="product-add" href="${pageContext.request.contextPath}/menu" aria-label="Thêm vào giỏ">+</a>
                    </div>
                </div>
            </article>
        </div>

        <div class="featured-more">
            <a class="hero-btn hero-btn--outline" href="${pageContext.request.contextPath}/menu">Xem toàn bộ thực đơn</a>
        </div>
    </div>
</section>
</body>
</html>
