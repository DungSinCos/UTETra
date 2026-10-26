<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản trị</title>
</head>
<body>
<section class="container py-5">
    <h1 class="mb-4">Bảng điều khiển</h1>

    <div class="row g-4">
        <div class="col-md-4">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <div class="text-muted">Sản phẩm đang bán</div>
                    <div class="display-6"><c:out value="${activeProducts}"/></div>
                    <a class="stretched-link" href="${pageContext.request.contextPath}/admin/products">Quản lý sản phẩm</a>
                </div>
            </div>
        </div>
        <%-- Add one card per admin module here (orders, users, branches...) --%>
    </div>
</section>
</body>
</html>
