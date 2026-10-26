document.addEventListener("DOMContentLoaded", function () {
    var sizeButtons = document.querySelectorAll(".size-box[data-size]");
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
});
