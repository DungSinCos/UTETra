document.addEventListener('DOMContentLoaded', function () {
    const form = document.getElementById('registerForm');
    if (!form) return;

    const fullNameInput = document.getElementById('fullName');
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const submitBtn = form.querySelector('button[type="submit"]');
    const modalEl = document.getElementById('registerModal');
    const titleEl = document.getElementById('registerModalTitle');
    const messageEl = document.getElementById('registerModalMessage');

    const EMAIL_REGEX = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
    const SERVER_ERROR_MSG = 'Có lỗi xảy ra khi tạo tài khoản, vui lòng thử lại';

    function showPopup(title, message) {
        if (titleEl) titleEl.textContent = title;
        if (messageEl) messageEl.textContent = message;
        if (window.bootstrap && modalEl) {
            bootstrap.Modal.getOrCreateInstance(modalEl).show();
        } else {
            alert(message);
        }
    }

    form.addEventListener('submit', async function (e) {
        e.preventDefault();

        const fullName = fullNameInput.value.trim();
        const email = emailInput.value.trim();
        const password = passwordInput.value;

        if (!fullName) {
            showPopup('Thông tin không hợp lệ', 'Vui lòng nhập họ và tên.');
            fullNameInput.focus();
            return;
        }

        if (!email || !EMAIL_REGEX.test(email)) {
            showPopup('Email không hợp lệ', 'Vui lòng nhập đúng định dạng email (ví dụ: example@gmail.com).');
            emailInput.focus();
            return;
        }

        if (!password || password.length < 8) {
            showPopup('Mật khẩu không hợp lệ', 'Mật khẩu phải có ít nhất 8 ký tự.');
            passwordInput.focus();
            return;
        }

        submitBtn.disabled = true;

        try {
            const res = await fetch(form.action, {
                method: 'POST',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
                },
                body: new URLSearchParams(new FormData(form)),
                credentials: 'same-origin'
            });

            const data = await res.json().catch(() => ({}));

            if (res.ok && data.success) {
                window.location.href = data.redirect || '/login';
                return;
            }

            showPopup('Đăng ký thất bại', SERVER_ERROR_MSG);
        } catch (err) {
            showPopup('Đăng ký thất bại', SERVER_ERROR_MSG);
        } finally {
            submitBtn.disabled = false;
        }
    });
});
