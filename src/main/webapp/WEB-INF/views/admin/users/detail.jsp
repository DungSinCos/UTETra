<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head><title>Chi tiết người dùng</title></head>
<body>
<section class="container py-5" style="max-width:850px">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="mb-0">Chi tiết người dùng</h1>
        <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/users">Quay lại</a>
    </div>
    <c:if test="${not empty message}"><div class="alert alert-success"><c:out value="${message}"/></div></c:if>
    <c:if test="${not empty error}"><div class="alert alert-danger"><c:out value="${error}"/></div></c:if>

    <div class="card mb-4">
        <div class="card-header fw-semibold">Thông tin tài khoản</div>
        <div class="card-body">
            <dl class="row mb-0">
                <dt class="col-sm-4">Họ tên</dt><dd class="col-sm-8"><c:out value="${user.fullName}"/></dd>
                <dt class="col-sm-4">Email</dt><dd class="col-sm-8"><c:out value="${user.email}"/></dd>
                <dt class="col-sm-4">Điện thoại</dt><dd class="col-sm-8"><c:out value="${user.phone}"/></dd>
                <dt class="col-sm-4">Vai trò</dt><dd class="col-sm-8"><c:out value="${user.role.label}"/></dd>
                <dt class="col-sm-4">Trạng thái</dt><dd class="col-sm-8"><c:out value="${user.status.label}"/></dd>
                <dt class="col-sm-4">Điểm thành viên</dt><dd class="col-sm-8"><c:out value="${user.loyaltyPoints}"/></dd>
                <dt class="col-sm-4">Tạo lúc</dt><dd class="col-sm-8"><c:out value="${user.createdAt}"/></dd>
            </dl>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-md-6">
            <div class="card h-100">
                <div class="card-header fw-semibold">Khóa hoặc mở khóa</div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/admin/users/${user.id}/status">
                        <label class="form-label" for="status">Trạng thái tài khoản</label>
                        <select class="form-select mb-3" id="status" name="status" required>
                            <option value="ACTIVE" ${user.status eq 'ACTIVE' ? 'selected' : ''}>Đang hoạt động</option>
                            <option value="LOCKED" ${user.status eq 'LOCKED' ? 'selected' : ''}>Đã khóa</option>
                        </select>
                        <button class="btn btn-outline-primary" type="submit">Lưu trạng thái</button>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card h-100">
                <div class="card-header fw-semibold">Thay đổi vai trò</div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/admin/users/${user.id}/role">
                        <label class="form-label" for="role">Vai trò</label>
                        <select class="form-select mb-3" id="role" name="role" required>
                            <c:forEach var="roleOption" items="${roles}">
                                <option value="${roleOption}" ${user.role eq roleOption ? 'selected' : ''}><c:out value="${roleOption.label}"/></option>
                            </c:forEach>
                        </select>
                        <button class="btn btn-primary" type="submit">Lưu vai trò</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>
</body>
</html>
