<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head><title>Tài khoản của tôi</title></head>
<body>
<section class="container py-5" style="max-width:760px">
    <h1 class="mb-4">Tài khoản của tôi</h1>
    <c:if test="${not empty message}"><div class="alert alert-success"><c:out value="${message}"/></div></c:if>
    <c:if test="${not empty error}"><div class="alert alert-danger"><c:out value="${error}"/></div></c:if>

    <div class="d-flex flex-wrap gap-2 mb-4">
        <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/account/orders">Lịch sử đơn hàng</a>
        <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/account/change-password">Đổi mật khẩu</a>
    </div>

    <div class="card">
        <div class="card-header fw-semibold">Thông tin cá nhân</div>
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/account/profile">
                <div class="mb-3">
                    <label class="form-label" for="email">Email</label>
                    <input class="form-control" id="email" value="<c:out value='${email}'/>" readonly>
                    <div class="form-text">Email đăng nhập không thể đổi tại đây.</div>
                </div>
                <div class="mb-3">
                    <label class="form-label" for="fullName">Họ và tên</label>
                    <input class="form-control" id="fullName" name="fullName"
                           value="<c:out value='${profile.fullName}'/>" maxlength="100" required>
                </div>
                <div class="mb-4">
                    <label class="form-label" for="phone">Số điện thoại</label>
                    <input class="form-control" id="phone" name="phone" type="tel"
                           value="<c:out value='${profile.phone}'/>" maxlength="20">
                </div>
                <button class="btn btn-primary" type="submit">Lưu hồ sơ</button>
            </form>
        </div>
    </div>
</section>
</body>
</html>
