<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Đăng nhập</title>
</head>
<body>
    <div class="container py-5">
        <div class="card auth-card shadow-sm">
            <div class="card-body p-4">
                <h1 class="h4 mb-1">Đăng nhập</h1>
                <p class="text-secondary small mb-4">Chào mừng bạn quay lại UTETra.</p>

                <%-- backend set model "error" khi sai mật khẩu --%>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger py-2"><c:out value="${error}"/></div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="post">
                    <div class="mb-3">
                        <label for="username" class="form-label">Email hoặc tên đăng nhập</label>
                        <input type="text" class="form-control" id="username" name="username" required autofocus>
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">Mật khẩu</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>
                    <div class="form-check mb-3">
                        <input class="form-check-input" type="checkbox" id="remember" name="remember">
                        <label class="form-check-label" for="remember">Ghi nhớ đăng nhập</label>
                    </div>
                    <button type="submit" class="btn btn-brand w-100">Đăng nhập</button>
                </form>

                <p class="text-center small mt-3 mb-0">
                    Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký</a>
                </p>
            </div>
        </div>
    </div>
</body>
</html>
