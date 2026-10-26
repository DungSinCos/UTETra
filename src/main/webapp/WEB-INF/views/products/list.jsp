<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Thực đơn</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/products.css">
</head>
<body>
<section class="products-page">
    <div class="site-container">
        <!-- Page Heading -->
        <div class="products-header">
            <span class="products-header__tag">Thực đơn UTETra</span>
            <h1 class="products-header__title">Khám phá hương vị <span>đồ uống tươi mới</span></h1>
            <p class="products-header__desc">
                Lá trà nguyên chất, sữa tươi thanh trùng cùng trân châu thủ công nấu mới mỗi ngày.
            </p>
        </div>

        <!-- Top Drink Category Filter Bar -->
        <div class="products-filter-bar" aria-label="Bộ lọc danh mục đồ uống">
            <div class="products-categories" role="tablist" aria-label="Danh mục đồ uống">
                <button type="button"
                        class="category-pill is-active"
                        data-category-btn="all"
                        role="tab"
                        aria-selected="true">
                    Tất cả
                </button>
                <button type="button"
                        class="category-pill"
                        data-category-btn="tra-sua"
                        role="tab"
                        aria-selected="false">
                    Trà sữa
                </button>
                <button type="button"
                        class="category-pill"
                        data-category-btn="tra-trai-cay"
                        role="tab"
                        aria-selected="false">
                    Trà trái cây
                </button>
                <button type="button"
                        class="category-pill"
                        data-category-btn="kem-cheese"
                        role="tab"
                        aria-selected="false">
                    Kem Cheese
                </button>
                <button type="button"
                        class="category-pill"
                        data-category-btn="matcha-latte"
                        role="tab"
                        aria-selected="false">
                    Matcha &amp; Latte
                </button>
            </div>

            <div class="products-toolbar-meta">
                <div class="products-search">
                    <svg class="products-search__icon" viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                        <circle cx="11" cy="11" r="8"/>
                        <line x1="21" y1="21" x2="16.65" y2="16.65"/>
                    </svg>
                    <input type="search"
                           id="productSearchInput"
                           class="products-search__input"
                           placeholder="Tìm tên đồ uống..."
                           aria-label="Tìm tên đồ uống">
                </div>
                <span class="products-count" id="productsCountLabel">Hiển thị <strong>5</strong> sản phẩm</span>
            </div>
        </div>

        <!-- Products Grid (reusing product-card.jsp with homepage product data) -->
        <div class="product-grid" id="productsGrid" data-context-path="${pageContext.request.contextPath}">
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

            <jsp:include page="/WEB-INF/views/components/product-card.jsp">
                <jsp:param name="id" value="5"/>
                <jsp:param name="name" value="Trà Sữa Oolong Kem Cheese"/>
                <jsp:param name="desc" value="Lá trà nguyên chất, sữa tươi thanh trùng cùng trân châu nấu thủ công mỗi sáng."/>
                <jsp:param name="price" value="55.000đ"/>
                <jsp:param name="image" value="https://images.unsplash.com/photo-1558857563-b371033873b8?auto=format&fit=crop&w=800&q=80"/>
                <jsp:param name="badge" value="Mới"/>
                <jsp:param name="badgeClass" value="product-badge--new"/>
                <jsp:param name="category" value="tra-sua"/>
            </jsp:include>
        </div>

        <!-- Empty State when no product matches filter -->
        <div class="products-empty" id="productsEmptyState" hidden>
            <p>Không tìm thấy đồ uống phù hợp với bộ lọc hiện tại.</p>
            <button type="button" class="products-reset-btn" id="resetFilterBtn">Xem tất cả sản phẩm</button>
        </div>

        <!-- Bottom Pagination -->
        <nav class="products-pagination-wrap" aria-label="Phân trang sản phẩm">
            <ul class="products-pagination" id="productsPagination">
                <li>
                    <button type="button" class="page-btn page-btn--nav" data-page="prev" disabled aria-label="Trang trước">
                        &lsaquo; Trước
                    </button>
                </li>
                <li>
                    <button type="button" class="page-btn is-active" data-page="1" aria-current="page">1</button>
                </li>
                <li>
                    <button type="button" class="page-btn" data-page="2">2</button>
                </li>
                <li>
                    <button type="button" class="page-btn page-btn--nav" data-page="next" aria-label="Trang sau">
                        Sau &rsaquo;
                    </button>
                </li>
            </ul>
        </nav>
    </div>
</section>

<script src="${pageContext.request.contextPath}/assets/js/products.js"></script>
</body>
</html>
