document.addEventListener("DOMContentLoaded", function () {
    var MAX_ROWS = 5;
    var COLUMNS_PER_ROW = 4;
    var ITEMS_PER_PAGE = MAX_ROWS * COLUMNS_PER_ROW; // Max 5 rows per page (20 products)
    var activeCategory = "all";
    var searchQuery = "";
    var currentPage = 1;

    var grid = document.getElementById("productsGrid");
    var categoryButtons = document.querySelectorAll("[data-category-btn]");
    var searchInput = document.getElementById("productSearchInput");
    var countLabel = document.getElementById("productsCountLabel");
    var emptyState = document.getElementById("productsEmptyState");
    var resetFilterBtn = document.getElementById("resetFilterBtn");
    var paginationList = document.getElementById("productsPagination");

    if (!grid) {
        return;
    }

    var allCards = Array.prototype.slice.call(grid.querySelectorAll("[data-product-card]"));

    function normalizeText(str) {
        return (str || "")
            .toLowerCase()
            .normalize("NFD")
            .replace(/[\u0300-\u036f]/g, "")
            .replace(/đ/g, "d");
    }

    function getFilteredCards() {
        var normalizedQuery = normalizeText(searchQuery.trim());
        return allCards.filter(function (card) {
            var cardCategory = card.getAttribute("data-category") || "";
            var cardName = card.getAttribute("data-name") || "";
            var matchesCategory = activeCategory === "all" || cardCategory === activeCategory;
            var matchesSearch = !normalizedQuery || normalizeText(cardName).indexOf(normalizedQuery) !== -1;
            return matchesCategory && matchesSearch;
        });
    }

    function renderPagination(totalPages) {
        if (!paginationList) {
            return;
        }
        paginationList.innerHTML = "";

        if (totalPages <= 0) {
            return;
        }

        // Previous button
        var prevLi = document.createElement("li");
        var prevBtn = document.createElement("button");
        prevBtn.type = "button";
        prevBtn.className = "page-btn page-btn--nav";
        prevBtn.disabled = currentPage <= 1;
        prevBtn.setAttribute("aria-label", "Trang trước");
        prevBtn.innerHTML = "&lsaquo; Trước";
        prevBtn.addEventListener("click", function () {
            if (currentPage > 1) {
                currentPage--;
                updateView();
            }
        });
        prevLi.appendChild(prevBtn);
        paginationList.appendChild(prevLi);

        // Numbered page buttons
        for (var i = 1; i <= totalPages; i++) {
            (function (pageNum) {
                var li = document.createElement("li");
                var btn = document.createElement("button");
                btn.type = "button";
                btn.className = "page-btn" + (pageNum === currentPage ? " is-active" : "");
                if (pageNum === currentPage) {
                    btn.setAttribute("aria-current", "page");
                }
                btn.textContent = String(pageNum);
                btn.addEventListener("click", function () {
                    if (currentPage !== pageNum) {
                        currentPage = pageNum;
                        updateView();
                    }
                });
                li.appendChild(btn);
                paginationList.appendChild(li);
            })(i);
        }

        // Next button
        var nextLi = document.createElement("li");
        var nextBtn = document.createElement("button");
        nextBtn.type = "button";
        nextBtn.className = "page-btn page-btn--nav";
        nextBtn.disabled = currentPage >= totalPages;
        nextBtn.setAttribute("aria-label", "Trang sau");
        nextBtn.innerHTML = "Sau &rsaquo;";
        nextBtn.addEventListener("click", function () {
            if (currentPage < totalPages) {
                currentPage++;
                updateView();
            }
        });
        nextLi.appendChild(nextBtn);
        paginationList.appendChild(nextLi);
    }

    function updateView() {
        var filtered = getFilteredCards();
        var totalItems = filtered.length;
        var totalPages = Math.max(1, Math.ceil(totalItems / ITEMS_PER_PAGE));

        if (currentPage > totalPages) {
            currentPage = totalPages;
        }

        var startIndex = (currentPage - 1) * ITEMS_PER_PAGE;
        var endIndex = startIndex + ITEMS_PER_PAGE;
        var visibleSet = filtered.slice(startIndex, endIndex);

        allCards.forEach(function (card) {
            var isVisible = visibleSet.indexOf(card) !== -1;
            card.classList.toggle("is-hidden", !isVisible);
        });

        if (countLabel) {
            countLabel.innerHTML = "Hiển thị <strong>" + totalItems + "</strong> sản phẩm";
        }

        if (emptyState) {
            emptyState.hidden = totalItems > 0;
        }

        renderPagination(totalItems > 0 ? totalPages : 0);
    }

    // Bind category filter buttons
    categoryButtons.forEach(function (btn) {
        btn.addEventListener("click", function () {
            activeCategory = btn.getAttribute("data-category-btn") || "all";
            currentPage = 1;

            categoryButtons.forEach(function (b) {
                var selected = b === btn;
                b.classList.toggle("is-active", selected);
                b.setAttribute("aria-selected", selected ? "true" : "false");
            });

            updateView();
        });
    });

    // Bind search input
    if (searchInput) {
        searchInput.addEventListener("input", function () {
            searchQuery = searchInput.value || "";
            currentPage = 1;
            updateView();
        });
    }

    // Bind reset button
    if (resetFilterBtn) {
        resetFilterBtn.addEventListener("click", function () {
            activeCategory = "all";
            searchQuery = "";
            currentPage = 1;
            if (searchInput) {
                searchInput.value = "";
            }
            categoryButtons.forEach(function (b) {
                var selected = b.getAttribute("data-category-btn") === "all";
                b.classList.toggle("is-active", selected);
                b.setAttribute("aria-selected", selected ? "true" : "false");
            });
            updateView();
        });
    }

    // Initial render
    updateView();
});
