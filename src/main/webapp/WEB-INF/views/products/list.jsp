<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Thực đơn</title>
</head>
<body>
<section class="container py-5">
    <h1 class="mb-4">Thực đơn</h1>

    <c:choose>
        <c:when test="${empty products}">
            <p class="text-muted">Hiện chưa có sản phẩm nào.</p>
        </c:when>
        <c:otherwise>
            <div class="row g-4">
                <c:forEach var="p" items="${products}">
                    <div class="col-6 col-md-4 col-lg-3">
                        <div class="card h-100 shadow-sm">
                            <c:if test="${not empty p.imageUrl}">
                                <img src="<c:out value='${p.imageUrl}'/>" class="card-img-top"
                                     alt="<c:out value='${p.name}'/>" style="aspect-ratio:1/1;object-fit:cover">
                            </c:if>
                            <div class="card-body">
                                <h2 class="h6 card-title"><c:out value="${p.name}"/></h2>
                                <p class="card-text fw-semibold">
                                    <fmt:formatNumber value="${p.basePrice}" type="number" maxFractionDigits="0"/> đ
                                </p>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</section>
</body>
</html>
