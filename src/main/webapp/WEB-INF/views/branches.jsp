<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Hệ Thống Chi Nhánh</title>
    <meta name="description" content="Danh sách các chi nhánh của chuỗi trà sữa UTETra. Tìm cửa hàng gần bạn nhất!">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/branches.css">
</head>
<body>
<main class="branches-page">

    <!-- Hero Section -->
    <section class="branches-hero">
        <div class="site-container">
            <span class="branches-hero__eyebrow">KHÔNG GIAN THƯỞNG TRÀ UTETRA</span>
            <h1 class="branches-hero__title">Hệ Thống Chi Nhánh</h1>
            <p class="branches-hero__subtitle">
                Trà sữa pha mới mỗi ngày từ lá trà nguyên chất và topping thủ công. 
                Ghé ngay chi nhánh gần bạn nhất hoặc đặt món để tụi mình giao tận nơi!
            </p>
            <div class="branches-hero__counter">
                <span>Tổng số chi nhánh:</span>
                <strong id="totalBranchBadge"><c:out value="${totalBranches}"/></strong>
                <span>cửa hàng đang hoạt động</span>
            </div>
        </div>
    </section>

    <div class="site-container">
        <!-- Search & District Filter Controls -->
        <section class="branches-controls" aria-label="Bộ lọc chi nhánh">
            <div class="branches-search-box">
                <span class="branches-search-icon" aria-hidden="true">
                    <svg class="ut-search-svg" width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <circle cx="10.5" cy="10.5" r="7" fill="#FDF8F3" />
                        <circle cx="10.5" cy="10.5" r="7" stroke="#6F4227" stroke-width="2.2" />
                        <path d="M 7.5 9.2 A 4.5 4.5 0 0 1 11.2 6.2" stroke="#D7A97A" stroke-width="1.8" stroke-linecap="round" />
                        <path d="M 15.8 15.8 L 21 21" stroke="#6F4227" stroke-width="2.6" stroke-linecap="round" />
                    </svg>
                </span>
                <input type="text"
                       id="branchSearchInput"
                       class="branches-search-input"
                       placeholder="Tìm theo tên cửa hàng, đường hoặc quận/huyện..."
                       aria-label="Tìm kiếm chi nhánh">
            </div>

            <div class="branches-filter-pills" role="tablist" aria-label="Lọc theo quận">
                <button type="button"
                        class="branches-filter-pill is-active"
                        data-district="all">
                    Tất cả (<c:out value="${totalBranches}"/>)
                </button>
                <c:forEach var="dist" items="${districts}">
                    <button type="button"
                            class="branches-filter-pill"
                            data-district="${dist}">
                        <c:out value="${dist}"/>
                    </button>
                </c:forEach>
            </div>
        </section>

        <!-- Branch Cards Grid -->
        <section class="branches-grid" id="branchesGrid" aria-label="Danh sách chi nhánh">
            <c:forEach var="branch" items="${branches}">
                <article class="branch-card"
                         data-name="${fn:toLowerCase(branch.name)}"
                         data-code="${fn:toLowerCase(branch.code)}"
                         data-address="${fn:toLowerCase(branch.addressLine)}"
                         data-district="${branch.district}">
                    <div>
                        <div class="branch-card__top">
                            <span class="branch-card__code"><c:out value="${branch.code}"/></span>
                            <span class="branch-card__badge">
                                <span class="branch-card__badge-dot"></span> Đang mở cửa
                            </span>
                        </div>

                        <h2 class="branch-card__name"><c:out value="${branch.name}"/></h2>

                        <div class="branch-card__info-list">
                            <!-- Địa chỉ -->
                            <div class="branch-card__info-item">
                                <span class="branch-card__icon" aria-hidden="true">📍</span>
                                <div class="branch-card__info-content">
                                    <div class="branch-card__info-label">Địa chỉ</div>
                                    <div>
                                        <c:out value="${branch.addressLine}"/>,
                                        <strong><c:out value="${branch.district}"/></strong>,
                                        <c:out value="${branch.city}"/>
                                    </div>
                                </div>
                            </div>

                            <!-- Hotline -->
                            <div class="branch-card__info-item">
                                <span class="branch-card__icon" aria-hidden="true">📞</span>
                                <div class="branch-card__info-content">
                                    <div class="branch-card__info-label">Hotline đặt hàng / tư vấn</div>
                                    <div>
                                        <c:choose>
                                            <c:when test="${not empty branch.phone}">
                                                <a class="branch-card__phone-link" href="tel:${branch.phone}">
                                                    <c:out value="${branch.phone}"/>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">1900 1234 (Tổng đài chung)</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <!-- Giờ mở cửa -->
                            <div class="branch-card__info-item">
                                <span class="branch-card__icon" aria-hidden="true">⏰</span>
                                <div class="branch-card__info-content">
                                    <div class="branch-card__info-label">Thời gian phục vụ</div>
                                    <div>07:00 – 22:30 (Mở cửa cả tuần)</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="branch-card__actions">
                        <c:choose>
                            <c:when test="${not empty branch.phone}">
                                <a class="branch-card__btn branch-card__btn--outline" href="tel:${branch.phone}">
                                    <span>📞</span> Gọi điện
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a class="branch-card__btn branch-card__btn--outline" href="tel:19001234">
                                    <span>📞</span> Gọi tổng đài
                                </a>
                            </c:otherwise>
                        </c:choose>
                        <a class="branch-card__btn branch-card__btn--primary" href="${pageContext.request.contextPath}/products">
                            <span>🧋</span> Đặt món
                        </a>
                    </div>
                </article>
            </c:forEach>

            <!-- Trạng thái khi không tìm thấy kết quả -->
            <div class="branches-empty" id="branchesEmpty">
                <div class="branches-empty__icon">🔍</div>
                <h3 class="branches-empty__title">Không tìm thấy chi nhánh nào</h3>
                <p class="branches-empty__desc">
                    Vui lòng thử tìm kiếm với từ khóa khác hoặc bấm chọn "Tất cả" để xem toàn bộ chi nhánh.
                </p>
            </div>
        </section>

        <!-- Store Highlights Bar -->
        <section class="branches-highlights">
            <div class="branches-highlights__heading">
                <h3>Tiện Ích Tại Cửa Hàng UTETra</h3>
                <p>Tụi mình luôn nỗ lực để mỗi lần ghé quán của bạn đều thoải mái và trọn vẹn nhất.</p>
            </div>
            <div class="branches-highlights__grid">
                <div class="branches-highlight-item">
                    <div class="branches-highlight-item__icon">❄️</div>
                    <div class="branches-highlight-item__text">
                        <h4>Không gian mát mẻ</h4>
                        <p>Máy lạnh 24/7, chỗ ngồi rộng rãi học tập và làm việc.</p>
                    </div>
                </div>
                <div class="branches-highlight-item">
                    <div class="branches-highlight-item__icon">📶</div>
                    <div class="branches-highlight-item__text">
                        <h4>Wi-Fi tốc độ cao</h4>
                        <p>Kết nối internet mượt mà, ổ cắm điện tiện lợi.</p>
                    </div>
                </div>
                <div class="branches-highlight-item">
                    <div class="branches-highlight-item__icon">🛵</div>
                    <div class="branches-highlight-item__text">
                        <h4>Giữ xe an toàn</h4>
                        <p>Bãi đỗ xe có người trông coi hoàn toàn miễn phí.</p>
                    </div>
                </div>
                <div class="branches-highlight-item">
                    <div class="branches-highlight-item__icon">💳</div>
                    <div class="branches-highlight-item__text">
                        <h4>Thanh toán tiện lợi</h4>
                        <p>Hỗ trợ tiền mặt, VNPay, chuyển khoản ngân hàng và thẻ.</p>
                    </div>
                </div>
            </div>
        </section>
    </div>

</main>

<!-- Client-side Fast Filtering & Search Script -->
<script>
document.addEventListener("DOMContentLoaded", function () {
    var searchInput = document.getElementById("branchSearchInput");
    var filterPills = document.querySelectorAll(".branches-filter-pill");
    var cards = document.querySelectorAll(".branch-card");
    var emptyBox = document.getElementById("branchesEmpty");
    var currentDistrict = "all";

    function filterBranches() {
        var query = (searchInput.value || "").trim().toLowerCase();
        var visibleCount = 0;

        cards.forEach(function (card) {
            var name = card.getAttribute("data-name") || "";
            var code = card.getAttribute("data-code") || "";
            var address = card.getAttribute("data-address") || "";
            var district = card.getAttribute("data-district") || "";

            var matchesDistrict = (currentDistrict === "all") || (district === currentDistrict);
            var matchesQuery = !query || 
                name.indexOf(query) !== -1 || 
                code.indexOf(query) !== -1 || 
                address.indexOf(query) !== -1 || 
                district.toLowerCase().indexOf(query) !== -1;

            if (matchesDistrict && matchesQuery) {
                card.style.display = "";
                visibleCount++;
            } else {
                card.style.display = "none";
            }
        });

        if (emptyBox) {
            emptyBox.style.display = (visibleCount === 0) ? "block" : "none";
        }
    }

    if (searchInput) {
        searchInput.addEventListener("input", filterBranches);
    }

    filterPills.forEach(function (pill) {
        pill.addEventListener("click", function () {
            filterPills.forEach(function (p) { p.classList.remove("is-active"); });
            pill.classList.add("is-active");
            currentDistrict = pill.getAttribute("data-district") || "all";
            filterBranches();
        });
    });
});
</script>
</body>
</html>
