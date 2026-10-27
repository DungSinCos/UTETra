<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản trị</title>
</head>
<body>
<section class="container py-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
        <div>
            <h1 class="mb-1">Bảng điều khiển</h1>
            <p class="text-muted mb-0">
                Xin chào<c:if test="${not empty currentUserName}">, <strong><c:out value="${currentUserName}"/></strong></c:if>.
                Tổng quan nhanh về thực đơn của UTETra.
            </p>
        </div>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/products/new">+ Thêm sản phẩm</a>
    </div>

    <%-- Numbers come from ProductService (database), never hard-coded. --%>
    <h2 class="h5 mb-3">Sản phẩm</h2>
    <div class="row g-3 mb-5">
        <div class="col-6 col-lg-3">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <div class="text-muted small">Tổng sản phẩm</div>
                    <div class="display-6"><c:out value="${totalProducts}"/></div>
                </div>
            </div>
        </div>
        <div class="col-6 col-lg-3">
            <div class="card shadow-sm h-100 border-success">
                <div class="card-body">
                    <div class="text-muted small">Đang bán</div>
                    <div class="display-6 text-success"><c:out value="${activeProducts}"/></div>
                </div>
            </div>
        </div>
        <div class="col-6 col-lg-3">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <div class="text-muted small">Đã ẩn</div>
                    <div class="display-6 text-secondary"><c:out value="${hiddenProducts}"/></div>
                </div>
            </div>
        </div>
        <div class="col-6 col-lg-3">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <div class="text-muted small">Nổi bật (đang bán)</div>
                    <div class="display-6"><c:out value="${featuredProducts}"/></div>
                </div>
            </div>
        </div>
    </div>

    <div class="d-flex flex-wrap justify-content-between align-items-end gap-2 mb-3">
        <h2 class="h5 mb-0">Đơn hàng</h2>
        <form class="d-flex flex-wrap align-items-end gap-2" method="get"
              action="${pageContext.request.contextPath}/admin/dashboard">
            <div>
                <label class="form-label small mb-1" for="from">Từ ngày</label>
                <input class="form-control form-control-sm" type="date" id="from" name="from" value="${from}" required>
            </div>
            <div>
                <label class="form-label small mb-1" for="to">Đến ngày</label>
                <input class="form-control form-control-sm" type="date" id="to" name="to" value="${to}" required>
            </div>
            <button class="btn btn-sm btn-outline-primary" type="submit">Lọc</button>
        </form>
    </div>
    <c:if test="${not empty dateError}"><div class="alert alert-danger"><c:out value="${dateError}"/></div></c:if>
    <div class="row g-3 mb-5">
        <div class="col-6 col-lg-4">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <div class="text-muted small">Đơn trong khoảng thời gian</div>
                    <div class="display-6"><c:out value="${orderSummary.totalOrders}"/></div>
                </div>
            </div>
        </div>
        <div class="col-6 col-lg-4">
            <div class="card shadow-sm h-100 border-warning">
                <div class="card-body">
                    <div class="text-muted small">Đơn đang chờ</div>
                    <div class="display-6 text-warning"><c:out value="${orderSummary.pendingOrders}"/></div>
                </div>
            </div>
        </div>
        <div class="col-6 col-lg-4">
            <div class="card shadow-sm h-100 border-success">
                <div class="card-body">
                    <div class="text-muted small">Doanh thu đã thanh toán</div>
                    <div class="display-6 text-success"><fmt:formatNumber value="${orderSummary.paidRevenue}" type="number" maxFractionDigits="0"/> đ</div>
                </div>
            </div>
        </div>
    </div>

    <h2 class="h5 mb-3">Truy cập nhanh</h2>
    <div class="row g-3">
        <div class="col-md-6 col-lg-4">
            <a class="card shadow-sm h-100 text-decoration-none" href="${pageContext.request.contextPath}/admin/products">
                <div class="card-body">
                    <div class="fw-semibold">Quản lý sản phẩm</div>
                    <div class="text-muted small">Xem danh sách, sửa, ẩn hoặc hiện món trên thực đơn.</div>
                </div>
            </a>
        </div>
        <div class="col-md-6 col-lg-4">
            <a class="card shadow-sm h-100 text-decoration-none" href="${pageContext.request.contextPath}/admin/products/new">
                <div class="card-body">
                    <div class="fw-semibold">Thêm sản phẩm mới</div>
                    <div class="text-muted small">Tạo món mới, kèm ảnh tải lên Cloudinary.</div>
                </div>
            </a>
        </div>
        <div class="col-md-6 col-lg-4">
            <a class="card shadow-sm h-100 text-decoration-none" href="${pageContext.request.contextPath}/admin/categories">
                <div class="card-body">
                    <div class="fw-semibold">Quản lý danh mục</div>
                    <div class="text-muted small">Thêm, sửa, sắp xếp và ẩn/hiện nhóm sản phẩm.</div>
                </div>
            </a>
        </div>
        <div class="col-md-6 col-lg-4">
            <a class="card shadow-sm h-100 text-decoration-none" href="${pageContext.request.contextPath}/admin/orders">
                <div class="card-body">
                    <div class="fw-semibold">Quản lý đơn hàng</div>
                    <div class="text-muted small">Tra cứu đơn, xem chi tiết và cập nhật tiến độ xử lý.</div>
                </div>
            </a>
        </div>
        <div class="col-md-6 col-lg-4">
            <a class="card shadow-sm h-100 text-decoration-none" href="${pageContext.request.contextPath}/products">
                <div class="card-body">
                    <div class="fw-semibold">Xem thực đơn công khai</div>
                    <div class="text-muted small">Trang khách hàng nhìn thấy.</div>
                </div>
            </a>
        </div>
        <%-- Add one link card per new admin module here (orders, users, branches...) --%>
    </div>
</section>
</body>
</html>
