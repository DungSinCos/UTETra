<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>${empty category.id ? 'Thêm danh mục' : 'Sửa danh mục'}</title>
</head>
<body>
<section class="container py-5" style="max-width:720px">
    <h1 class="mb-4">${empty category.id ? 'Thêm danh mục' : 'Sửa danh mục'}</h1>

    <c:if test="${not empty error}">
        <div class="alert alert-danger"><c:out value="${error}"/></div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}${formAction}">
        <div class="mb-3">
            <label class="form-label" for="name">Tên danh mục</label>
            <input class="form-control" id="name" name="name" value="<c:out value='${category.name}'/>"
                   maxlength="100" required>
        </div>
        <div class="mb-3">
            <label class="form-label" for="slug">Slug <span class="text-muted">(để trống để tự tạo)</span></label>
            <input class="form-control" id="slug" name="slug" value="<c:out value='${category.slug}'/>" maxlength="120">
        </div>
        <div class="mb-3">
            <label class="form-label" for="description">Mô tả</label>
            <textarea class="form-control" id="description" name="description" maxlength="255" rows="3"><c:out value="${category.description}"/></textarea>
        </div>
        <div class="mb-3">
            <label class="form-label" for="imageUrl">URL ảnh (không bắt buộc)</label>
            <input class="form-control" type="url" id="imageUrl" name="imageUrl"
                   value="<c:out value='${category.imageUrl}'/>" maxlength="500">
        </div>
        <div class="mb-4">
            <label class="form-label" for="displayOrder">Thứ tự hiển thị</label>
            <input class="form-control" type="number" id="displayOrder" name="displayOrder"
                   min="0" value="${category.displayOrder}" required>
        </div>
        <button class="btn btn-primary" type="submit">Lưu</button>
        <a class="btn btn-link" href="${pageContext.request.contextPath}/admin/categories">Hủy</a>
    </form>
</section>
</body>
</html>
