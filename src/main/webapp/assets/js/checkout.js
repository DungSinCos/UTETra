document.addEventListener("DOMContentLoaded", function () {
    var page = document.querySelector(".checkout-page");
    var contextPath = page ? (page.getAttribute("data-context-path") || "") : "";
    var form = document.getElementById("checkoutForm");
    var toggleBtn = document.getElementById("toggleCustomAddressBtn");
    var addressFormWrap = document.getElementById("addressFormWrap");
    var selectedAddressInput = document.getElementById("selectedAddressId");
    var savedAddressId = selectedAddressInput ? selectedAddressInput.value : "";

    var paymentCards = document.querySelectorAll("[data-payment-card]");
    var cashBox = document.getElementById("cashSkeletonBox");
    var vnpayBox = document.getElementById("vnpayBox");
    var bankTransferBox = document.getElementById("bankTransferBox");
    var summaryPaymentLabel = document.getElementById("summaryPaymentLabel");
    var errorEl = document.getElementById("checkoutErrorMsg");
    var payBtn = document.getElementById("payOrderBtn");

    var successModal = document.getElementById("checkoutSuccessModal");
    var successOrderCode = document.getElementById("successOrderCode");
    var successPaymentMethod = document.getElementById("successPaymentMethod");
    var successOrderTotal = document.getElementById("successOrderTotal");
    var successViewInvoiceBtn = document.getElementById("successViewInvoiceBtn");

    function formatVnd(amount) {
        return Number(amount || 0).toLocaleString("vi-VN") + "đ";
    }

    if (toggleBtn && addressFormWrap && selectedAddressInput) {
        toggleBtn.addEventListener("click", function () {
            var isHidden = addressFormWrap.hidden;
            addressFormWrap.hidden = !isHidden;
            if (isHidden) {
                selectedAddressInput.value = "";
                toggleBtn.textContent = "Dùng địa chỉ hiện tại";
            } else {
                selectedAddressInput.value = savedAddressId;
                toggleBtn.textContent = "Đổi địa chỉ khác";
            }
        });
    }

    paymentCards.forEach(function (card) {
        var radio = card.querySelector('input[type="radio"]');
        if (!radio) {
            return;
        }
        radio.addEventListener("change", function () {
            var method = radio.value;
            paymentCards.forEach(function (c) {
                c.classList.toggle("is-selected", c === card);
            });
            if (cashBox) cashBox.hidden = method !== "CASH";
            if (vnpayBox) vnpayBox.hidden = method !== "VNPAY";
            if (bankTransferBox) bankTransferBox.hidden = method !== "BANK_TRANSFER";

            if (summaryPaymentLabel) {
                if (method === "VNPAY") {
                    summaryPaymentLabel.textContent = "Cổng VNPay";
                } else if (method === "BANK_TRANSFER") {
                    summaryPaymentLabel.textContent = "Chuyển khoản VietQR";
                } else {
                    summaryPaymentLabel.textContent = "Tiền mặt (COD)";
                }
            }
        });
    });

    if (form) {
        form.addEventListener("submit", function (e) {
            e.preventDefault();
            if (!payBtn || payBtn.disabled) {
                return;
            }
            if (errorEl) {
                errorEl.hidden = true;
                errorEl.textContent = "";
            }

            var usingCustomAddress = !selectedAddressInput || !selectedAddressInput.value;
            if (usingCustomAddress) {
                var nameVal = (document.getElementById("recipientName").value || "").trim();
                var phoneVal = (document.getElementById("recipientPhone").value || "").trim();
                var lineVal = (document.getElementById("addressLine").value || "").trim();
                var distVal = (document.getElementById("district").value || "").trim();
                var cityVal = (document.getElementById("city").value || "").trim();

                if (!nameVal || !phoneVal || !lineVal || !distVal || !cityVal) {
                    if (errorEl) {
                        errorEl.textContent = "Vui lòng điền đầy đủ họ tên, số điện thoại và địa chỉ giao hàng.";
                        errorEl.hidden = false;
                    }
                    return;
                }
            }

            payBtn.disabled = true;
            payBtn.textContent = "Đang xử lý đơn hàng...";

            var formData = new FormData(form);
            var body = new URLSearchParams();
            formData.forEach(function (val, key) {
                body.append(key, val);
            });

            var selectedMethod = form.querySelector('input[name="paymentMethod"]:checked');
            var methodVal = selectedMethod ? selectedMethod.value : "CASH";

            fetch(contextPath + "/checkout", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8",
                    "Accept": "application/json"
                },
                body: body.toString()
            })
                .then(function (res) {
                    return res.json().then(function (data) {
                        return { status: res.status, data: data };
                    });
                })
                .then(function (result) {
                    if (result.data && result.data.success) {
                        // If VNPay, redirect directly to VNPay portal
                        if (methodVal === "VNPAY" && result.data.redirectUrl) {
                            window.location.href = result.data.redirectUrl;
                            return;
                        }

                        // Otherwise show success modal with invoice link
                        if (successOrderCode) {
                            successOrderCode.textContent = result.data.orderCode || "---";
                        }
                        if (successPaymentMethod) {
                            successPaymentMethod.textContent = result.data.paymentMethod || "---";
                        }
                        if (successOrderTotal) {
                            successOrderTotal.textContent = formatVnd(result.data.total);
                        }
                        if (successViewInvoiceBtn && result.data.redirectUrl) {
                            successViewInvoiceBtn.href = result.data.redirectUrl;
                        }
                        if (successModal) {
                            successModal.hidden = false;
                        }
                    } else {
                        if (errorEl) {
                            errorEl.textContent = (result.data && result.data.message) || "Không thể xử lý đơn hàng.";
                            errorEl.hidden = false;
                        }
                        payBtn.disabled = false;
                        payBtn.textContent = "Đặt hàng ngay";
                    }
                })
                .catch(function () {
                    if (errorEl) {
                        errorEl.textContent = "Không thể kết nối máy chủ. Vui lòng thử lại.";
                        errorEl.hidden = false;
                    }
                    payBtn.disabled = false;
                    payBtn.textContent = "Đặt hàng ngay";
                });
        });
    }
});
