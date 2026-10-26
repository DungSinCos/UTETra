<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Giỏ hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cart.css">
</head>
<body>
<section class="cart-page">
    <div class="site-container">
        <div class="cart-header">
            <h1 class="cart-title">Giỏ hàng của bạn</h1>
            <p class="cart-subtitle">Kiểm tra lại các món đồ uống trước khi tiến hành đặt hàng</p>
        </div>

        <div class="cart-layout">
            <!-- Section 1 (Left): Products in User Cart -->
            <div class="cart-items-section">
                <div class="cart-section-head">
                    <h2>Sản phẩm đã chọn (<span data-cart-count>3</span>)</h2>
                    <a class="cart-continue-link" href="${pageContext.request.contextPath}/products">+ Thêm món khác</a>
                </div>

                <div class="cart-items-list" id="cartItemsList">
                    <jsp:include page="/WEB-INF/views/components/cart-item.jsp">
                        <jsp:param name="itemId" value="1"/>
                        <jsp:param name="productId" value="101"/>
                        <jsp:param name="name" value="Trà Sữa Trân Châu Đường Đen"/>
                        <jsp:param name="size" value="L"/>
                        <jsp:param name="price" value="45.000đ"/>
                        <jsp:param name="rawPrice" value="45000"/>
                        <jsp:param name="quantity" value="2"/>
                        <jsp:param name="image" value="https://images.unsplash.com/photo-1525385133512-2f3bdd039054?auto=format&fit=crop&w=600&q=80"/>
                    </jsp:include>

                    <jsp:include page="/WEB-INF/views/components/cart-item.jsp">
                        <jsp:param name="itemId" value="2"/>
                        <jsp:param name="productId" value="102"/>
                        <jsp:param name="name" value="Trà Oolong Kem Cheese"/>
                        <jsp:param name="size" value="M"/>
                        <jsp:param name="price" value="49.000đ"/>
                        <jsp:param name="rawPrice" value="49000"/>
                        <jsp:param name="quantity" value="1"/>
                        <jsp:param name="image" value="https://images.unsplash.com/photo-1541696490-8744a5dc0228?auto=format&fit=crop&w=600&q=80"/>
                    </jsp:include>

                    <jsp:include page="/WEB-INF/views/components/cart-item.jsp">
                        <jsp:param name="itemId" value="3"/>
                        <jsp:param name="productId" value="103"/>
                        <jsp:param name="name" value="Matcha Latte Đậu Đỏ"/>
                        <jsp:param name="size" value="S"/>
                        <jsp:param name="price" value="52.000đ"/>
                        <jsp:param name="rawPrice" value="52000"/>
                        <jsp:param name="quantity" value="1"/>
                        <jsp:param name="image" value="https://images.unsplash.com/photo-1515823064-d6e0c04616a7?auto=format&fit=crop&w=600&q=80"/>
                    </jsp:include>
                </div>

                <!-- Empty cart state (shown when all items are removed) -->
                <div class="cart-empty" id="cartEmptyState" hidden>
                    <p>Giỏ hàng của bạn đang trống.</p>
                    <a class="cart-browse-btn" href="${pageContext.request.contextPath}/products">Khám phá thực đơn</a>
                </div>
            </div>

            <!-- Section 2 (Right): Order Summary -->
            <aside class="order-summary">
                <h2 class="summary-title">Order Summary</h2>

                <div class="summary-rows">
                    <div class="summary-row">
                        <span class="summary-label">Tạm tính (Subtotal)</span>
                        <span class="summary-value" data-summary-subtotal>191.000đ</span>
                    </div>
                    <div class="summary-row">
                        <span class="summary-label">Phí giao hàng (Delivery Fee)</span>
                        <span class="summary-value" data-summary-delivery data-delivery-fee="15000">15.000đ</span>
                    </div>
                </div>

                <div class="summary-divider"></div>

                <div class="summary-total">
                    <span class="summary-total-label">Tổng cộng (Total)</span>
                    <span class="summary-total-value" data-summary-total>206.000đ</span>
                </div>

                <!-- Voucher input under Total Price -->
                <div class="summary-voucher">
                    <label for="voucherInput" class="voucher-label">Mã giảm giá (Voucher)</label>
                    <div class="voucher-input-group">
                        <input type="text"
                               id="voucherInput"
                               name="voucherCode"
                               class="voucher-input"
                               placeholder="Nhập mã giảm giá...">
                        <button type="button" class="voucher-apply-btn" data-voucher-apply>Áp dụng</button>
                    </div>
                </div>

                <!-- Checkout button -->
                <a href="${pageContext.request.contextPath}/checkout" class="checkout-btn" data-checkout-btn>
                    Tiến hành thanh toán
                </a>
            </aside>
        </div>
    </div>
</section>

<script src="${pageContext.request.contextPath}/assets/js/cart.js"></script>
</body>
</html>
