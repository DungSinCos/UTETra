<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head><title>Đặt lại mật khẩu</title></head>
<body>
<main class="container py-5" style="max-width:600px">
    <div class="card shadow-sm">
        <div class="card-body p-4">
            <h1 class="h3 mb-3">Đặt lại mật khẩu</h1>
            <c:if test="${not empty error}"><div class="alert alert-danger" role="alert"><c:out value="${error}"/></div></c:if>
            <c:choose>
                <c:when test="${validToken}">
                    <p class="text-muted">Liên kết có hiệu lực trong thời gian giới hạn. Mật khẩu mới phải có ít nhất 8 ký tự.</p>
                    <form method="post" action="${pageContext.request.contextPath}/reset-password">
                        <input type="hidden" name="token" value="<c:out value='${token}'/>">
                        <div class="mb-3">
                            <label class="form-label" for="newPassword">Mật khẩu mới</label>
                            <input class="form-control" type="password" id="newPassword" name="newPassword"
                                   autocomplete="new-password" minlength="8" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label" for="confirmPassword">Nhập lại mật khẩu</label>
                            <input class="form-control" type="password" id="confirmPassword" name="confirmPassword"
                                   autocomplete="new-password" minlength="8" required>
                        </div>
                        <button class="btn btn-primary" type="submit">Lưu mật khẩu mới</button>
                    </form>
                </c:when>
                <c:otherwise>
                    <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/forgot-password">Yêu cầu liên kết mới</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>
</body>
</html>
