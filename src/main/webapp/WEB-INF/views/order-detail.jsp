<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN"/>
<fmt:formatNumber value="${order.subtotalAmount}" type="number" maxFractionDigits="0" var="formattedSubtotal"/>
<fmt:formatNumber value="${order.shippingFee}" type="number" maxFractionDigits="0" var="formattedShippingFee"/>
<fmt:formatNumber value="${order.discountAmount}" type="number" maxFractionDigits="0" var="formattedDiscount"/>
<fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0" var="formattedTotal"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Hóa đơn & Theo dõi đơn hàng #${order.orderCode} - UTETra</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order.css">
</head>
<body>
<section class="order-page">
    <div class="site-container">

        <!-- Flash alerts -->
        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show" role="alert" style="background:#dcfce7;color:#15803d;padding:1rem 1.25rem;border-radius:12px;margin-bottom:1.5rem;font-weight:600;">
                &#10003; <c:out value="${message}"/>
            </div>
        </c:if>
        <c:if test="${not empty paymentSuccessMsg}">
            <div class="alert alert-success alert-dismissible fade show" role="alert" style="background:#dcfce7;color:#15803d;padding:1rem 1.25rem;border-radius:12px;margin-bottom:1.5rem;font-weight:600;">
                &#10003; <c:out value="${paymentSuccessMsg}"/>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert" style="background:#fee2e2;color:#b91c1c;padding:1rem 1.25rem;border-radius:12px;margin-bottom:1.5rem;font-weight:600;">
                &#9888; <c:out value="${error}"/>
            </div>
        </c:if>
        <c:if test="${not empty paymentErrorMsg}">
            <div class="alert alert-danger" role="alert" style="background:#fee2e2;color:#b91c1c;padding:1rem 1.25rem;border-radius:12px;margin-bottom:1.5rem;font-weight:600;">
                &#9888; <c:out value="${paymentErrorMsg}"/>
            </div>
        </c:if>

        <!-- Order Header -->
        <div class="order-header">
            <div>
                <c:choose>
                    <c:when test="${not empty currentUser}">
                        <a class="back-link" href="${pageContext.request.contextPath}/account/orders" style="color:var(--ut-muted, #7d6a5d);text-decoration:none;font-size:0.9rem;font-weight:600;">&larr; Quản lý đơn hàng</a>
                    </c:when>
                    <c:otherwise>
                        <a class="back-link" href="${pageContext.request.contextPath}/" style="color:var(--ut-muted, #7d6a5d);text-decoration:none;font-size:0.9rem;font-weight:600;">&larr; Về trang chủ</a>
                    </c:otherwise>
                </c:choose>
                <h1 class="order-header__title">Chi tiết đơn hàng #${order.orderCode}</h1>
                <div class="order-header__meta">
                    Thời gian đặt: <strong><c:out value="${order.createdAt}"/></strong> &bull; Loại đơn: <strong><c:out value="${order.orderType.label}"/></strong>
                </div>
            </div>

            <div class="order-actions">
                <button type="button" class="order-btn order-btn--outline" onclick="window.print()">
                    In hóa đơn
                </button>

                <c:if test="${canConfirmReceived}">
                    <form method="post" action="${pageContext.request.contextPath}/orders/${order.orderCode}/confirm-received" style="display:inline;" onsubmit="return confirm('Bạn đã nhận được trà sữa và muốn xác nhận hoàn tất đơn hàng?');">
                        <input type="hidden" name="phone" value="<c:out value='${order.recipientPhone}'/>">
                        <button type="submit" class="order-btn order-btn--primary">
                            &#10003; Đã nhận được hàng
                        </button>
                    </form>
                </c:if>

                <c:if test="${canCancel}">
                    <form method="post" action="${pageContext.request.contextPath}/orders/${order.orderCode}/cancel" style="display:inline;" onsubmit="return confirm('Bạn có chắc chắn muốn hủy đơn hàng này không?');">
                        <input type="hidden" name="phone" value="<c:out value='${order.recipientPhone}'/>">
                        <button type="submit" class="order-btn order-btn--danger">
                            &times; Hủy đơn hàng
                        </button>
                    </form>
                </c:if>
            </div>
        </div>

        <!-- Order Tracking Stepper (NO truck icon, clean text only) -->
        <div class="order-stepper-card">
            <h2 class="stepper-title">Tình trạng nhận hàng</h2>

            <c:choose>
                <c:when test="${order.orderStatus.name() == 'CANCELLED'}">
                    <div class="stepper-cancelled-alert">
                        &#9888; Đơn hàng này đã bị hủy. Nếu có bất kỳ thắc mắc nào, vui lòng liên hệ hotline cửa hàng để được hỗ trợ.
                    </div>
                </c:when>
                <c:otherwise>
                    <c:set var="status" value="${order.orderStatus.name()}"/>
                    <ul class="stepper">
                        <!-- Step 1: PENDING -->
                        <li class="stepper-step ${status == 'PENDING' ? 'is-active' : 'is-completed'}">
                            <span class="stepper-step__circle">&#10003;</span>
                            <span class="stepper-step__label">Đã đặt hàng</span>
                            <span class="stepper-step__sub">Chờ xác nhận</span>
                        </li>

                        <!-- Step 2: CONFIRMED -->
                        <li class="stepper-step ${status == 'CONFIRMED' ? 'is-active' : (status == 'PREPARING' || status == 'SHIPPING' || status == 'COMPLETED' ? 'is-completed' : '')}">
                            <span class="stepper-step__circle">2</span>
                            <span class="stepper-step__label">Đã xác nhận</span>
                            <span class="stepper-step__sub">Quán tiếp nhận</span>
                        </li>

                        <!-- Step 3: PREPARING -->
                        <li class="stepper-step ${status == 'PREPARING' ? 'is-active' : (status == 'SHIPPING' || status == 'COMPLETED' ? 'is-completed' : '')}">
                            <span class="stepper-step__circle">3</span>
                            <span class="stepper-step__label">Đang pha chế</span>
                            <span class="stepper-step__sub">Barista chuẩn bị</span>
                        </li>

                        <!-- Step 4: SHIPPING -->
                        <li class="stepper-step ${status == 'SHIPPING' ? 'is-active' : (status == 'COMPLETED' ? 'is-completed' : '')}">
                            <span class="stepper-step__circle">4</span>
                            <span class="stepper-step__label">Đang giao hàng</span>
                            <span class="stepper-step__sub">Shipper đang tới</span>
                        </li>

                        <!-- Step 5: COMPLETED -->
                        <li class="stepper-step ${status == 'COMPLETED' ? 'is-completed is-active' : ''}">
                            <span class="stepper-step__circle">5</span>
                            <span class="stepper-step__label">Giao thành công</span>
                            <span class="stepper-step__sub">Đã hoàn tất</span>
                        </li>
                    </ul>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- VietQR Box if Bank Transfer & Unpaid -->
        <c:if test="${isBankTransferPending}">
            <div class="vietqr-card">
                <div class="vietqr-card__qr">
                    <img src="${vietQrUrl}" alt="Mã VietQR thanh toán đơn hàng #${order.orderCode}">
                    <p style="font-size:0.82rem;color:var(--ut-muted, #7d6a5d);margin-top:0.4rem;font-weight:600;">Quét bằng app ngân hàng</p>
                </div>
                <div class="vietqr-card__info">
                    <h3 class="vietqr-card__title">Thông tin chuyển khoản thanh toán (VietQR)</h3>
                    <p style="color:var(--ut-muted, #7d6a5d);margin-bottom:0.75rem;font-size:0.95rem;">
                        Vui lòng mở ứng dụng ngân hàng bất kỳ, quét mã QR bên cạnh hoặc chuyển khoản theo đúng thông tin dưới đây:
                    </p>
                    <table class="vietqr-table">
                        <tr>
                            <td>Ngân hàng:</td>
                            <td><c:out value="${bankId}"/></td>
                        </tr>
                        <tr>
                            <td>Số tài khoản:</td>
                            <td><strong style="font-size:1.15rem;color:var(--ut-primary, #7b4a2b);"><c:out value="${bankAccountNo}"/></strong></td>
                        </tr>
                        <tr>
                            <td>Chủ tài khoản:</td>
                            <td><c:out value="${bankAccountName}"/></td>
                        </tr>
                        <tr>
                            <td>Số tiền:</td>
                            <td><strong style="color:var(--ut-primary, #7b4a2b);font-size:1.2rem;"><c:out value="${formattedTotal}"/> đ</strong></td>
                        </tr>
                        <tr>
                            <td>Nội dung CK:</td>
                            <td><strong style="color:var(--ut-text, #2d1e15);background:var(--ut-cream, #fff8f0);border:1px solid var(--ut-border, #f0e2d3);padding:3px 8px;border-radius:6px;"><c:out value="${order.orderCode}"/></strong></td>
                        </tr>
                    </table>
                </div>
            </div>
        </c:if>

        <!-- Invoice Grid: Items Table & Customer Details -->
        <div class="invoice-grid">
            <!-- Left: Order Items Table -->
            <div class="invoice-card">
                <h2 class="invoice-card__title">Danh sách đồ uống đã đặt</h2>

                <table class="invoice-table">
                    <thead>
                    <tr>
                        <th>Sản phẩm</th>
                        <th>Đơn giá</th>
                        <th style="text-align:center;">SL</th>
                        <th style="text-align:right;">Thành tiền</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="item" items="${items}">
                        <fmt:formatNumber value="${item.unitPrice}" type="number" maxFractionDigits="0" var="formattedItemPrice"/>
                        <fmt:formatNumber value="${item.lineTotal}" type="number" maxFractionDigits="0" var="formattedItemTotal"/>
                        <tr>
                            <td>
                                <div class="item-name"><c:out value="${item.productName}"/></div>
                                <div class="item-options">
                                    Size: <strong><c:out value="${item.sizeName}"/></strong>
                                    &bull; Đường: <c:out value="${item.sugarLevel}"/>
                                    &bull; Đá: <c:out value="${item.iceLevel}"/>
                                    <c:if test="${not empty item.note}">
                                        &bull; <em>Ghi chú: <c:out value="${item.note}"/></em>
                                    </c:if>
                                </div>
                            </td>
                            <td><c:out value="${formattedItemPrice}"/> đ</td>
                            <td style="text-align:center;">x<c:out value="${item.quantity}"/></td>
                            <td style="text-align:right;font-weight:700;color:var(--ut-text, #2d1e15);"><c:out value="${formattedItemTotal}"/> đ</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Right: Delivery Info & Payment Summary -->
            <div>
                <!-- Recipient & Delivery Info -->
                <div class="invoice-card" style="margin-bottom:1.5rem;">
                    <h2 class="invoice-card__title">Thông tin giao nhận</h2>
                    <div class="invoice-info-rows">
                        <div>
                            <div class="info-block__label">Người nhận</div>
                            <div class="info-block__val"><c:out value="${order.recipientName}"/></div>
                        </div>
                        <div>
                            <div class="info-block__label">Số điện thoại</div>
                            <div class="info-block__val"><c:out value="${order.recipientPhone}"/></div>
                        </div>
                    </div>

                    <div style="margin-bottom:1.25rem;">
                        <div class="info-block__label">Địa chỉ giao hàng</div>
                        <div class="info-block__val" style="font-weight: 500; color:var(--ut-text, #2d1e15);">
                            <c:out value="${order.shippingAddress}"/>
                        </div>
                    </div>

                    <div style="margin-bottom:1.25rem;">
                        <div class="info-block__label">Chi nhánh xử lý</div>
                        <div class="info-block__val">
                            <c:out value="${order.branch != null ? order.branch.name : 'Chi nhánh chính'}"/>
                        </div>
                    </div>

                    <c:if test="${not empty order.note}">
                        <div>
                            <div class="info-block__label">Ghi chú của khách</div>
                            <div class="info-block__val" style="font-style: italic; color:var(--ut-muted, #7d6a5d); font-weight: 400;">
                                &ldquo;<c:out value="${order.note}"/>&rdquo;
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- Payment Summary -->
                <div class="invoice-card">
                    <h2 class="invoice-card__title">Hóa đơn thanh toán</h2>

                    <div style="margin-bottom: 1.25rem; display:flex; justify-content:space-between; align-items:center;">
                        <span style="font-size:0.92rem;color:var(--ut-muted, #7d6a5d);font-weight:600;">Phương thức:</span>
                        <strong style="color:var(--ut-text, #2d1e15);"><c:out value="${order.paymentMethod.label}"/></strong>
                    </div>

                    <div style="margin-bottom: 1.25rem; display:flex; justify-content:space-between; align-items:center;">
                        <span style="font-size:0.92rem;color:var(--ut-muted, #7d6a5d);font-weight:600;">Trạng thái TT:</span>
                        <c:choose>
                            <c:when test="${order.paymentStatus.name() == 'PAID'}">
                                <span class="badge-status badge-paid">&#10003; Đã thanh toán</span>
                            </c:when>
                            <c:when test="${order.paymentStatus.name() == 'FAILED'}">
                                <span class="badge-status badge-failed">&times; Thanh toán thất bại</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge-status badge-unpaid">&#9203; Chưa thanh toán</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <table class="summary-table">
                        <tr>
                            <td style="color:var(--ut-muted, #7d6a5d);">Tạm tính</td>
                            <td><c:out value="${formattedSubtotal}"/> đ</td>
                        </tr>
                        <tr>
                            <td style="color:var(--ut-muted, #7d6a5d);">Phí giao hàng</td>
                            <td><c:out value="${formattedShippingFee}"/> đ</td>
                        </tr>
                        <c:if test="${order.discountAmount gt 0}">
                            <tr>
                                <td style="color:#16a34a;">Giảm giá (Voucher)</td>
                                <td style="color:#16a34a;">-<c:out value="${formattedDiscount}"/> đ</td>
                            </tr>
                        </c:if>
                        <tr class="summary-total-row">
                            <td>Tổng thanh toán</td>
                            <td><c:out value="${formattedTotal}"/> đ</td>
                        </tr>
                    </table>

                    <div style="margin-top:1.5rem;display:flex;flex-direction:column;gap:0.75rem;">
                        <a href="${pageContext.request.contextPath}/products" class="order-btn order-btn--primary" style="width:100%;">
                            Tiếp tục đặt món
                        </a>
                        <c:if test="${not empty currentUser}">
                            <a href="${pageContext.request.contextPath}/account/orders" class="order-btn order-btn--subtle" style="width:100%;">
                                Quản lý đơn hàng của tôi
                            </a>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

    </div>
</section>
</body>
</html>
