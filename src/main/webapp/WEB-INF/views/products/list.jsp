<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
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

        <!-- Top Drink Category Filter Bar (loaded from categories table) -->
        <div class="products-filter-bar" aria-label="Bộ lọc danh mục đồ uống">
            <div class="products-categories" role="tablist" aria-label="Danh mục đồ uống">
                <button type="button"
                        class="category-pill is-active"
                        data-category-btn="all"
                        role="tab"
                        aria-selected="true">
                    Tất cả
                </button>
                <c:forEach var="cat" items="${categories}">
                    <button type="button"
                            class="category-pill"
                            data-category-btn="<c:out value='${cat.slug}'/>"
                            role="tab"
                            aria-selected="false">
                        <c:out value="${cat.name}"/>
                    </button>
                </c:forEach>
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
                <span class="products-count" id="productsCountLabel">
                    Hiển thị <strong><c:out value="${fn:length(products)}"/></strong> sản phẩm
                </span>
            </div>
        </div>

        <!-- Products Grid (loaded from products table via reusable product-card.jsp component) -->
        <fmt:setLocale value="vi_VN"/>
        <div class="product-grid" id="productsGrid" data-context-path="${pageContext.request.contextPath}">
            <c:forEach var="p" items="${products}">
                <fmt:formatNumber value="${p.basePrice}" type="number" maxFractionDigits="0" var="formattedPrice"/>
                <c:set var="catSlug" value="${categorySlugMap[p.categoryId]}"/>
                <c:set var="productCardId" value="${p.id}" scope="request"/>
                <c:set var="productCardName" value="${p.name}" scope="request"/>
                <c:set var="productCardDesc" value="${p.description}" scope="request"/>
                <c:set var="productCardPrice" value="${formattedPrice}đ" scope="request"/>
                <c:set var="productCardImage" value="${p.imageUrl}" scope="request"/>
                <c:set var="productCardBadge" value="${p.featured ? 'Bán chạy' : 'Mới'}" scope="request"/>
                <c:set var="productCardBadgeClass" value="${p.featured ? '' : 'product-badge--new'}" scope="request"/>
                <c:set var="productCardCategory" value="${catSlug}" scope="request"/>
                <jsp:include page="/WEB-INF/views/components/product-card.jsp"/>
            </c:forEach>
        </div>

        <!-- Empty State when no product matches filter -->
        <div class="products-empty" id="productsEmptyState" ${empty products ? '' : 'hidden'}>
            <p>Không tìm thấy đồ uống phù hợp với bộ lọc hiện tại.</p>
            <button type="button" class="products-reset-btn" id="resetFilterBtn">Xem tất cả sản phẩm</button>
        </div>

        <!-- Bottom Pagination -->
        <nav class="products-pagination-wrap" aria-label="Phân trang sản phẩm">
            <ul class="products-pagination" id="productsPagination"></ul>
        </nav>
    </div>
</section>

<script src="${pageContext.request.contextPath}/assets/js/products.js"></script>
</body>
</html>
