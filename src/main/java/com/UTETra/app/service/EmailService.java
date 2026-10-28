package com.UTETra.app.service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

/**
 * Sends verification emails using Spring's JavaMailSender (configured for Google Mail SMTP).
 */
@Service
public class EmailService {

    private static final Logger log = LoggerFactory.getLogger(EmailService.class);

    private final JavaMailSender mailSender;
    private final String fromEmail;
    private final String mailPassword;

    public EmailService(JavaMailSender mailSender,
                        @Value("${spring.mail.username:}") String fromEmail,
                        @Value("${spring.mail.password:}") String mailPassword) {
        this.mailSender = mailSender;
        this.fromEmail = fromEmail;
        this.mailPassword = mailPassword;
    }

    /**
     * Sends a 6-digit verification code email to the user via Google Mail SMTP.
     */
    public void sendVerificationCode(String toEmail, String fullName, String code) {
        log.info("[EmailVerification] 6-digit OTP code for {} is: {}", toEmail, code);

        if (!isMailConfigured()) {
            log.warn("[EmailVerification] Gmail credentials are still set to placeholders in application.properties. " +
                    "Use the 6-digit code logged above ({}) to test, or set spring.mail.username / spring.mail.password.", code);
            return;
        }

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, false, "UTF-8");
            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("UTETra - Mã xác thực đăng ký tài khoản");
            helper.setText(buildEmailHtml(fullName, code), true);
            mailSender.send(message);
        } catch (MessagingException e) {
            throw new IllegalStateException("Không thể gửi email xác thực", e);
        }
    }

    private boolean isMailConfigured() {
        return fromEmail != null && !fromEmail.isBlank() && !"your_email@gmail.com".equals(fromEmail)
                && mailPassword != null && !mailPassword.isBlank() && !"your_google_app_password".equals(mailPassword);
    }

    private String buildEmailHtml(String fullName, String code) {
        return """
                <div style="font-family: Arial, sans-serif; max-width: 520px; margin: 0 auto; padding: 32px; background-color: #fff8f0; border-radius: 16px; border: 1px solid #f0e2d3; color: #2d1e15;">
                    <h2 style="margin: 0 0 12px; color: #7b4a2b;">UTETra - Xác thực tài khoản</h2>
                    <p style="margin: 0 0 16px;">Xin chào <strong>%s</strong>,</p>
                    <p style="margin: 0 0 20px;">Cảm ơn bạn đã đăng ký tài khoản tại UTETra. Vui lòng nhập mã xác thực gồm 6 chữ số dưới đây để hoàn tất đăng ký:</p>
                    <div style="text-align: center; margin: 24px 0;">
                        <span style="display: inline-block; padding: 14px 28px; font-size: 28px; font-weight: 800; letter-spacing: 8px; color: #7b4a2b; background-color: #ffffff; border: 2px dashed #e9a15b; border-radius: 12px;">%s</span>
                    </div>
                    <p style="margin: 0 0 8px; font-size: 13px; color: #7d6a5d;">Mã xác thực này có hiệu lực trong vòng <strong>10 phút</strong>.</p>
                    <p style="margin: 0; font-size: 13px; color: #7d6a5d;">Nếu bạn không thực hiện yêu cầu này, vui lòng bỏ qua email này.</p>
                </div>
                """.formatted(fullName, code);
    }
}
