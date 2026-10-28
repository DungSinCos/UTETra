package com.UTETra.app.service.impl;

import com.UTETra.app.entity.CustomerOrder;
import com.UTETra.app.service.VNPayService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

@Service
public class VNPayServiceImpl implements VNPayService {

    private final String tmnCode;
    private final String hashSecret;
    private final String payUrl;
    private final String returnUrl;

    public VNPayServiceImpl(
            @Value("${vnpay.tmn-code}") String tmnCode,
            @Value("${vnpay.hash-secret}") String hashSecret,
            @Value("${vnpay.pay-url}") String payUrl,
            @Value("${vnpay.return-url}") String returnUrl) {
        this.tmnCode = tmnCode;
        this.hashSecret = hashSecret;
        this.payUrl = payUrl;
        this.returnUrl = returnUrl;
    }

    @Override
    public String createPaymentUrl(CustomerOrder order, HttpServletRequest request) {
        long amount = order.getTotalAmount().longValue() * 100L;

        Map<String, String> vnpParams = new HashMap<>();
        vnpParams.put("vnp_Version", "2.1.0");
        vnpParams.put("vnp_Command", "pay");
        vnpParams.put("vnp_TmnCode", tmnCode);
        vnpParams.put("vnp_Amount", String.valueOf(amount));
        vnpParams.put("vnp_CurrCode", "VND");
        vnpParams.put("vnp_TxnRef", order.getOrderCode());
        vnpParams.put("vnp_OrderInfo", "Thanh toan don hang UTETra " + order.getOrderCode());
        vnpParams.put("vnp_OrderType", "other");
        vnpParams.put("vnp_Locale", "vn");
        vnpParams.put("vnp_ReturnUrl", returnUrl);
        vnpParams.put("vnp_IpAddr", getClientIp(request));

        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        formatter.setTimeZone(TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
        String createDate = formatter.format(new java.util.Date());
        vnpParams.put("vnp_CreateDate", createDate);
        vnpParams.put("vnp_ExpireDate", formatter.format(
                new java.util.Date(System.currentTimeMillis() + 15 * 60 * 1000L)));

        // Build sorted query string
        List<String> fieldNames = new ArrayList<>(vnpParams.keySet());
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        boolean first = true;

        for (String fieldName : fieldNames) {
            String fieldValue = vnpParams.get(fieldName);
            if (fieldValue != null && !fieldValue.isEmpty()) {
                String encodedKey = URLEncoder.encode(fieldName, StandardCharsets.US_ASCII);
                String encodedValue = URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII);

                // VNPAY v2.1.0 signs the sorted, unencoded key/value pairs. The URL
                // query string is encoded separately after the signature is computed.
                if (!first) {
                    hashData.append('&');
                    query.append('&');
                }
                hashData.append(fieldName).append('=').append(fieldValue);
                query.append(encodedKey).append('=').append(encodedValue);
                first = false;
            }
        }

        String queryUrl = query.toString();
        String vnpSecureHash = hmacSHA512(hashSecret, hashData.toString());
        queryUrl += "&vnp_SecureHash=" + vnpSecureHash;

        return payUrl + "?" + queryUrl;
    }

    @Override
    public boolean verifySignature(Map<String, String> queryParams) {
        String vnpSecureHash = queryParams.get("vnp_SecureHash");
        if (vnpSecureHash == null || vnpSecureHash.isBlank()) {
            return false;
        }

        List<String> fieldNames = new ArrayList<>(queryParams.keySet());
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        boolean first = true;
        for (String fieldName : fieldNames) {
            String fieldValue = queryParams.get(fieldName);
            if (fieldValue != null && !fieldValue.isEmpty()
                    && !"vnp_SecureHash".equals(fieldName)
                    && !"vnp_SecureHashType".equals(fieldName)) {
                if (!first) {
                    hashData.append('&');
                }
                // Servlet has already decoded the callback query values. Rebuild
                // the same raw value string that was signed in createPaymentUrl.
                hashData.append(fieldName).append('=').append(fieldValue);
                first = false;
            }
        }

        String signValue = hmacSHA512(hashSecret, hashData.toString());
        return vnpSecureHash.equalsIgnoreCase(signValue);
    }

    @Override
    public boolean isPaymentSuccess(Map<String, String> queryParams) {
        String responseCode = queryParams.get("vnp_ResponseCode");
        String transactionStatus = queryParams.get("vnp_TransactionStatus");
        return "00".equals(responseCode) && ("00".equals(transactionStatus) || transactionStatus == null);
    }

    @Override
    public String getTransactionRef(Map<String, String> queryParams) {
        return queryParams.get("vnp_TransactionNo");
    }

    @Override
    public String getOrderCode(Map<String, String> queryParams) {
        return queryParams.get("vnp_TxnRef");
    }

    @Override
    public String getResponseDescription(String responseCode) {
        if (responseCode == null) return "Không xác định";
        return switch (responseCode) {
            case "00" -> "Giao dịch thành công";
            case "07" -> "Trừ tiền thành công. Giao dịch bị nghi ngờ (liên quan tới lừa đảo, gian lận).";
            case "09" -> "Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng chưa đăng ký dịch vụ InternetBanking.";
            case "10" -> "Giao dịch không thành công do: Khách hàng xác thực thông tin thẻ/tài khoản không đúng quá 3 lần.";
            case "11" -> "Giao dịch không thành công do: Đã hết hạn chờ thanh toán.";
            case "12" -> "Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng bị khóa.";
            case "13" -> "Giao dịch không thành công do Quý khách nhập sai mật khẩu xác thực OTP.";
            case "24" -> "Giao dịch không thành công do: Khách hàng hủy giao dịch.";
            case "51" -> "Giao dịch không thành công do: Tài khoản của quý khách không đủ số dư.";
            case "65" -> "Giao dịch không thành công do: Tài khoản đã vượt quá hạn mức giao dịch trong ngày.";
            case "75" -> "Ngân hàng thanh toán đang bảo trì.";
            case "79" -> "Giao dịch không thành công do khách hàng nhập sai mật khẩu thanh toán quá số lần quy định.";
            default -> "Giao dịch thất bại (Mã lỗi: " + responseCode + ")";
        };
    }

    private static String hmacSHA512(String key, String data) {
        try {
            Mac hmac512 = Mac.getInstance("HmacSHA512");
            SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
            hmac512.init(secretKey);
            byte[] result = hmac512.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(2 * result.length);
            for (byte b : result) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();
        } catch (Exception ex) {
            throw new RuntimeException("Error computing HMAC SHA512", ex);
        }
    }

    private String getClientIp(HttpServletRequest request) {
        if (request == null) return "127.0.0.1";
        String ipAddress = request.getHeader("X-FORWARDED-FOR");
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getRemoteAddr();
        }
        if (ipAddress != null && ipAddress.contains(",")) {
            ipAddress = ipAddress.split(",")[0].trim();
        }
        return ipAddress != null ? ipAddress : "127.0.0.1";
    }
}
