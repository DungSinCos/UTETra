document.addEventListener('DOMContentLoaded', function () {
    const form = document.getElementById('verifyEmailForm');
    if (!form) return;

    const digits = Array.from(form.querySelectorAll('.otp-digit'));
    const hiddenCode = document.getElementById('otpCodeInput');
    const emailInput = document.getElementById('verifyEmailInput');
    const submitBtn = form.querySelector('button[type="submit"]');
    const resendBtn = document.getElementById('resendOtpBtn');
    const modalEl = document.getElementById('verifyModal');
    const titleEl = document.getElementById('verifyModalTitle');
    const messageEl = document.getElementById('verifyModalMessage');

    function showPopup(title, message) {
        if (titleEl) titleEl.textContent = title;
        if (messageEl) messageEl.textContent = message;
        if (window.bootstrap && modalEl) {
            bootstrap.Modal.getOrCreateInstance(modalEl).show();
        } else {
            alert(message);
        }
    }

    function syncCode() {
        hiddenCode.value = digits.map(d => d.value.trim()).join('');
    }

    digits.forEach((input, idx) => {
        input.addEventListener('input', function () {
            this.value = this.value.replace(/\D/g, '').slice(-1);
            syncCode();
            if (this.value && idx < digits.length - 1) {
                digits[idx + 1].focus();
            }
        });

        input.addEventListener('keydown', function (e) {
            if (e.key === 'Backspace' && !this.value && idx > 0) {
                digits[idx - 1].value = '';
                syncCode();
                digits[idx - 1].focus();
            } else if (e.key === 'ArrowLeft' && idx > 0) {
                digits[idx - 1].focus();
            } else if (e.key === 'ArrowRight' && idx < digits.length - 1) {
                digits[idx + 1].focus();
            }
        });

        input.addEventListener('paste', function (e) {
            e.preventDefault();
            const pasted = (e.clipboardData || window.clipboardData)
                .getData('text')
                .replace(/\D/g, '')
                .slice(0, digits.length);
            if (!pasted) return;
            pasted.split('').forEach((ch, i) => {
                if (digits[i]) digits[i].value = ch;
            });
            syncCode();
            const nextIdx = Math.min(pasted.length, digits.length - 1);
            digits[nextIdx].focus();
        });
    });

    if (digits[0]) {
        digits[0].focus();
    }

    form.addEventListener('submit', async function (e) {
        e.preventDefault();
        syncCode();

        const code = hiddenCode.value;
        if (!/^\d{6}$/.test(code)) {
            showPopup('Mã không hợp lệ', 'Vui lòng nhập đầy đủ mã xác thực gồm 6 chữ số.');
            const firstEmpty = digits.find(d => !d.value) || digits[0];
            if (firstEmpty) firstEmpty.focus();
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

            showPopup('Xác thực thất bại', data.message || 'Mã xác thực không đúng hoặc đã hết hạn.');
        } catch (err) {
            showPopup('Xác thực thất bại', 'Không thể kết nối tới máy chủ. Vui lòng thử lại.');
        } finally {
            submitBtn.disabled = false;
        }
    });

    if (resendBtn) {
        resendBtn.addEventListener('click', async function () {
            const resendUrl = form.getAttribute('data-resend-url');
            if (!resendUrl) return;

            resendBtn.disabled = true;
            try {
                const res = await fetch(resendUrl, {
                    method: 'POST',
                    headers: {
                        'Accept': 'application/json',
                        'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
                    },
                    body: new URLSearchParams({ email: emailInput.value }),
                    credentials: 'same-origin'
                });
                const data = await res.json().catch(() => ({}));
                if (res.ok && data.success) {
                    digits.forEach(d => { d.value = ''; });
                    syncCode();
                    if (digits[0]) digits[0].focus();
                    showPopup('Đã gửi lại mã', data.message || 'Mã xác thực 6 chữ số mới đã được gửi tới email của bạn.');
                } else {
                    showPopup('Không thể gửi lại mã', data.message || 'Vui lòng thử lại sau.');
                }
            } catch (err) {
                showPopup('Không thể gửi lại mã', 'Không thể kết nối tới máy chủ. Vui lòng thử lại.');
            } finally {
                resendBtn.disabled = false;
            }
        });
    }
});
