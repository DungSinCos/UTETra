document.addEventListener("DOMContentLoaded", function () {
    var cartPage = document.querySelector(".cart-page");
    var contextPath = cartPage ? (cartPage.getAttribute("data-context-path") || "") : "";
    var cartList = document.getElementById("cartItemsList");
    var emptyState = document.getElementById("cartEmptyState");
    var countEl = document.querySelector("[data-cart-count]");
    var subtotalEl = document.querySelector("[data-summary-subtotal]");
    var deliveryEl = document.querySelector("[data-summary-delivery]");
    var totalEl = document.querySelector("[data-summary-total]");
    var checkoutBtn = document.querySelector("[data-checkout-btn]");

    function formatVnd(amount) {
        return Number(amount || 0).toLocaleString("vi-VN") + "đ";
    }

    function syncCheckoutState(hasItems) {
        if (!checkoutBtn) {
            return;
        }
        checkoutBtn.classList.toggle("is-disabled", !hasItems);
        checkoutBtn.setAttribute("aria-disabled", hasItems ? "false" : "true");
    }

    function applyServerSummary(data) {
        var itemCount = typeof data.itemCount === "number"
            ? data.itemCount
            : (cartList ? cartList.querySelectorAll("[data-cart-item]").length : 0);
        var hasItems = itemCount > 0;

        if (countEl) {
            countEl.textContent = itemCount;
        }
        if (subtotalEl && typeof data.subtotal === "number") {
            subtotalEl.textContent = formatVnd(data.subtotal);
        }
        if (deliveryEl && typeof data.deliveryFee === "number") {
            deliveryEl.textContent = formatVnd(data.deliveryFee);
        }
        if (totalEl && typeof data.total === "number") {
            totalEl.textContent = formatVnd(data.total);
        }
        if (emptyState && cartList) {
            emptyState.hidden = hasItems;
            cartList.hidden = !hasItems;
        }
        syncCheckoutState(hasItems);
    }

    function updateItemQuantityInDb(item, nextQty) {
        var itemId = item.getAttribute("data-item-id");
        if (!itemId || item.getAttribute("data-busy") === "true") {
            return;
        }
        item.setAttribute("data-busy", "true");

        var body = new URLSearchParams();
        body.append("quantity", String(nextQty));

        fetch(contextPath + "/cart/items/" + encodeURIComponent(itemId) + "/quantity", {
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
                item.removeAttribute("data-busy");
                if (result.status === 401 || (result.data && result.data.redirectUrl)) {
                    window.location.href = result.data.redirectUrl || (contextPath + "/login");
                    return;
                }
                if (result.data && result.data.success) {
                    var confirmedQty = typeof result.data.itemQuantity === "number" ? result.data.itemQuantity : nextQty;
                    item.setAttribute("data-quantity", confirmedQty);
                    var qtyEl = item.querySelector("[data-qty-value]");
                    if (qtyEl) {
                        qtyEl.textContent = confirmedQty;
                    }
                    applyServerSummary(result.data);
                }
            })
            .catch(function () {
                item.removeAttribute("data-busy");
            });
    }

    function removeItemFromDb(item) {
        var itemId = item.getAttribute("data-item-id");
        if (!itemId || item.getAttribute("data-busy") === "true") {
            return;
        }
        item.setAttribute("data-busy", "true");

        fetch(contextPath + "/cart/items/" + encodeURIComponent(itemId) + "/delete", {
            method: "POST",
            headers: {
                "Accept": "application/json"
            }
        })
            .then(function (res) {
                return res.json().then(function (data) {
                    return { status: res.status, data: data };
                });
            })
            .then(function (result) {
                if (result.status === 401 || (result.data && result.data.redirectUrl)) {
                    window.location.href = result.data.redirectUrl || (contextPath + "/login");
                    return;
                }
                if (result.data && result.data.success) {
                    item.remove();
                    applyServerSummary(result.data);
                } else {
                    item.removeAttribute("data-busy");
                }
            })
            .catch(function () {
                item.removeAttribute("data-busy");
            });
    }

    if (cartList) {
        cartList.addEventListener("click", function (e) {
            var increaseBtn = e.target.closest("[data-qty-increase]");
            var decreaseBtn = e.target.closest("[data-qty-decrease]");
            var deleteBtn = e.target.closest("[data-item-delete]");
            var item = e.target.closest("[data-cart-item]");

            if (!item) {
                return;
            }

            if (increaseBtn) {
                var currentQty = parseInt(item.getAttribute("data-quantity"), 10) || 1;
                updateItemQuantityInDb(item, currentQty + 1);
            } else if (decreaseBtn) {
                var current = parseInt(item.getAttribute("data-quantity"), 10) || 1;
                if (current > 1) {
                    updateItemQuantityInDb(item, current - 1);
                }
            } else if (deleteBtn) {
                removeItemFromDb(item);
            }
        });
    }

    if (checkoutBtn) {
        checkoutBtn.addEventListener("click", function (e) {
            if (checkoutBtn.classList.contains("is-disabled") || checkoutBtn.getAttribute("aria-disabled") === "true") {
                e.preventDefault();
            }
        });
    }
});
