<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Hỗ Trợ khách hàng</title>
    <meta name="description" content="Câu hỏi thường gặp và thông tin liên hệ hỗ trợ khách hàng UTETra.">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/info-pages.css">
</head>
<body>
<main class="info-page support-page">
    <section class="support-hero">
        <div class="info-container support-hero-inner">
            <span class="eyebrow">UTETRA LUÔN Ở ĐÂY</span>
            <h1>Tụi mình có thể <span>giúp gì</span> cho bạn?</h1>
            <p>Tìm câu trả lời nhanh bên dưới hoặc liên hệ trực tiếp với đội ngũ UTETra nhé.</p>
            <a class="info-button" href="#faq">Xem câu hỏi thường gặp <span aria-hidden="true">↓</span></a>
        </div>
    </section>

    <section class="info-container contact-section">
        <div class="section-heading">
            <span class="eyebrow">KẾT NỐI VỚI UTETRA</span>
            <h2>Chúng mình sẵn sàng lắng nghe</h2>
            <p>Chọn cách liên hệ phù hợp với bạn. Thông tin bên dưới có thể được cập nhật theo hoạt động thực tế của cửa hàng.</p>
        </div>
        <div class="contact-grid">
            <article class="contact-card"><div class="contact-icon">☎</div><h3>Hotline</h3><p>Hỗ trợ đơn hàng và tư vấn sản phẩm</p><a href="tel:19001234">1900 1234</a></article>
            <article class="contact-card"><div class="contact-icon">✉</div><h3>Email</h3><p>Gửi câu hỏi hoặc góp ý cho tụi mình</p><a href="mailto:hello@utetra.vn">hello@utetra.vn</a></article>
            <article class="contact-card"><div class="contact-icon">⌖</div><h3>Địa chỉ</h3><p>Ghé thăm cửa hàng của UTETra</p><span>1 Võ Văn Ngân, TP. Thủ Đức, TP.HCM</span></article>
        </div>
    </section>

    <section id="faq" class="faq-section">
        <div class="info-container faq-layout">
            <div class="faq-intro"><span class="eyebrow">FAQ</span><h2>Câu hỏi thường gặp</h2><p>Một vài thông tin có thể giúp bạn đặt món thuận tiện hơn.</p><a href="mailto:hello@utetra.vn" class="text-link">Bạn cần hỗ trợ thêm? Gửi email →</a></div>
            <div class="faq-list">
                <details class="faq-item" open><summary>Làm sao để xem thực đơn và giá?</summary><p>Bạn chọn mục <a href="${pageContext.request.contextPath}/products">Thực Đơn</a> trên thanh điều hướng để xem các món đang được hiển thị và giá tương ứng.</p></details>
                <details class="faq-item"><summary>Tôi có thể thay đổi mức đường hoặc đá không?</summary><p>Nếu trang đặt món có lựa chọn tùy chỉnh, bạn có thể chọn mức đường, đá và topping trước khi xác nhận đơn. Nếu chưa thấy tùy chọn, hãy liên hệ cửa hàng để được hướng dẫn.</p></details>
                <details class="faq-item"><summary>Làm sao kiểm tra tình trạng đơn hàng?</summary><p>Đăng nhập tài khoản và mở mục Tài khoản/Đơn hàng nếu tính năng này đã được bật trên phiên bản website bạn đang sử dụng.</p></details>
                <details class="faq-item"><summary>Tôi muốn góp ý hoặc báo lỗi website thì làm thế nào?</summary><p>Gửi email đến <a href="mailto:hello@utetra.vn">hello@utetra.vn</a>, kèm mô tả vấn đề và ảnh chụp màn hình nếu có để đội ngũ hỗ trợ dễ kiểm tra.</p></details>
            </div>
        </div>
    </section>

    <section class="info-container support-cta">
        <div><h2>Vẫn chưa tìm được câu trả lời?</h2><p>Gửi email cho UTETra, tụi mình sẽ tiếp nhận góp ý của bạn.</p></div>
        <a class="info-button" href="mailto:hello@utetra.vn?subject=Yeu%20cau%20ho%20tro%20UTETra">Gửi yêu cầu hỗ trợ <span aria-hidden="true">→</span></a>
    </section>
</main>
</body>
</html>
