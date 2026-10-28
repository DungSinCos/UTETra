<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Chi tiết đơn hàng</title>
</head>
<body>
<section class="container py-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
        <div>
            <h1 class="mb-1">Đơn <c:out value="${order.orderCode}"/></h1>
            <p class="text-muted mb-0">Tạo lúc <c:out value="${order.createdAt}"/></p>
        </div>
        <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/orders">Quay lại danh sách</a>
    </div>

    <c:if test="${not empty message}"><div class="alert alert-success"><c:out value="${message}"/></div></c:if>
    <c:if test="${not empty error}"><div class="alert alert-danger"><c:out value="${error}"/></div></c:if>

    <div class="row g-4 mb-4">
        <div class="col-lg-6">
            <div class="card h-100">
                <div class="card-header fw-semibold">Thông tin nhận hàng</div>
                <div class="card-body">
                    <div><strong>Người nhận:</strong> <c:out value="${order.recipientName}"/></div>
                    <div><strong>Điện thoại:</strong> <c:out value="${order.recipientPhone}"/></div>
                    <div><strong>Loại đơn:</strong> <c:out value="${order.orderType.label}"/></div>
                    <div><strong>Chi nhánh:</strong> <c:out value="${order.branch.name}"/></div>
                    <c:if test="${not empty order.shippingAddress}"><div><strong>Địa chỉ:</strong> <c:out value="${order.shippingAddress}"/></div></c:if>
                    <c:if test="${not empty order.note}"><div><strong>Ghi chú:</strong> <c:out value="${order.note}"/></div></c:if>
                    <c:if test="${not empty order.user}"><div><strong>Tài khoản:</strong> <c:out value="${order.user.email}"/></div></c:if>
                </div>
            </div>
        </div>
        <div class="col-lg-6">
            <div class="card h-100">
                <div class="card-header fw-semibold">Trạng thái và thanh toán</div>
                <div class="card-body">
                    <div><strong>Trạng thái đơn:</strong> <c:out value="${order.orderStatus.label}"/></div>
                    <div><strong>Thanh toán:</strong> <c:out value="${order.paymentStatus.label}"/></div>
                    <div><strong>Phương thức:</strong> <c:out value="${order.paymentMethod.label}"/></div>
                    <c:if test="${not empty nextStatuses}">
                        <form class="d-flex gap-2 mt-3" method="post"
                              action="${pageContext.request.contextPath}/admin/orders/${order.id}/status">
                            <select class="form-select" name="status" required>
                                <c:forEach var="nextStatus" items="${nextStatuses}">
                                    <option value="${nextStatus}"><c:out value="${nextStatus.label}"/></option>
                                </c:forEach>
                            </select>
                            <button class="btn btn-primary text-nowrap" type="submit">Cập nhật</button>
                        </form>
                    </c:if>
                    <c:if test="${empty nextStatuses}">
                        <p class="text-muted small mt-3 mb-0">Đơn đã ở trạng thái kết thúc, không thể chuyển tiếp.</p>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-header fw-semibold">Sản phẩm trong đơn</div>
        <div class="table-responsive">
            <table class="table align-middle mb-0">
                <thead><tr><th>Món</th><th>Tùy chọn</th><th class="text-end">Đơn giá</th><th class="text-center">SL</th><th class="text-end">Thành tiền</th></tr></thead>
                <tbody>
                <c:forEach var="item" items="${items}">
                    <tr>
                        <td><c:out value="${item.productName}"/></td>
                        <td>
                            <div>Size <c:out value="${item.sizeName}"/> · Đường <c:out value="${item.sugarLevel}"/> · Đá <c:out value="${item.iceLevel}"/></div>
                            <c:forEach var="topping" items="${item.toppings}">
                                <div class="small text-muted">+ <c:out value="${topping.toppingName}"/> × <c:out value="${topping.quantity}"/></div>
                            </c:forEach>
                            <c:if test="${not empty item.note}"><div class="small text-muted">Ghi chú: <c:out value="${item.note}"/></div></c:if>
                        </td>
                        <td class="text-end"><fmt:formatNumber value="${item.unitPrice + item.toppingTotalPrice}" type="number" maxFractionDigits="0"/> đ</td>
                        <td class="text-center"><c:out value="${item.quantity}"/></td>
                        <td class="text-end"><fmt:formatNumber value="${item.lineTotal}" type="number" maxFractionDigits="0"/> đ</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty items}"><tr><td colspan="5" class="text-center text-muted">Đơn hàng chưa có dòng sản phẩm.</td></tr></c:if>
                </tbody>
            </table>
        </div>
        <div class="card-body ms-auto" style="min-width:300px">
            <div class="d-flex justify-content-between"><span>Tạm tính</span><span><fmt:formatNumber value="${order.subtotalAmount}" type="number" maxFractionDigits="0"/> đ</span></div>
            <div class="d-flex justify-content-between"><span>Phí giao hàng</span><span><fmt:formatNumber value="${order.shippingFee}" type="number" maxFractionDigits="0"/> đ</span></div>
            <div class="d-flex justify-content-between"><span>Giảm giá</span><span>- <fmt:formatNumber value="${order.discountAmount}" type="number" maxFractionDigits="0"/> đ</span></div>
            <hr>
            <div class="d-flex justify-content-between fw-bold"><span>Tổng</span><span><fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0"/> đ</span></div>
        </div>
    </div>

    <div class="card">
        <div class="card-header fw-semibold">Lịch sử giao dịch thanh toán</div>
        <div class="table-responsive">
            <table class="table align-middle mb-0">
                <thead><tr><th>Thời gian</th><th>Nhà cung cấp</th><th>Mã giao dịch</th><th>Trạng thái</th><th class="text-end">Số tiền</th></tr></thead>
                <tbody>
                <c:forEach var="payment" items="${payments}">
                    <tr>
                        <td><c:out value="${payment.createdAt}"/></td>
                        <td><c:out value="${payment.provider.label}"/></td>
                        <td><c:out value="${payment.transactionRef}"/></td>
                        <td><c:out value="${payment.status.label}"/></td>
                        <td class="text-end"><fmt:formatNumber value="${payment.amount}" type="number" maxFractionDigits="0"/> đ</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty payments}"><tr><td colspan="5" class="text-center text-muted">Chưa có giao dịch thanh toán.</td></tr></c:if>
                </tbody>
            </table>
        </div>
    </div>
</section>
</body>
</html>
