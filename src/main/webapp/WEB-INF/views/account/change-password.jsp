<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head><title>Đổi mật khẩu</title></head>
<body>
<section class="container py-5" style="max-width:620px">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
        <h1 class="mb-0">Đổi mật khẩu</h1>
        <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/">Về trang chủ</a>
    </div>
    <c:if test="${not empty error}"><div class="alert alert-danger"><c:out value="${error}"/></div></c:if>
    <div class="card">
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/account/change-password">
                <div class="mb-3">
                    <label class="form-label" for="currentPassword">Mật khẩu hiện tại</label>
                    <input class="form-control" type="password" id="currentPassword" name="currentPassword" autocomplete="current-password" required>
                </div>
                <div class="mb-3">
                    <label class="form-label" for="newPassword">Mật khẩu mới</label>
                    <input class="form-control" type="password" id="newPassword" name="newPassword" minlength="8" autocomplete="new-password" required>
                </div>
                <div class="mb-4">
                    <label class="form-label" for="confirmPassword">Nhập lại mật khẩu mới</label>
                    <input class="form-control" type="password" id="confirmPassword" name="confirmPassword" minlength="8" autocomplete="new-password" required>
                </div>
                <button class="btn btn-primary" type="submit">Cập nhật mật khẩu</button>
                <a class="btn btn-link" href="${pageContext.request.contextPath}/account/profile">Hủy</a>
            </form>
        </div>
    </div>
</section>
</body>
</html>
