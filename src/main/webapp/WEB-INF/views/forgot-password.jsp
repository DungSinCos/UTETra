<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quên mật khẩu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">
    <style>
        .forgot-password-page {
            background: linear-gradient(135deg, #fff8f0 0%, #fbe6cf 100%);
        }

        .forgot-password-card {
            max-width: 520px;
            border: 0;
            border-radius: 24px;
            background: #fff;
            box-shadow: 0 20px 50px rgba(123, 74, 43, 0.15);
        }

        .forgot-password-card .auth-form-wrap {
            padding: 48px 44px;
        }

        .forgot-password-card .auth-field input {
            min-height: 50px;
            border-radius: 10px;
        }

        .forgot-password-back {
            display: inline-block;
            margin-top: 22px;
            color: #7b4a2b;
            font-weight: 600;
            text-decoration: none;
        }

        .forgot-password-back:hover {
            color: #5a3520;
            text-decoration: underline;
        }

        @media (max-width: 480px) {
            .forgot-password-card .auth-form-wrap {
                padding: 36px 24px;
            }
        }
    </style>
</head>
<body>
<section class="auth-page forgot-password-page">
    <div class="auth-card card rounded-4 shadow-sm forgot-password-card">
        <div class="auth-form-wrap card-body">
            <div class="auth-head">
                <h1>Quên mật khẩu</h1>
                <p>Nhập email đã đăng ký. Nếu tài khoản đang hoạt động, UTETra sẽ gửi hướng dẫn đặt lại mật khẩu đến hộp thư của bạn.</p>
            </div>

            <c:if test="${not empty message}">
                <div class="alert alert-success rounded-3" role="status"><c:out value="${message}"/></div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger rounded-3" role="alert"><c:out value="${error}"/></div>
            </c:if>

            <form class="auth-form" method="post" action="${pageContext.request.contextPath}/forgot-password">
                <div class="auth-field">
                    <label for="email">Email</label>
                    <input class="form-control" type="email" id="email" name="email"
                           value="<c:out value='${email}'/>" placeholder="example@gmail.com"
                           autocomplete="email" maxlength="150" required>
                </div>

                <button class="auth-submit btn" type="submit">Gửi liên kết đặt lại</button>
            </form>

            <div class="text-center">
                <a class="forgot-password-back" href="${pageContext.request.contextPath}/login">Quay lại đăng nhập</a>
            </div>
        </div>
    </div>
</section>
</body>
</html>
