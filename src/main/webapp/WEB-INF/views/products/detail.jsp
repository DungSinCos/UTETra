<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- Resolve mocked product data by productId (1..5) --%>
<c:choose>
    <c:when test="${productId == 2}">
        <c:set var="pName" value="Trà Oolong Kem Cheese"/>
        <c:set var="pPrice" value="49.000đ"/>
        <c:set var="pBasePrice" value="49000"/>
        <c:set var="pDesc" value="Oolong rang thơm nồng phủ lớp kem cheese mặn mịn béo. Lá trà Oolong cao nguyên được ủ ở nhiệt độ chuẩn, giữ trọn hậu vị ngọt thanh tự nhiên kết hợp lớp kem phô mai đánh bông mịn màng mỗi ngày."/>
    </c:when>
    <c:when test="${productId == 3}">
        <c:set var="pName" value="Matcha Latte Đậu Đỏ"/>
        <c:set var="pPrice" value="52.000đ"/>
        <c:set var="pBasePrice" value="52000"/>
        <c:set var="pDesc" value="Matcha Uji Nhật Bản kết hợp đậu đỏ ninh mềm ngọt dịu. Bột trà xanh nguyên chất đánh tan cùng sữa tươi thanh trùng mát lạnh và hạt đậu đỏ bùi thơm nấu thủ công."/>
    </c:when>
    <c:when test="${productId == 4}">
        <c:set var="pName" value="Trà Đào Cam Sả"/>
        <c:set var="pPrice" value="42.000đ"/>
        <c:set var="pBasePrice" value="42000"/>
        <c:set var="pDesc" value="Trà đen thanh mát cùng đào miếng giòn ngọt, cam vàng tươi mọng nước và hương sả thơm dịu, mang lại cảm giác sảng khoái tức thì cho ngày dài năng động."/>
    </c:when>
    <c:when test="${productId == 5}">
        <c:set var="pName" value="Trà Sữa Oolong Kem Cheese"/>
        <c:set var="pPrice" value="55.000đ"/>
        <c:set var="pBasePrice" value="55000"/>
        <c:set var="pDesc" value="Lá trà nguyên chất, sữa tươi thanh trùng cùng trân châu nấu thủ công mỗi sáng. Sự giao thoa hoàn hảo giữa vị trà sữa Oolong đậm đà và lớp kem cheese béo mặn đặc trưng của UTETra."/>
    </c:when>
    <c:otherwise>
        <c:set var="pName" value="Trà Sữa Trân Châu Đường Đen"/>
        <c:set var="pPrice" value="45.000đ"/>
        <c:set var="pBasePrice" value="45000"/>
        <c:set var="pDesc" value="Sữa tươi béo ngậy hòa quyện cùng trân châu đường đen dẻo thơm. Trân châu được ninh kỹ cùng đường đen Hàn Quốc tạo độ bóng mượt, ấm nóng quyện cùng sữa tươi mát lạnh."/>
    </c:otherwise>
</c:choose>

<%--
    Chèn đường dẫn hình ảnh sản phẩm tại đây (hiện tại để trống "" theo yêu cầu):
--%>
<c:set var="detailProductImage" value="" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <title><c:out value="${pName}"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/products.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/product-detail.css">
</head>
<body>
<div class="product-detail-page">
    <div class="site-container">

        <!-- Section 1: Product Image (Left) & Product Info + Size (S, M, L) + Actions (Right) -->
        <section class="detail-main-section" aria-label="Thông tin sản phẩm">
            <div class="detail-grid">
                <!-- Left: Blank Product Image Box -->
                <div class="detail-image-box">
                    <img class="detail-image"
                         src="<c:out value='${detailProductImage}'/>"
                         alt="<c:out value='${pName}'/>">
                    <div class="detail-image-placeholder" aria-hidden="true">
                        <svg viewBox="0 0 24 24" width="48" height="48" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="3" width="18" height="18" rx="3"/>
                            <circle cx="8.5" cy="8.5" r="1.5"/>
                            <path d="m21 15-5-5L5 21"/>
                        </svg>
                        <span>Ảnh sản phẩm</span>
                    </div>
                </div>

                <!-- Right: Name, Price, Size Selection (S, M, L), Add to Cart & Buy Now -->
                <div class="detail-info">
                    <h1 class="detail-name" id="detailProductName"><c:out value="${pName}"/></h1>
                    <p class="detail-price" id="detailProductPrice" data-base-price="${pBasePrice}"><c:out value="${pPrice}"/></p>

                    <div class="detail-size-group">
                        <span class="detail-size-label">Chọn size:</span>
                        <div class="detail-size-boxes" role="radiogroup" aria-label="Chọn kích cỡ đồ uống">
                            <button type="button"
                                    class="size-box is-selected"
                                    data-size="S"
                                    data-extra-price="0"
                                    role="radio"
                                    aria-checked="true">
                                S
                            </button>
                            <button type="button"
                                    class="size-box"
                                    data-size="M"
                                    data-extra-price="5000"
                                    role="radio"
                                    aria-checked="false">
                                M
                            </button>
                            <button type="button"
                                    class="size-box"
                                    data-size="L"
                                    data-extra-price="10000"
                                    role="radio"
                                    aria-checked="false">
                                L
                            </button>
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

        <!-- Section 2: Product Description -->
        <section class="detail-description-section" aria-label="Mô tả sản phẩm">
            <h2 class="detail-section-title">Mô tả sản phẩm</h2>
            <div class="detail-description-box">
                <p class="detail-description-text"><c:out value="${pDesc}"/></p>
            </div>
        </section>

        <!-- Section 3: Other Products (Total 4 products in 1 row, no pagination) -->
        <section class="detail-related-section" aria-label="Sản phẩm khác">
            <h2 class="detail-section-title">Sản phẩm khác</h2>

            <div class="product-grid detail-related-grid">
                <c:if test="${productId != 1}">
                    <jsp:include page="/WEB-INF/views/components/product-card.jsp">
                        <jsp:param name="id" value="1"/>
                        <jsp:param name="name" value="Trà Sữa Trân Châu Đường Đen"/>
                        <jsp:param name="desc" value="Sữa tươi béo ngậy hòa quyện cùng trân châu đường đen dẻo thơm."/>
                        <jsp:param name="price" value="45.000đ"/>
                        <jsp:param name="image" value="https://images.unsplash.com/photo-1525385133512-2f3bdd039054?auto=format&fit=crop&w=600&q=80"/>
                        <jsp:param name="badge" value="Bán chạy"/>
                        <jsp:param name="category" value="tra-sua"/>
                    </jsp:include>
                </c:if>

                <c:if test="${productId != 2}">
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
                </c:if>

                <c:if test="${productId != 3}">
                    <jsp:include page="/WEB-INF/views/components/product-card.jsp">
                        <jsp:param name="id" value="3"/>
                        <jsp:param name="name" value="Matcha Latte Đậu Đỏ"/>
                        <jsp:param name="desc" value="Matcha Uji Nhật Bản kết hợp đậu đỏ ninh mềm ngọt dịu."/>
                        <jsp:param name="price" value="52.000đ"/>
                        <jsp:param name="image" value="https://images.unsplash.com/photo-1515823064-d6e0c04616a7?auto=format&fit=crop&w=600&q=80"/>
                        <jsp:param name="category" value="matcha-latte"/>
                    </jsp:include>
                </c:if>

                <c:if test="${productId != 4}">
                    <jsp:include page="/WEB-INF/views/components/product-card.jsp">
                        <jsp:param name="id" value="4"/>
                        <jsp:param name="name" value="Trà Đào Cam Sả"/>
                        <jsp:param name="desc" value="Trà đen thanh mát cùng đào miếng, cam tươi và sả thơm."/>
                        <jsp:param name="price" value="42.000đ"/>
                        <jsp:param name="image" value="https://images.unsplash.com/photo-1556679343-c7306c1976bc?auto=format&fit=crop&w=600&q=80"/>
                        <jsp:param name="badge" value="Bán chạy"/>
                        <jsp:param name="category" value="tra-trai-cay"/>
                    </jsp:include>
                </c:if>

                <c:if test="${productId == 1 or productId == 2 or productId == 3 or productId == 4}">
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
                </c:if>
            </div>
        </section>

    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/product-detail.js"></script>
</body>
</html>
