<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Bảng điều khiển Quản trị - UTETra</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>
<section class="admin-page">
    <div class="site-container">

        <%-- Admin Navigation Bar --%>
        <jsp:include page="/WEB-INF/views/components/admin-nav.jsp"/>

        <%-- Header --%>
        <div class="admin-header">
            <div>
                <h1 class="admin-header__title">Bảng điều khiển</h1>
                <div class="admin-header__desc">
                    Xin chào<c:if test="${not empty currentUserName}">, <strong><c:out value="${currentUserName}"/></strong></c:if>.
                    Tổng quan hoạt động kinh doanh và thực đơn của hệ thống UTETra.
                </div>
            </div>
            <div>
                <a class="admin-btn admin-btn--primary" href="${pageContext.request.contextPath}/admin/products/new">
                    + Thêm sản phẩm mới
                </a>
            </div>
        </div>

        <%-- Section 1: Thống kê Sản phẩm --%>
        <h2 class="admin-section-title">Tổng quan Sản phẩm</h2>
        <div class="row g-3 mb-5">
            <div class="col-6 col-lg-3">
                <div class="admin-card">
                    <div class="admin-card__label">Tổng sản phẩm</div>
                    <div class="admin-card__value admin-card__value--primary"><c:out value="${totalProducts}"/></div>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="admin-card admin-card--highlight">
                    <div class="admin-card__label">Đang bán</div>
                    <div class="admin-card__value admin-card__value--success"><c:out value="${activeProducts}"/></div>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="admin-card">
                    <div class="admin-card__label">Đã ẩn khỏi menu</div>
                    <div class="admin-card__value admin-card__value--muted"><c:out value="${hiddenProducts}"/></div>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="admin-card">
                    <div class="admin-card__label">Món nổi bật (đang bán)</div>
                    <div class="admin-card__value admin-card__value--primary"><c:out value="${featuredProducts}"/></div>
                </div>
            </div>
        </div>

        <%-- Section 2: Đơn hàng & Doanh thu --%>
        <div class="admin-section-heading">
            <h2 class="admin-section-title mb-0">Đơn hàng &amp; Doanh thu</h2>
            <form class="admin-filter-bar" method="get" action="${pageContext.request.contextPath}/admin/dashboard">
                <div class="admin-filter-group">
                    <label class="admin-filter-label" for="from">Từ ngày</label>
                    <input class="admin-filter-input" type="date" id="from" name="from" value="${from}" required>
                </div>
                <div class="admin-filter-group">
                    <label class="admin-filter-label" for="to">Đến ngày</label>
                    <input class="admin-filter-input" type="date" id="to" name="to" value="${to}" required>
                </div>
                <button class="admin-btn admin-btn--filter" type="submit">Lọc</button>
            </form>
        </div>

        <c:if test="${not empty dateError}">
            <div class="alert alert-danger mb-4"><c:out value="${dateError}"/></div>
        </c:if>

        <div class="row g-3 mb-5">
            <div class="col-md-4">
                <div class="admin-card">
                    <div class="admin-card__label">Đơn trong khoảng lọc</div>
                    <div class="admin-card__value admin-card__value--primary"><c:out value="${orderSummary.totalOrders}"/></div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="admin-card admin-card--warning">
                    <div class="admin-card__label">Đơn đang chờ xử lý</div>
                    <div class="admin-card__value admin-card__value--warning"><c:out value="${orderSummary.pendingOrders}"/></div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="admin-card admin-card--revenue">
                    <div class="admin-card__label">Doanh thu đã thanh toán</div>
                    <div class="admin-card__value admin-card__value--revenue">
                        <fmt:formatNumber value="${orderSummary.paidRevenue}" type="number" maxFractionDigits="0"/> đ
                    </div>
                </div>
            </div>
        </div>

        <%-- Section 3: Truy cập nhanh --%>
        <h2 class="admin-section-title">Truy cập nhanh</h2>
        <div class="row g-3">
            <div class="col-md-6 col-lg-4">
                <a class="admin-action-card" href="${pageContext.request.contextPath}/admin/orders">
                    <div class="admin-action-card__title">
                        Quản lý đơn hàng
                        <span style="color:var(--ut-primary, #7b4a2b);">&rarr;</span>
                    </div>
                    <p class="admin-action-card__desc">Tra cứu đơn, phân loại trạng thái, in bill và cập nhật tiến độ giao hàng.</p>
                </a>
            </div>
            <div class="col-md-6 col-lg-4">
                <a class="admin-action-card" href="${pageContext.request.contextPath}/admin/products">
                    <div class="admin-action-card__title">
                        Quản lý sản phẩm
                        <span style="color:var(--ut-primary, #7b4a2b);">&rarr;</span>
                    </div>
                    <p class="admin-action-card__desc">Xem toàn bộ menu, chỉnh sửa giá bán, tải ảnh Cloudinary và ẩn/hiện món.</p>
                </a>
            </div>
            <div class="col-md-6 col-lg-4">
                <a class="admin-action-card" href="${pageContext.request.contextPath}/admin/categories">
                    <div class="admin-action-card__title">
                        Quản lý danh mục
                        <span style="color:var(--ut-primary, #7b4a2b);">&rarr;</span>
                    </div>
                    <p class="admin-action-card__desc">Thêm nhóm trà mới, điều chỉnh thứ tự hiển thị danh mục trên thanh lọc.</p>
                </a>
            </div>
            <div class="col-md-6 col-lg-4">
                <a class="admin-action-card" href="${pageContext.request.contextPath}/admin/branches">
                    <div class="admin-action-card__title">
                        Quản lý chi nhánh
                        <span style="color:var(--ut-primary, #7b4a2b);">&rarr;</span>
                    </div>
                    <p class="admin-action-card__desc">Xem danh sách, thêm chi nhánh mới, sửa thông tin và bật/tắt hoạt động cửa hàng.</p>
                </a>
            </div>
            <c:if test="${currentUserRole == 'ADMIN'}">
                <div class="col-md-6 col-lg-4">
                    <a class="admin-action-card" href="${pageContext.request.contextPath}/admin/users">
                        <div class="admin-action-card__title">
                            Quản lý người dùng
                            <span style="color:var(--ut-primary, #7b4a2b);">&rarr;</span>
                        </div>
                        <p class="admin-action-card__desc">Xem danh sách khách hàng, nhân viên, phân quyền hoặc khóa tài khoản.</p>
                    </a>
                </div>
            </c:if>
            <div class="col-md-6 col-lg-4">
                <a class="admin-action-card" href="${pageContext.request.contextPath}/admin/products/new">
                    <div class="admin-action-card__title">
                        + Tạo món mới
                        <span style="color:var(--ut-primary, #7b4a2b);">&rarr;</span>
                    </div>
                    <p class="admin-action-card__desc">Tạo mới trà sữa, trà trái cây, kèm ảnh đại diện và định giá theo các size.</p>
                </a>
            </div>
            <div class="col-md-6 col-lg-4">
                <a class="admin-action-card" href="${pageContext.request.contextPath}/products" target="_blank">
                    <div class="admin-action-card__title">
                        Xem trang khách hàng
                        <span style="color:var(--ut-primary, #7b4a2b);">&#8599;</span>
                    </div>
                    <p class="admin-action-card__desc">Mở giao diện đặt món thực tế mà khách hàng nhìn thấy trên website.</p>
                </a>
            </div>
        </div>

    </div>
</section>
</body>
</html>
