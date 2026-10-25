<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html>
<head>
    <title>Sản phẩm</title>
</head>
<body>
    <div class="container py-4">
        <h1 class="h3 mb-3">Thực đơn</h1>

        <!-- Lọc theo loại -->
        <div class="category-pills d-flex flex-wrap gap-2 mb-4">
            <a href="${pageContext.request.contextPath}/products"
               class="btn btn-sm ${empty currentCategory ? 'btn-brand' : 'btn-outline-brand'}">Tất cả</a>
            <c:forEach var="cat" items="${categories}">
                <a href="${pageContext.request.contextPath}/products?category=${cat}"
                   class="btn btn-sm ${currentCategory eq cat ? 'btn-brand' : 'btn-outline-brand'}">${cat}</a>
            </c:forEach>
        </div>

        <c:if test="${empty products}">
            <p class="text-secondary">Chưa có sản phẩm nào.</p>
        </c:if>

        <!-- Grid sản phẩm -->
        <div class="row row-cols-2 row-cols-md-3 row-cols-lg-4 g-3">
            <c:forEach var="p" items="${products}">
                <div class="col">
                    <div class="card product-card h-100">
                        <div class="product-thumb">${p.icon}</div>
                        <div class="card-body d-flex flex-column">
                            <small class="text-secondary">${p.category}</small>
                            <h2 class="h6 mt-1"><c:out value="${p.name}"/></h2>
                            <p class="small text-secondary flex-grow-1"><c:out value="${p.description}"/></p>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="product-price">
                                    <fmt:formatNumber value="${p.price}" pattern="#,###"/>đ
                                </span>
                                <%-- nút giỏ hàng: nối với chức năng của person khác sau --%>
                                <button type="button" class="btn btn-sm btn-brand">Thêm</button>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</body>
</html>
