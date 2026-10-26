document.addEventListener("DOMContentLoaded", function () {
    /**
     * Client-side mocked products using the product data from homepage.jsp (IDs 1..5).
     */
    var MOCK_PRODUCTS = [
        {
            id: 1,
            name: "Trà Sữa Trân Châu Đường Đen",
            desc: "Sữa tươi béo ngậy hòa quyện cùng trân châu đường đen dẻo thơm.",
            price: "45.000đ",
            image: "https://images.unsplash.com/photo-1525385133512-2f3bdd039054?auto=format&fit=crop&w=600&q=80",
            badge: "Bán chạy",
            badgeClass: "",
            category: "tra-sua"
        },
        {
            id: 2,
            name: "Trà Oolong Kem Cheese",
            desc: "Oolong rang thơm nồng phủ lớp kem cheese mặn mịn béo.",
            price: "49.000đ",
            image: "https://images.unsplash.com/photo-1541696490-8744a5dc0228?auto=format&fit=crop&w=600&q=80",
            badge: "Mới",
            badgeClass: "product-badge--new",
            category: "kem-cheese"
        },
        {
            id: 3,
            name: "Matcha Latte Đậu Đỏ",
            desc: "Matcha Uji Nhật Bản kết hợp đậu đỏ ninh mềm ngọt dịu.",
            price: "52.000đ",
            image: "https://images.unsplash.com/photo-1515823064-d6e0c04616a7?auto=format&fit=crop&w=600&q=80",
            badge: "",
            badgeClass: "",
            category: "matcha-latte"
        },
        {
            id: 4,
            name: "Trà Đào Cam Sả",
            desc: "Trà đen thanh mát cùng đào miếng, cam tươi và sả thơm.",
            price: "42.000đ",
            image: "https://images.unsplash.com/photo-1556679343-c7306c1976bc?auto=format&fit=crop&w=600&q=80",
            badge: "Bán chạy",
            badgeClass: "",
            category: "tra-trai-cay"
        },
        {
            id: 5,
            name: "Trà Sữa Oolong Kem Cheese",
            desc: "Lá trà nguyên chất, sữa tươi thanh trùng cùng trân châu nấu thủ công mỗi sáng.",
            price: "55.000đ",
            image: "https://images.unsplash.com/photo-1558857563-b371033873b8?auto=format&fit=crop&w=800&q=80",
            badge: "Mới",
            badgeClass: "product-badge--new",
            category: "tra-sua"
        }
    ];

    var ITEMS_PER_PAGE = 4;
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

    var contextPath = grid.getAttribute("data-context-path") || "";

    // Ensure all items in MOCK_PRODUCTS exist in the DOM (in case new mock items are added here)
    MOCK_PRODUCTS.forEach(function (item) {
        var existing = grid.querySelector('[data-product-id="' + item.id + '"]');
        if (!existing) {
            grid.appendChild(createProductCardElement(item));
        }
    });

    var allCards = Array.prototype.slice.call(grid.querySelectorAll("[data-product-card]"));

    function normalizeText(str) {
        return (str || "")
            .toLowerCase()
            .normalize("NFD")
            .replace(/[\u0300-\u036f]/g, "")
            .replace(/đ/g, "d");
    }

    function createProductCardElement(item) {
        var detailUrl = contextPath + "/products/" + item.id;
        var article = document.createElement("article");
        article.className = "product-item";
        article.id = "product-" + item.id;
        article.setAttribute("data-product-card", "");
        article.setAttribute("data-product-id", String(item.id));
        article.setAttribute("data-category", item.category);
        article.setAttribute("data-name", item.name);
        article.setAttribute("data-price", item.price);
        article.setAttribute("role", "link");
        article.setAttribute("tabindex", "0");
        article.addEventListener("click", function () {
            window.location.href = detailUrl;
        });
        article.addEventListener("keydown", function (e) {
            if (e.key === "Enter" || e.key === " ") {
                e.preventDefault();
                window.location.href = detailUrl;
            }
        });

        var badgeClass = "product-badge" + (item.badgeClass ? " " + item.badgeClass : "");
        article.innerHTML =
            '<div class="product-thumb">' +
                (item.badge ? '<span class="' + badgeClass + '">' + item.badge + '</span>' : '') +
                '<img src="' + item.image + '" alt="' + item.name + '" loading="lazy">' +
            '</div>' +
            '<div class="product-body">' +
                '<h3 class="product-name">' + item.name + '</h3>' +
                '<p class="product-desc">' + item.desc + '</p>' +
                '<div class="product-footer">' +
                    '<span class="product-price">' + item.price + '</span>' +
                    '<a class="product-add" href="' + detailUrl + '" aria-label="Xem chi tiết ' + item.name + '">+</a>' +
                '</div>' +
            '</div>';
        return article;
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
