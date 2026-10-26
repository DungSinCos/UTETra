<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>403 - Không có quyền truy cập</title>
</head>
<body>
<section class="container py-5 text-center">
    <div class="p-5 rounded-4 shadow-sm bg-white border mx-auto" style="max-width: 560px;">
        <h1 class="display-4 fw-bold text-danger mb-2">403</h1>
        <h2 class="h4 fw-bold mb-3">Truy cập bị từ chối</h2>
        <p class="text-muted mb-4">
            Tài khoản của bạn không có quyền truy cập vào khu vực quản trị. Chỉ tài khoản <strong>ADMIN</strong> hoặc <strong>MANAGER</strong> mới được phép truy cập.
        </p>
        <div class="d-flex justify-content-center gap-2">
            <a href="${pageContext.request.contextPath}/" class="btn btn-dark rounded-pill px-4">Về trang chủ</a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-secondary rounded-pill px-4">Đăng nhập tài khoản khác</a>
        </div>
    </div>
</section>
</body>
</html>
