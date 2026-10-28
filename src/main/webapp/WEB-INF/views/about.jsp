<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Về UTETra</title>
    <meta name="description" content="Tìm hiểu câu chuyện, giá trị và cam kết chất lượng của UTETra.">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/info-pages.css">
</head>
<body>
<main class="info-page">
    <section class="about-hero">
        <div class="info-container about-hero-grid">
            <div class="about-copy">
                <span class="eyebrow">CÂU CHUYỆN CỦA CHÚNG MÌNH</span>
                <h1>Mỗi ly trà, một chút <span>ngọt ngào</span></h1>
                <p>UTETra bắt đầu từ mong muốn mang đến những ly trà sữa thơm ngon, dễ uống và được chuẩn bị bằng sự chỉn chu trong từng chi tiết.</p>
                <p>Chúng mình kết hợp hương trà đậm đà, nguyên liệu được chọn lựa kỹ càng và topping chuẩn bị mỗi ngày để mỗi lần thưởng thức đều là một trải nghiệm vui vẻ.</p>
                <a class="info-button" href="${pageContext.request.contextPath}/products">Khám phá thực đơn <span aria-hidden="true">→</span></a>
            </div>
            <div class="about-visual" role="img" aria-label="Minh họa ly trà sữa">
                <div class="about-circle"></div>
                <div class="about-cup" aria-hidden="true">🧋</div>
                <div class="floating-note"><strong>Tươi mới mỗi ngày</strong><span>Chọn nguyên liệu bằng sự tận tâm</span></div>
            </div>
        </div>
    </section>

    <section class="info-container story-section">
        <div class="section-heading">
            <span class="eyebrow">ĐIỀU UTETRA TIN TƯỞNG</span>
            <h2>Không chỉ là một ly trà sữa</h2>
            <p>Tụi mình muốn mỗi ly nước là một khoảng nghỉ nhỏ, giúp ngày của bạn dễ chịu hơn.</p>
        </div>
        <div class="value-grid">
            <article class="value-card"><div class="value-icon">🍃</div><h3>Nguyên liệu chọn lọc</h3><p>Ưu tiên hương trà rõ vị, sữa thơm béo và nguyên liệu có nguồn gốc phù hợp.</p></article>
            <article class="value-card"><div class="value-icon">🥤</div><h3>Pha chế chỉn chu</h3><p>Mỗi thức uống được chuẩn bị cẩn thận để giữ hương vị hài hòa và dễ thưởng thức.</p></article>
            <article class="value-card"><div class="value-icon">💛</div><h3>Khách hàng là trung tâm</h3><p>Lắng nghe góp ý của bạn để cải thiện thực đơn và chất lượng phục vụ mỗi ngày.</p></article>
        </div>
    </section>

    <section class="about-promise">
        <div class="info-container promise-inner">
            <div><span class="eyebrow eyebrow-light">LỜI HỨA TỪ UTETRA</span><h2>Vị ngon bắt đầu từ sự tử tế.</h2><p>Cảm ơn bạn đã để UTETra góp một chút ngọt ngào vào ngày thường của mình.</p></div>
            <a class="info-button info-button-light" href="${pageContext.request.contextPath}/support">Liên hệ với tụi mình</a>
        </div>
    </section>
</main>
</body>
</html>
