<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>${empty product.id ? 'Thêm sản phẩm' : 'Sửa sản phẩm'}</title>
</head>
<body>
<section class="container py-5" style="max-width:720px">
    <h1 class="mb-4">${empty product.id ? 'Thêm sản phẩm' : 'Sửa sản phẩm'}</h1>

    <c:if test="${not empty error}">
        <div class="alert alert-danger"><c:out value="${error}"/></div>
    </c:if>

    <form method="post" enctype="multipart/form-data"
          action="${pageContext.request.contextPath}${formAction}">

        <div class="mb-3">
            <label class="form-label" for="name">Tên sản phẩm</label>
            <input class="form-control" id="name" name="name" value="<c:out value='${product.name}'/>" required maxlength="150">
        </div>

        <div class="row">
            <div class="col-md-6 mb-3">
                <label class="form-label" for="sku">SKU</label>
                <%-- SKU is fixed after creation: it is referenced by orders --%>
                <input class="form-control" id="sku" name="sku" value="<c:out value='${product.sku}'/>"
                       required maxlength="50" ${empty product.id ? '' : 'readonly'}>
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label" for="categoryId">Mã danh mục</label>
                <%-- TODO: replace with a <select> once the Category module exists --%>
                <input class="form-control" type="number" min="1" id="categoryId" name="categoryId"
                       value="<c:out value='${product.categoryId}'/>" required>
            </div>
        </div>

        <c:if test="${empty product.id}">
            <div class="mb-3">
                <label class="form-label" for="slug">Slug <span class="text-muted">(để trống để tự tạo từ tên)</span></label>
                <input class="form-control" id="slug" name="slug" value="<c:out value='${product.slug}'/>" maxlength="180">
            </div>
        </c:if>

        <div class="mb-3">
            <label class="form-label" for="basePrice">Giá gốc (đ)</label>
            <input class="form-control" type="number" min="0" step="1000" id="basePrice" name="basePrice"
                   value="<c:out value='${product.basePrice}'/>" required>
        </div>

        <div class="mb-3">
            <label class="form-label" for="description">Mô tả</label>
            <textarea class="form-control" id="description" name="description" rows="4"><c:out value="${product.description}"/></textarea>
        </div>

        <div class="mb-3">
            <label class="form-label" for="image">Ảnh sản phẩm</label>
            <c:if test="${not empty product.imageUrl}">
                <div class="mb-2">
                    <img src="<c:out value='${product.imageUrl}'/>" alt="" width="96" height="96" style="object-fit:cover" class="rounded">
                    <div class="form-text">Chọn ảnh mới để thay thế ảnh hiện tại.</div>
                </div>
            </c:if>
            <input class="form-control" type="file" id="image" name="image" accept="image/jpeg,image/png,image/webp,image/gif">
        </div>

        <%-- "_field" markers tell Spring to bind false when the checkbox is unticked (browsers send nothing) --%>
        <input type="hidden" name="_featured" value="on">
        <input type="hidden" name="_active" value="on">

        <div class="form-check mb-2">
            <input class="form-check-input" type="checkbox" id="featured" name="featured" value="true" ${product.featured ? 'checked' : ''}>
            <label class="form-check-label" for="featured">Sản phẩm nổi bật</label>
        </div>
        <div class="form-check mb-4">
            <input class="form-check-input" type="checkbox" id="active" name="active" value="true"
                   ${empty product.id or product.active ? 'checked' : ''}>
            <label class="form-check-label" for="active">Đang bán</label>
        </div>

        <button class="btn btn-primary" type="submit">Lưu</button>
        <a class="btn btn-link" href="${pageContext.request.contextPath}/admin/products">Hủy</a>
    </form>
</section>
</body>
</html>
