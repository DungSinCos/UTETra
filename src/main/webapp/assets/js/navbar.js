document.addEventListener("DOMContentLoaded", function () {
    var toggle = document.querySelector("[data-nav-toggle]");
    var collapse = document.querySelector("[data-nav-collapse]");

    if (toggle && collapse) {
        toggle.addEventListener("click", function () {
            var open = collapse.classList.toggle("is-open");
            toggle.classList.toggle("is-open", open);
            toggle.setAttribute("aria-expanded", open ? "true" : "false");
        });
    }

    var brand = document.querySelector(".brand");
    var base = brand ? new URL(brand.href).pathname.replace(/\/$/, "") : "";
    var current = window.location.pathname.substring(base.length).replace(/\/$/, "") || "/";
    if (current === "/home") {
        current = "/";
    }

    document.querySelectorAll(".nav-item[data-path]").forEach(function (link) {
        var path = link.getAttribute("data-path");
        var match = path === "/" ? current === "/" : current === path || current.indexOf(path + "/") === 0;
        link.classList.toggle("is-active", match);
    });

    var popupTimer = null;

    function getOrCreateCartPopup() {
        var popup = document.getElementById("cartPopupNotification");
        if (popup) {
            return popup;
        }
        popup = document.createElement("div");
        popup.id = "cartPopupNotification";
        popup.className = "cart-popup";
        popup.setAttribute("role", "status");
        popup.setAttribute("aria-live", "polite");
        popup.innerHTML =
            '<span class="cart-popup__icon" data-popup-icon>\u2713</span>' +
            '<div class="cart-popup__body">' +
                '<p class="cart-popup__title" data-popup-title></p>' +
                '<p class="cart-popup__msg" data-popup-msg></p>' +
                '<a class="cart-popup__link" href="' + base + '/cart" data-popup-link>Xem giỏ hàng &rarr;</a>' +
            '</div>' +
            '<button type="button" class="cart-popup__close" aria-label="Đóng thông báo" data-popup-close>&times;</button>';

        popup.querySelector("[data-popup-close]").addEventListener("click", function () {
            popup.classList.remove("is-visible");
        });

        document.body.appendChild(popup);
        return popup;
    }

    window.showCartPopup = function (opts) {
        var popup = getOrCreateCartPopup();
        var iconEl = popup.querySelector("[data-popup-icon]");
        var titleEl = popup.querySelector("[data-popup-title]");
        var msgEl = popup.querySelector("[data-popup-msg]");
        var linkEl = popup.querySelector("[data-popup-link]");

        var isError = Boolean(opts && opts.error);
        popup.classList.toggle("is-error", isError);
        if (iconEl) {
            iconEl.textContent = isError ? "!" : "\u2713";
        }
        if (titleEl) {
            titleEl.textContent = (opts && opts.title) || (isError ? "Không thể thêm vào giỏ" : "Đã thêm vào giỏ hàng!");
        }
        if (msgEl) {
            msgEl.textContent = (opts && opts.message) || "";
        }
        if (linkEl) {
            linkEl.hidden = isError;
        }

        popup.classList.add("is-visible");
        if (popupTimer) {
            clearTimeout(popupTimer);
        }
        popupTimer = setTimeout(function () {
            popup.classList.remove("is-visible");
        }, 3500);
    };

    // Global delegated handler for "+" (.product-add[data-add-to-cart]) in product-card component
    document.addEventListener("click", function (e) {
        var addBtn = e.target.closest("[data-add-to-cart]");
        if (!addBtn) {
            return;
        }
        e.preventDefault();
        e.stopPropagation();

        if (addBtn.disabled) {
            return;
        }

        var productId = addBtn.getAttribute("data-add-to-cart");
        if (!productId) {
            return;
        }

        var card = addBtn.closest("[data-product-card]");
        var fallbackName = addBtn.getAttribute("data-product-name") ||
            (card ? card.getAttribute("data-name") : "") ||
            "Sản phẩm";

        addBtn.disabled = true;
        var body = new URLSearchParams();
        body.append("productId", productId);
        body.append("size", "S");
        body.append("quantity", "1");

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
                    var pName = result.data.productName || fallbackName;
                    var qty = result.data.itemQuantity || 1;
                    window.showCartPopup({
                        title: "Đã thêm vào giỏ hàng!",
                        message: pName + " (Size S) đã có trong giỏ hàng (SL: " + qty + ")."
                    });

                    addBtn.textContent = "\u2713";
                    addBtn.classList.add("is-added");
                    setTimeout(function () {
                        addBtn.textContent = "+";
                        addBtn.classList.remove("is-added");
                        addBtn.disabled = false;
                    }, 750);
                } else {
                    window.showCartPopup({
                        error: true,
                        title: "Không thể thêm vào giỏ",
                        message: (result.data && result.data.message) || "Đã có lỗi xảy ra."
                    });
                    addBtn.disabled = false;
                }
            })
            .catch(function () {
                window.showCartPopup({
                    error: true,
                    title: "Không thể thêm vào giỏ",
                    message: "Không thể kết nối máy chủ."
                });
                addBtn.disabled = false;
            });
    }, true);
});
