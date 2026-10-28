document.addEventListener("DOMContentLoaded", function () {
    var sizeButtons = document.querySelectorAll(".size-box[data-size]");
    var branchButtons = document.querySelectorAll(".branch-box[data-branch-id]");
    var priceEl = document.getElementById("detailProductPrice");
    var basePrice = priceEl ? parseInt(priceEl.getAttribute("data-base-price"), 10) || 0 : 0;

    function formatVnd(amount) {
        return amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".") + "đ";
    }

    sizeButtons.forEach(function (btn) {
        btn.addEventListener("click", function () {
            sizeButtons.forEach(function (b) {
                var selected = b === btn;
                b.classList.toggle("is-selected", selected);
                b.setAttribute("aria-checked", selected ? "true" : "false");
            });

            if (priceEl && basePrice > 0) {
                var extra = parseInt(btn.getAttribute("data-extra-price"), 10) || 0;
                priceEl.textContent = formatVnd(basePrice + extra);
            }
        });
    });

    branchButtons.forEach(function (btn) {
        btn.addEventListener("click", function () {
            if (btn.disabled) {
                return;
            }
            branchButtons.forEach(function (b) {
                var selected = b === btn;
                b.classList.toggle("is-selected", selected);
                b.setAttribute("aria-checked", selected ? "true" : "false");
            });
        });
    });

    var addToCartBtn = document.getElementById("addToCartBtn");
    var buyNowBtn = document.getElementById("buyNowBtn");
    var brand = document.querySelector(".brand");
    var base = brand ? new URL(brand.href).pathname.replace(/\/$/, "") : "";

    function sendAddToCart(btn, redirectToCart) {
        var productId = btn.getAttribute("data-product-id");
        if (!productId || btn.disabled) {
            return;
        }
        var selectedSizeBtn = document.querySelector(".size-box.is-selected[data-size]");
        var selectedBranchBtn = document.querySelector(".branch-box.is-selected[data-branch-id]");
        var size = selectedSizeBtn ? selectedSizeBtn.getAttribute("data-size") : "S";
        var branchId = selectedBranchBtn ? selectedBranchBtn.getAttribute("data-branch-id") : "";

        btn.disabled = true;
        var body = new URLSearchParams();
        body.append("productId", productId);
        body.append("size", size);
        body.append("quantity", "1");
        if (branchId) {
            body.append("branchId", branchId);
        }

        fetch(base + "/cart/items", {
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
                if (result.status === 401 || (result.data && result.data.redirectUrl)) {
                    window.location.href = result.data.redirectUrl || (base + "/login");
                    return;
                }
                if (result.data && result.data.success) {
                    if (redirectToCart) {
                        window.location.href = base + "/cart";
                        return;
                    }
                    var nameEl = document.getElementById("detailProductName");
                    var pName = result.data.productName || (nameEl ? nameEl.textContent : "Sản phẩm");
                    var qty = result.data.itemQuantity || 1;
                    if (typeof window.showCartPopup === "function") {
                        window.showCartPopup({
                            title: "Đã thêm vào giỏ hàng!",
                            message: pName + " (Size " + size + ") đã có trong giỏ hàng (SL: " + qty + ")."
                        });
                    }
                    var originalText = btn.textContent;
                    btn.textContent = "Đã thêm vào giỏ \u2713";
                    setTimeout(function () {
                        btn.textContent = originalText;
                        btn.disabled = false;
                    }, 900);
                } else {
                    if (typeof window.showCartPopup === "function") {
                        window.showCartPopup({
                            error: true,
                            title: "Không thể thêm vào giỏ",
                            message: (result.data && result.data.message) || "Đã có lỗi xảy ra."
                        });
                    }
                    btn.disabled = false;
                }
            })
            .catch(function () {
                if (typeof window.showCartPopup === "function") {
                    window.showCartPopup({
                        error: true,
                        title: "Không thể thêm vào giỏ",
                        message: "Không thể kết nối máy chủ."
                    });
                }
                btn.disabled = false;
            });
    }

    if (addToCartBtn) {
        addToCartBtn.addEventListener("click", function () {
            sendAddToCart(addToCartBtn, false);
        });
    }
    if (buyNowBtn) {
        buyNowBtn.addEventListener("click", function () {
            var productId = buyNowBtn.getAttribute("data-product-id");
            if (!productId) {
                return;
            }
            var selectedSizeBtn = document.querySelector(".size-box.is-selected[data-size]");
            var selectedBranchBtn = document.querySelector(".branch-box.is-selected[data-branch-id]");
            var size = selectedSizeBtn ? selectedSizeBtn.getAttribute("data-size") : "S";
            var branchId = selectedBranchBtn ? selectedBranchBtn.getAttribute("data-branch-id") : "";

            var params = new URLSearchParams();
            params.append("productId", productId);
            params.append("size", size);
            params.append("quantity", "1");
            if (branchId) {
                params.append("branchId", branchId);
            }
            window.location.href = base + "/checkout?" + params.toString();
        });
    }
});
