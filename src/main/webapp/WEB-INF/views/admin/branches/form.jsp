<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>${empty branch.id ? 'Thêm chi nhánh mới' : 'Cập nhật chi nhánh'} - UTETra</title>
</head>
<body>
<section class="container py-5" style="max-width: 760px">
    <div class="d-flex align-items-center gap-2 mb-4">
        <a href="${pageContext.request.contextPath}/admin/branches" class="btn btn-sm btn-outline-secondary">&larr; Quay lại danh sách</a>
        <h1 class="h3 mb-0">${empty branch.id ? 'Thêm chi nhánh mới' : 'Cập nhật chi nhánh'}</h1>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <c:out value="${error}"/>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="card shadow-sm border-0">
        <div class="card-body p-4">
            <form method="post" action="${pageContext.request.contextPath}${formAction}">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold" for="code">
                            Mã chi nhánh <span class="text-danger">*</span>
                        </label>
                        <input class="form-control font-monospace"
                               id="code"
                               name="code"
                               value="<c:out value='${branch.code}'/>"
                               placeholder="VD: UTE-TD-01"
                               maxlength="30"
                               required>
                        <div class="form-text">Mã định danh duy nhất (chữ in hoa và dấu gạch nối).</div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-semibold" for="phone">
                            Số điện thoại liên hệ
                        </label>
                        <input class="form-control"
                               id="phone"
                               name="phone"
                               value="<c:out value='${branch.phone}'/>"
                               placeholder="VD: 028 3896 8641"
                               maxlength="20">
                    </div>

                    <div class="col-12">
                        <label class="form-label fw-semibold" for="name">
                            Tên chi nhánh <span class="text-danger">*</span>
                        </label>
                        <input class="form-control"
                               id="name"
                               name="name"
                               value="<c:out value='${branch.name}'/>"
                               placeholder="VD: UTETra Thủ Đức - Võ Văn Ngân"
                               maxlength="150"
                               required>
                    </div>

                    <div class="col-12">
                        <label class="form-label fw-semibold" for="addressLine">
                            Địa chỉ cụ thể <span class="text-danger">*</span>
                        </label>
                        <input class="form-control"
                               id="addressLine"
                               name="addressLine"
                               value="<c:out value='${branch.addressLine}'/>"
                               placeholder="VD: Số 1 Võ Văn Ngân, Phường Linh Chiểu"
                               maxlength="255"
                               required>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-semibold" for="district">
                            Quận / Huyện <span class="text-danger">*</span>
                        </label>
                        <input class="form-control"
                               id="district"
                               name="district"
                               value="<c:out value='${branch.district}'/>"
                               placeholder="VD: TP. Thủ Đức, Quận 1, Gò Vấp..."
                               maxlength="100"
                               required>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-semibold" for="city">
                            Tỉnh / Thành phố <span class="text-danger">*</span>
                        </label>
                        <input class="form-control"
                               id="city"
                               name="city"
                               value="<c:out value='${empty branch.city ? "TP. Hồ Chí Minh" : branch.city}'/>"
                               placeholder="VD: TP. Hồ Chí Minh"
                               maxlength="100"
                               required>
                    </div>
                </div>

                <hr class="my-4">

                <div class="d-flex justify-content-between align-items-center">
                    <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/branches">
                        Hủy bỏ
                    </a>
                    <button class="btn btn-primary px-4" type="submit">
                        ${empty branch.id ? 'Tạo chi nhánh' : 'Lưu thay đổi'}
                    </button>
                </div>
            </form>
        </div>
    </div>
</section>
</body>
</html>
