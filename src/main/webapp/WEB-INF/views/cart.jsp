<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN"/>
<fmt:formatNumber value="${subtotal != null ? subtotal : 0}" type="number" maxFractionDigits="0" var="formattedSubtotal"/>
<fmt:formatNumber value="${deliveryFee != null ? deliveryFee : 0}" type="number" maxFractionDigits="0" var="formattedDeliveryFee"/>
<fmt:formatNumber value="${total != null ? total : 0}" type="number" maxFractionDigits="0" var="formattedTotal"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Giỏ hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cart.css">
</head>
<body>
<section class="cart-page" data-context-path="${pageContext.request.contextPath}">
    <div class="site-container">
        <div class="cart-header">
            <h1 class="cart-title">Giỏ hàng của bạn</h1>
            <p class="cart-subtitle">Kiểm tra lại các món đồ uống trước khi tiến hành đặt hàng</p>
        </div>

        <div class="cart-layout">
            <!-- Section 1 (Left): Products in User Cart (tables: carts, cart_items) -->
            <div class="cart-items-section">
                <div class="cart-section-head">
                    <h2>Sản phẩm đã chọn (<span data-cart-count>${not empty cartItems ? cartItems.size() : 0}</span>)</h2>
                    <a class="cart-continue-link" href="${pageContext.request.contextPath}/products">+ Thêm món khác</a>
                </div>

                <div class="cart-items-list" id="cartItemsList" ${empty cartItems ? 'hidden' : ''}>
                    <c:forEach var="item" items="${cartItems}">
                        <fmt:formatNumber value="${item.unitPrice}" type="number" maxFractionDigits="0" var="formattedUnitPrice"/>
                        <fmt:formatNumber value="${item.unitPrice}" type="number" groupingUsed="false" maxFractionDigits="0" var="rawUnitPrice"/>
                        <jsp:include page="/WEB-INF/views/components/cart-item.jsp">
                            <jsp:param name="itemId" value="${item.itemId}"/>
                            <jsp:param name="productId" value="${item.productId}"/>
                            <jsp:param name="name" value="${item.name}"/>
                            <jsp:param name="size" value="${item.sizeName}"/>
                            <jsp:param name="price" value="${formattedUnitPrice}đ"/>
                            <jsp:param name="rawPrice" value="${rawUnitPrice}"/>
                            <jsp:param name="quantity" value="${item.quantity}"/>
                            <jsp:param name="image" value="${item.imageUrl}"/>
                        </jsp:include>
                    </c:forEach>
                </div>

                <!-- Empty cart state (shown when cart has no items in DB) -->
                <div class="cart-empty" id="cartEmptyState" ${not empty cartItems ? 'hidden' : ''}>
                    <c:choose>
                        <c:when test="${isGuest}">
                            <p>Vui lòng đăng nhập để xem và quản lý giỏ hàng của bạn.</p>
                            <a class="cart-browse-btn" href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a>
                        </c:when>
                        <c:otherwise>
                            <p>Giỏ hàng của bạn đang trống.</p>
                            <a class="cart-browse-btn" href="${pageContext.request.contextPath}/products">Khám phá thực đơn</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Section 2 (Right): Order Summary -->
            <aside class="order-summary">
                <h2 class="summary-title">Order Summary</h2>

                <div class="summary-rows">
                    <div class="summary-row">
                        <span class="summary-label">Tạm tính (Subtotal)</span>
                        <span class="summary-value" data-summary-subtotal><c:out value="${formattedSubtotal}"/>đ</span>
                    </div>
                    <div class="summary-row">
                        <span class="summary-label">Phí giao hàng (Delivery Fee)</span>
                        <span class="summary-value" data-summary-delivery data-delivery-fee="15000"><c:out value="${formattedDeliveryFee}"/>đ</span>
                    </div>
                    <div class="summary-row" data-voucher-discount-row ${empty voucherCode ? 'hidden' : ''}>
                        <span class="summary-label">Giảm giá (<c:out value="${voucherCode}"/>)</span>
                        <span class="summary-value" data-summary-discount>-<fmt:formatNumber value="${voucherDiscount}" type="number" maxFractionDigits="0"/>đ</span>
                    </div>
                </div>

                <div class="summary-divider"></div>

                <div class="summary-total">
                    <span class="summary-total-label">Tổng cộng (Total)</span>
                    <span class="summary-total-value" data-summary-total><c:out value="${formattedTotal}"/>đ</span>
                </div>

                <!-- Voucher input under Total Price -->
                <div class="summary-voucher">
                    <label for="voucherInput" class="voucher-label">Mã giảm giá (Voucher)</label>
                    <div class="voucher-input-group">
                        <input type="text"
                               id="voucherInput"
                               name="voucherCode"
                               class="voucher-input"
                               value="<c:out value='${voucherCode}'/>"
                               placeholder="Nhập mã giảm giá...">
                        <button type="button" class="voucher-apply-btn" data-voucher-apply>Áp dụng</button>
                    </div>
                    <p class="voucher-feedback" data-voucher-feedback aria-live="polite"><c:out value="${voucherMessage}"/></p>
                </div>

                <!-- Checkout button mapped to /checkout -->
                <a href="${pageContext.request.contextPath}/checkout"
                   class="checkout-btn ${empty cartItems ? 'is-disabled' : ''}"
                   data-checkout-btn
                   aria-disabled="${empty cartItems ? 'true' : 'false'}">
                    Tiến hành thanh toán
                </a>
            </aside>
        </div>
    </div>
</section>

<script src="${pageContext.request.contextPath}/assets/js/cart.js"></script>
</body>
</html>
