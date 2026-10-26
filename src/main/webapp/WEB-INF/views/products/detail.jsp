<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN"/>
<fmt:formatNumber value="${product.basePrice}" type="number" maxFractionDigits="0" var="formattedBasePrice"/>
<fmt:formatNumber value="${product.basePrice}" type="number" groupingUsed="false" maxFractionDigits="0" var="rawBasePrice"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title><c:out value="${product.name}"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/products.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/product-detail.css">
</head>
<body>
<div class="product-detail-page">
    <div class="site-container">

        <!-- Section 1: Product Image (Left) & Product Info + Size (S, M, L) + Actions (Right) -->
        <section class="detail-main-section" aria-label="Thông tin sản phẩm">
            <div class="detail-grid">
                <!-- Left: Product Image from DB -->
                <div class="detail-image-box">
                    <img class="detail-image"
                         src="<c:out value='${product.imageUrl}'/>"
                         alt="<c:out value='${product.name}'/>">
                    <div class="detail-image-placeholder" aria-hidden="true">
                        <svg viewBox="0 0 24 24" width="48" height="48" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="3" width="18" height="18" rx="3"/>
                            <circle cx="8.5" cy="8.5" r="1.5"/>
                            <path d="m21 15-5-5L5 21"/>
                        </svg>
                        <span>Ảnh sản phẩm</span>
                    </div>
                </div>

                <!-- Right: Name, Price, Size Selection (S, M, L from product_sizes), Add to Cart & Buy Now -->
                <div class="detail-info">
                    <h1 class="detail-name" id="detailProductName"><c:out value="${product.name}"/></h1>
                    <p class="detail-price" id="detailProductPrice" data-base-price="${rawBasePrice}">
                        <c:out value="${formattedBasePrice}"/>đ
                    </p>

                    <div class="detail-size-group">
                        <span class="detail-size-label">Chọn size:</span>
                        <div class="detail-size-boxes" role="radiogroup" aria-label="Chọn kích cỡ đồ uống">
                            <c:forEach var="s" items="${sizes}" varStatus="status">
                                <fmt:formatNumber value="${s.extraPrice}" type="number" groupingUsed="false" maxFractionDigits="0" var="rawExtraPrice"/>
                                <button type="button"
                                        class="size-box ${status.first ? 'is-selected' : ''}"
                                        data-size="<c:out value='${s.sizeName}'/>"
                                        data-extra-price="${rawExtraPrice}"
                                        role="radio"
                                        aria-checked="${status.first ? 'true' : 'false'}">
                                    <c:out value="${s.sizeName}"/>
                                </button>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="detail-branch-group">
                        <span class="detail-branch-label">Chọn chi nhánh:</span>
                        <div class="detail-branch-boxes" role="radiogroup" aria-label="Chọn chi nhánh">
                            <c:forEach var="b" items="${branchOptions}">
                                <c:set var="isBranchSelected" value="${b.available and b.id == firstAvailableBranchId}"/>
                                <button type="button"
                                        class="branch-box ${isBranchSelected ? 'is-selected' : ''} ${not b.available ? 'is-unavailable' : ''}"
                                        data-branch-id="${b.id}"
                                        role="radio"
                                        aria-checked="${isBranchSelected ? 'true' : 'false'}"
                                        ${not b.available ? 'disabled aria-disabled="true"' : ''}>
                                    <c:out value="${b.name}"/>
                                </button>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="detail-actions">
                        <button type="button" class="detail-btn detail-btn--cart" id="addToCartBtn">
                            Thêm vào giỏ
                        </button>
                        <button type="button" class="detail-btn detail-btn--buy" id="buyNowBtn">
                            Mua ngay
                        </button>
                    </div>
                </div>
            </div>
        </section>

        <!-- Section 2: Product Description (from DB) -->
        <section class="detail-description-section" aria-label="Mô tả sản phẩm">
            <h2 class="detail-section-title">Mô tả sản phẩm</h2>
            <div class="detail-description-box">
                <p class="detail-description-text"><c:out value="${product.description}"/></p>
            </div>
        </section>

        <!-- Section 3: Other Products from DB (Total 4 products in 1 row, no pagination) -->
        <section class="detail-related-section" aria-label="Sản phẩm khác">
            <h2 class="detail-section-title">Sản phẩm khác</h2>

            <div class="product-grid detail-related-grid">
                <c:forEach var="rp" items="${relatedProducts}">
                    <fmt:formatNumber value="${rp.basePrice}" type="number" maxFractionDigits="0" var="rpFormattedPrice"/>
                    <jsp:include page="/WEB-INF/views/components/product-card.jsp">
                        <jsp:param name="id" value="${rp.id}"/>
                        <jsp:param name="name" value="${rp.name}"/>
                        <jsp:param name="desc" value="${rp.description}"/>
                        <jsp:param name="price" value="${rpFormattedPrice}đ"/>
                        <jsp:param name="image" value="${rp.imageUrl}"/>
                        <jsp:param name="badge" value="${rp.featured ? 'Bán chạy' : 'Mới'}"/>
                        <jsp:param name="badgeClass" value="${rp.featured ? '' : 'product-badge--new'}"/>
                    </jsp:include>
                </c:forEach>
            </div>
        </section>

    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/product-detail.js"></script>
</body>
</html>
