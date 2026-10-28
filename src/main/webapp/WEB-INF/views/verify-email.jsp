<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Xác thực Email</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">
</head>
<body>
<section class="auth-page">
    <div class="auth-card">
        <div class="auth-form-wrap">
            <div class="auth-head">
                <h1>Xác thực Email</h1>
                <p>
                    Chúng tôi đã gửi mã xác thực 6 chữ số tới
                    <strong><c:out value="${verifyEmail}"/></strong>
                </p>
            </div>

            <form id="verifyEmailForm"
                  class="auth-form"
                  action="${pageContext.request.contextPath}/verify-email"
                  data-resend-url="${pageContext.request.contextPath}/verify-email/resend"
                  method="post"
                  novalidate>
                <input type="hidden" id="verifyEmailInput" name="email" value="<c:out value='${verifyEmail}'/>">
                <input type="hidden" id="otpCodeInput" name="code" value="">

                <div class="auth-field">
                    <label for="otpDigit1">Mã xác thực (6 chữ số)</label>
                    <div class="otp-inputs" role="group" aria-label="Mã xác thực 6 chữ số">
                        <input type="text" id="otpDigit1" class="otp-digit" inputmode="numeric" pattern="[0-9]*" maxlength="1" autocomplete="one-time-code" required>
                        <input type="text" class="otp-digit" inputmode="numeric" pattern="[0-9]*" maxlength="1" required>
                        <input type="text" class="otp-digit" inputmode="numeric" pattern="[0-9]*" maxlength="1" required>
                        <input type="text" class="otp-digit" inputmode="numeric" pattern="[0-9]*" maxlength="1" required>
                        <input type="text" class="otp-digit" inputmode="numeric" pattern="[0-9]*" maxlength="1" required>
                        <input type="text" class="otp-digit" inputmode="numeric" pattern="[0-9]*" maxlength="1" required>
                    </div>
                </div>

                <button type="submit" class="auth-submit">Xác nhận</button>
            </form>

            <p class="auth-switch">
                Không nhận được mã?
                <button type="button" id="resendOtpBtn" class="auth-link auth-link--strong auth-link-btn">Gửi lại mã</button>
            </p>

            <p class="auth-switch" style="margin-top: 12px;">
                Nhập sai email?
                <a class="auth-link auth-link--strong" href="${pageContext.request.contextPath}/register">Quay lại đăng ký</a>
            </p>
        </div>
    </div>
</section>

<!-- Verify email pop-up modal -->
<div class="modal fade" id="verifyModal" tabindex="-1" aria-labelledby="verifyModalTitle" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content auth-modal">
            <div class="modal-header border-0">
                <h5 class="modal-title" id="verifyModalTitle">Thông báo</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
            </div>
            <div class="modal-body" id="verifyModalMessage">Mã xác thực không đúng hoặc đã hết hạn</div>
            <div class="modal-footer border-0">
                <button type="button" class="auth-submit auth-modal-btn" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/verify-email.js"></script>
</body>
</html>
