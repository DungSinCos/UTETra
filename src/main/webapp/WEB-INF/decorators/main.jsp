<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>UTETra - <sitemesh:write property="title"/></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/bootstrap/5.3.3/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <sitemesh:write property="head"/>
</head>
<body class="d-flex flex-column min-vh-100">
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>

    <main class="flex-grow-1">
        <sitemesh:write property="body"/>
    </main>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>

    <script src="${pageContext.request.contextPath}/webjars/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
</body>
</html>
