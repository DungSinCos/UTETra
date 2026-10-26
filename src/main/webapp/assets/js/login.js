document.addEventListener('DOMContentLoaded', function () {
    const form = document.getElementById('loginForm');
    if (!form) return;

    const submitBtn = form.querySelector('button[type="submit"]');
    const modalEl = document.getElementById('authErrorModal');
    const messageEl = document.getElementById('authErrorMessage');
    const DEFAULT_ERROR = 'Email hoặc mật khẩu không đúng';

    function showError(message) {
        messageEl.textContent = message || DEFAULT_ERROR;
        if (window.bootstrap && modalEl) {
            bootstrap.Modal.getOrCreateInstance(modalEl).show();
        } else {
            alert(messageEl.textContent);
        }
    }

    if (modalEl) {
        modalEl.addEventListener('hidden.bs.modal', function () {
            const pwd = form.querySelector('#password');
            pwd.value = '';
            pwd.focus();
        });
    }

    form.addEventListener('submit', async function (e) {
        e.preventDefault();
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
                window.location.href = data.redirect || '/';
                return;
            }
            showError(data.message);
        } catch (err) {
            showError('Không thể kết nối tới máy chủ. Vui lòng thử lại.');
        } finally {
            submitBtn.disabled = false;
        }
    });
});
