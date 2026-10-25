<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Đăng ký</title>
</head>
<body>
    <div class="container py-5">
        <div class="card auth-card shadow-sm">
            <div class="card-body p-4">
                <h1 class="h4 mb-1">Tạo tài khoản</h1>
                <p class="text-secondary small mb-4">Đăng ký để đặt món nhanh hơn.</p>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger py-2"><c:out value="${error}"/></div>
                </c:if>

                <form id="registerForm" action="${pageContext.request.contextPath}/register" method="post" novalidate>
                    <div class="mb-3">
                        <label for="fullName" class="form-label">Họ và tên</label>
                        <input type="text" class="form-control" id="fullName" name="fullName" required>
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="email" name="email" required>
                    </div>
                    <div class="mb-3">
                        <label for="phone" class="form-label">Số điện thoại</label>
                        <input type="tel" class="form-control" id="phone" name="phone"
                               pattern="0[0-9]{9}" placeholder="0901234567" required>
                        <div class="invalid-feedback">Số điện thoại gồm 10 số, bắt đầu bằng 0.</div>
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">Mật khẩu</label>
                        <input type="password" class="form-control" id="password" name="password" minlength="6" required>
                        <div class="invalid-feedback">Mật khẩu tối thiểu 6 ký tự.</div>
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Nhập lại mật khẩu</label>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                        <div class="invalid-feedback">Mật khẩu nhập lại không khớp.</div>
                    </div>
                    <button type="submit" class="btn btn-brand w-100">Đăng ký</button>
                </form>

                <p class="text-center small mt-3 mb-0">
                    Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                </p>
            </div>
        </div>
    </div>

    <script>
        // kiểm tra form phía client, server vẫn phải validate lại
        (function () {
            var form = document.getElementById('registerForm');
            var pw = document.getElementById('password');
            var cf = document.getElementById('confirmPassword');

            form.addEventListener('submit', function (e) {
                cf.setCustomValidity(pw.value === cf.value ? '' : 'mismatch');
                if (!form.checkValidity()) {
                    e.preventDefault();
                    form.classList.add('was-validated');
                }
            });
            cf.addEventListener('input', function () {
                cf.setCustomValidity(pw.value === cf.value ? '' : 'mismatch');
            });
        })();
    </script>
</body>
</html>
