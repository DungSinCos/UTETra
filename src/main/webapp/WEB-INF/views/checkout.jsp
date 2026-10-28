<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN"/>
<fmt:formatNumber value="${subtotal != null ? subtotal : 0}" type="number" maxFractionDigits="0" var="formattedSubtotal"/>
<fmt:formatNumber value="${deliveryFee != null ? deliveryFee : 0}" type="number" maxFractionDigits="0" var="formattedDeliveryFee"/>
<fmt:formatNumber value="${voucherDiscount != null ? voucherDiscount : 0}" type="number" maxFractionDigits="0" var="formattedVoucherDiscount"/>
<fmt:formatNumber value="${total != null ? total : 0}" type="number" maxFractionDigits="0" var="formattedTotal"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Thanh toán đơn hàng - UTETra</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/checkout.css">
</head>
<body>
<section class="checkout-page" data-context-path="${pageContext.request.contextPath}">
    <div class="site-container">
        <div class="checkout-header">
            <a class="checkout-back-link" href="${pageContext.request.contextPath}/cart">&larr; Quay lại giỏ hàng</a>
            <h1 class="checkout-title">Thanh toán đơn hàng</h1>
            <p class="checkout-subtitle">Kiểm tra địa chỉ nhận hàng, chọn phương thức thanh toán và hoàn tất đặt món</p>
        </div>

        <c:choose>
            <c:when test="${empty checkoutItems}">
                <div class="checkout-empty-card">
                    <h2>Chưa có sản phẩm nào để thanh toán</h2>
                    <p>Hãy chọn món đồ uống yêu thích từ thực đơn hoặc kiểm tra lại giỏ hàng của bạn.</p>
                    <a class="checkout-browse-btn" href="${pageContext.request.contextPath}/products">Khám phá thực đơn</a>
                </div>
            </c:when>
            <c:otherwise>
                <form id="checkoutForm" class="checkout-layout" novalidate>
                    <input type="hidden" name="checkoutMode" value="<c:out value='${checkoutMode}'/>">
                    <input type="hidden" name="voucherCode" value="<c:out value='${voucherCode}'/>">
                    <input type="hidden" name="directProductId" value="<c:out value='${directProductId}'/>">
                    <input type="hidden" name="directSize" value="<c:out value='${directSize}'/>">
                    <input type="hidden" name="directQuantity" value="<c:out value='${directQuantity}'/>">
                    <input type="hidden" name="branchId" value="<c:out value='${selectedBranchId}'/>">
                    <input type="hidden" name="addressId" id="selectedAddressId" value="<c:out value='${currentAddress != null ? currentAddress.id : ""}'/>">

                    <!-- Left Column: Delivery Address & Payment Methods -->
                    <div class="checkout-main">

                        <!-- 1. Delivery Address Section -->
                        <div class="checkout-card">
                            <div class="checkout-card__head">
                                <span class="checkout-step-badge">1</span>
                                <div>
                                    <h2 class="checkout-card__title">Địa chỉ nhận hàng</h2>
                                    <p class="checkout-card__desc">
                                        <c:choose>
                                            <c:when test="${isLoggedIn and hasSavedAddress}">
                                                Sử dụng địa chỉ hiện tại của bạn hoặc nhập địa chỉ giao hàng mới
                                            </c:when>
                                            <c:when test="${isLoggedIn and not hasSavedAddress}">
                                                Tài khoản của bạn chưa có địa chỉ lưu sẵn &mdash; vui lòng nhập địa chỉ giao hàng bên dưới
                                            </c:when>
                                            <c:otherwise>
                                                Bạn đang đặt hàng nhanh chưa đăng nhập &mdash; vui lòng nhập thông tin và địa chỉ nhận hàng
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>

                            <!-- Current Saved Address Card -->
                            <c:if test="${isLoggedIn and hasSavedAddress}">
                                <div class="saved-address-box" id="savedAddressBox">
                                    <div class="saved-address-box__info">
                                        <div class="saved-address-box__top">
                                            <strong class="saved-address-box__name"><c:out value="${currentAddress.recipientName}"/></strong>
                                            <span class="saved-address-box__phone"><c:out value="${currentAddress.recipientPhone}"/></span>
                                            <span class="saved-address-box__tag">Địa chỉ hiện tại</span>
                                        </div>
                                        <p class="saved-address-box__line"><c:out value="${currentAddress.fullAddress}"/></p>
                                    </div>
                                    <button type="button" class="saved-address-box__change" id="toggleCustomAddressBtn">
                                        Đổi địa chỉ khác
                                    </button>
                                </div>
                            </c:if>

                            <!-- Address Input Form -->
                            <div class="address-form-wrap" id="addressFormWrap" ${isLoggedIn and hasSavedAddress ? 'hidden' : ''}>
                                <div class="checkout-form-grid">
                                    <div class="checkout-field">
                                        <label for="recipientName">Họ và tên người nhận <span>*</span></label>
                                        <input type="text"
                                               id="recipientName"
                                               name="recipientName"
                                               value="<c:out value='${defaultRecipientName}'/>"
                                               placeholder="Nguyễn Văn A"
                                               required>
                                    </div>
                                    <div class="checkout-field">
                                        <label for="recipientPhone">Số điện thoại <span>*</span></label>
                                        <input type="tel"
                                               id="recipientPhone"
                                               name="recipientPhone"
                                               value="<c:out value='${defaultRecipientPhone}'/>"
                                               placeholder="0901234567"
                                               required>
                                    </div>
                                    <div class="checkout-field checkout-field--full">
                                        <label for="addressLine">Số nhà, tên đường <span>*</span></label>
                                        <input type="text"
                                               id="addressLine"
                                               name="addressLine"
                                               placeholder="Ví dụ: 01 Võ Văn Ngân"
                                               required>
                                    </div>
                                    <div class="checkout-field">
                                        <label for="ward">Phường / Xã</label>
                                        <input type="text"
                                               id="ward"
                                               name="ward"
                                               placeholder="Phường Linh Chiểu">
                                    </div>
                                    <div class="checkout-field">
                                        <label for="district">Quận / Huyện / TP <span>*</span></label>
                                        <input type="text"
                                               id="district"
                                               name="district"
                                               placeholder="TP. Thủ Đức"
                                               required>
                                    </div>
                                    <div class="checkout-field checkout-field--full">
                                        <label for="city">Tỉnh / Thành phố <span>*</span></label>
                                        <input type="text"
                                               id="city"
                                               name="city"
                                               value="TP. Hồ Chí Minh"
                                               placeholder="TP. Hồ Chí Minh"
                                               required>
                                    </div>
                                </div>
                            </div>

                            <div class="checkout-field checkout-field--note">
                                <label for="orderNote">Ghi chú cho cửa hàng / tài xế</label>
                                <input type="text"
                                       id="orderNote"
                                       name="note"
                                       placeholder="Ví dụ: Giao giờ hành chính, gọi trước khi đến...">
                            </div>
                        </div>

                        <!-- 2. Payment Method Section -->
                        <div class="checkout-card">
                            <div class="checkout-card__head">
                                <span class="checkout-step-badge">2</span>
                                <div>
                                    <h2 class="checkout-card__title">Phương thức thanh toán</h2>
                                    <p class="checkout-card__desc">Chọn hình thức thanh toán phù hợp với bạn</p>
                                </div>
                            </div>

                            <div class="payment-methods" role="radiogroup" aria-label="Phương thức thanh toán">
                                <!-- Option 1: Cash (COD) -->
                                <label class="payment-option is-selected" data-payment-card="CASH">
                                    <input type="radio" name="paymentMethod" value="CASH" checked>
                                    <span class="payment-option__icon payment-option__icon--cash" aria-hidden="true">&#8363;</span>
                                    <span class="payment-option__body">
                                        <strong class="payment-option__name">Tiền mặt khi nhận hàng (COD)</strong>
                                        <span class="payment-option__sub">Thanh toán tiền mặt cho shipper khi nhận được trà sữa</span>
                                    </span>
                                    <span class="payment-option__check" aria-hidden="true"></span>
                                </label>

                                <!-- Option 2: VNPay -->
                                <label class="payment-option" data-payment-card="VNPAY">
                                    <input type="radio" name="paymentMethod" value="VNPAY">
                                    <span class="payment-option__icon" style="background:#005baa;color:#fff;font-weight:700;font-size:0.75rem;" aria-hidden="true">VNPAY</span>
                                    <span class="payment-option__body">
                                        <strong class="payment-option__name">Cổng thanh toán VNPay</strong>
                                        <span class="payment-option__sub">Thanh toán qua VNPAY-QR, Thẻ ATM nội địa hoặc thẻ Quốc tế</span>
                                    </span>
                                    <span class="payment-option__check" aria-hidden="true"></span>
                                </label>

                                <!-- Option 3: VietQR / Bank Transfer -->
                                <label class="payment-option" data-payment-card="BANK_TRANSFER">
                                    <input type="radio" name="paymentMethod" value="BANK_TRANSFER">
                                    <span class="payment-option__icon" style="background:#e8f4fd;color:#007bff;font-size:1.1rem;" aria-hidden="true">&#x25A3;</span>
                                    <span class="payment-option__body">
                                        <strong class="payment-option__name">Chuyển khoản ngân hàng (VietQR)</strong>
                                        <span class="payment-option__sub">Quét mã QR qua mọi ứng dụng ngân hàng (Mobile Banking)</span>
                                    </span>
                                    <span class="payment-option__check" aria-hidden="true"></span>
                                </label>
                            </div>

                            <!-- Cash Info Box -->
                            <div class="payment-skeleton-box" id="cashSkeletonBox">
                                <p class="payment-skeleton-box__text">
                                    Bạn sẽ thanh toán tổng số tiền <strong><c:out value="${formattedTotal}"/>đ</strong> bằng tiền mặt cho nhân viên giao hàng khi nhận đơn.
                                </p>
                            </div>

                            <!-- VNPay Info Box -->
                            <div class="payment-skeleton-box" id="vnpayBox" hidden>
                                <p class="payment-skeleton-box__text">
                                    Hệ thống sẽ chuyển hướng an toàn sang <strong>Cổng thanh toán VNPAY</strong> để bạn quét mã QR Pay hoặc nhập thẻ ngân hàng.
                                </p>
                            </div>

                            <!-- Bank Transfer Info Box -->
                            <div class="payment-skeleton-box" id="bankTransferBox" hidden>
                                <p class="payment-skeleton-box__text">
                                    Sau khi bấm đặt hàng, hệ thống sẽ tạo mã đơn và hiển thị <strong>mã VietQR động</strong> cùng thông tin tài khoản để bạn chuyển khoản.
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Right Column: Order Summary & Total Calculation + Pay Button -->
                    <aside class="checkout-summary">
                        <div class="checkout-summary__head">
                            <h2 class="checkout-summary__title">Đơn hàng của bạn</h2>
                            <span class="checkout-summary__badge"><c:out value="${totalQuantity}"/> món</span>
                        </div>

                        <div class="checkout-items-list">
                            <c:forEach var="item" items="${checkoutItems}">
                                <fmt:formatNumber value="${item.lineTotal}" type="number" maxFractionDigits="0" var="formattedLineTotal"/>
                                <div class="checkout-item">
                                    <div class="checkout-item__thumb">
                                        <img src="<c:out value='${item.imageUrl}'/>" alt="<c:out value='${item.name}'/>">
                                    </div>
                                    <div class="checkout-item__info">
                                        <h3 class="checkout-item__name"><c:out value="${item.name}"/></h3>
                                        <span class="checkout-item__meta">Size: <strong><c:out value="${item.sizeName}"/></strong> &bull; SL: <strong>x<c:out value="${item.quantity}"/></strong></span>
                                    </div>
                                    <div class="checkout-item__price">
                                        <c:out value="${formattedLineTotal}"/>đ
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <div class="checkout-summary__divider"></div>

                        <div class="checkout-summary__rows">
                            <div class="checkout-summary__row">
                                <span>Tạm tính (<c:out value="${totalQuantity}"/> món)</span>
                                <strong data-checkout-subtotal><c:out value="${formattedSubtotal}"/>đ</strong>
                            </div>
                            <div class="checkout-summary__row">
                                <span>Phí giao hàng</span>
                                <strong data-checkout-delivery><c:out value="${formattedDeliveryFee}"/>đ</strong>
                            </div>
                            <c:if test="${not empty voucherCode}">
                                <div class="checkout-summary__row">
                                    <span>Mã <c:out value="${voucherCode}"/></span>
                                    <strong style="color:#16804a;">-<c:out value="${formattedVoucherDiscount}"/>đ</strong>
                                </div>
                            </c:if>
                            <div class="checkout-summary__row">
                                <span>Phương thức</span>
                                <strong id="summaryPaymentLabel">Tiền mặt (COD)</strong>
                            </div>
                        </div>

                        <div class="checkout-summary__divider"></div>

                        <div class="checkout-summary__total">
                            <span>Tổng thanh toán</span>
                            <strong class="checkout-summary__total-val" data-checkout-total><c:out value="${formattedTotal}"/>đ</strong>
                        </div>

                        <div class="checkout-error-msg" id="checkoutErrorMsg" ${empty voucherError ? 'hidden' : ''}><c:out value="${voucherError}"/></div>

                        <button type="submit" class="checkout-pay-btn" id="payOrderBtn">
                            Đặt hàng ngay (<c:out value="${formattedTotal}"/>đ)
                        </button>
                    </aside>
                </form>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<!-- Order Confirmation Modal -->
<div class="checkout-success-backdrop" id="checkoutSuccessModal" hidden>
    <div class="checkout-success-dialog" role="dialog" aria-modal="true" aria-labelledby="checkoutSuccessTitle">
        <div class="checkout-success-icon">&#10003;</div>
        <h2 class="checkout-success-title" id="checkoutSuccessTitle">Đặt hàng thành công!</h2>
        <p class="checkout-success-desc">
            Cảm ơn bạn đã đặt thức uống tại UTETra. Đơn hàng của bạn đã được ghi nhận.
        </p>
        <div class="checkout-success-meta">
            <div><span>Mã đơn hàng:</span> <strong id="successOrderCode">---</strong></div>
            <div><span>Phương thức:</span> <strong id="successPaymentMethod">---</strong></div>
            <div><span>Tổng thanh toán:</span> <strong id="successOrderTotal">---</strong></div>
        </div>
        <div class="checkout-success-actions">
            <a class="checkout-success-btn checkout-success-btn--primary" id="successViewInvoiceBtn" href="#">
                Xem hóa đơn & Theo dõi đơn hàng
            </a>
            <c:if test="${isLoggedIn}">
                <a class="checkout-success-btn checkout-success-btn--outline" href="${pageContext.request.contextPath}/account/orders">
                    Lịch sử đơn hàng
                </a>
            </c:if>
            <a class="checkout-success-btn checkout-success-btn--outline" href="${pageContext.request.contextPath}/products">
                Tiếp tục mua sắm
            </a>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/checkout.js"></script>
</body>
</html>
