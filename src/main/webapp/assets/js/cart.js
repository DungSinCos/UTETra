document.addEventListener("DOMContentLoaded", function () {
    var cartList = document.getElementById("cartItemsList");
    var emptyState = document.getElementById("cartEmptyState");
    var countEl = document.querySelector("[data-cart-count]");
    var subtotalEl = document.querySelector("[data-summary-subtotal]");
    var deliveryEl = document.querySelector("[data-summary-delivery]");
    var totalEl = document.querySelector("[data-summary-total]");

    function formatVnd(amount) {
        return Number(amount || 0).toLocaleString("vi-VN") + "đ";
    }

    function updateSummary() {
        var items = cartList ? cartList.querySelectorAll("[data-cart-item]") : [];
        var subtotal = 0;

        items.forEach(function (item) {
            var unitPrice = parseFloat(item.getAttribute("data-unit-price")) || 0;
            var qty = parseInt(item.getAttribute("data-quantity"), 10) || 1;
            subtotal += unitPrice * qty;
        });

        var hasItems = items.length > 0;
        var baseDeliveryFee = deliveryEl ? (parseFloat(deliveryEl.getAttribute("data-delivery-fee")) || 0) : 0;
        var deliveryFee = hasItems ? baseDeliveryFee : 0;
        var total = subtotal + deliveryFee;

        if (countEl) {
            countEl.textContent = items.length;
        }
        if (subtotalEl) {
            subtotalEl.textContent = formatVnd(subtotal);
        }
        if (deliveryEl) {
            deliveryEl.textContent = formatVnd(deliveryFee);
        }
        if (totalEl) {
            totalEl.textContent = formatVnd(total);
        }
        if (emptyState && cartList) {
            emptyState.hidden = hasItems;
            cartList.hidden = !hasItems;
        }
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
                var nextQty = currentQty + 1;
                item.setAttribute("data-quantity", nextQty);
                var qtyValue = item.querySelector("[data-qty-value]");
                if (qtyValue) {
                    qtyValue.textContent = nextQty;
                }
                updateSummary();
            } else if (decreaseBtn) {
                var current = parseInt(item.getAttribute("data-quantity"), 10) || 1;
                if (current > 1) {
                    var prevQty = current - 1;
                    item.setAttribute("data-quantity", prevQty);
                    var qtyEl = item.querySelector("[data-qty-value]");
                    if (qtyEl) {
                        qtyEl.textContent = prevQty;
                    }
                    updateSummary();
                }
            } else if (deleteBtn) {
                item.remove();
                updateSummary();
            }
        });
    }

    updateSummary();
});
