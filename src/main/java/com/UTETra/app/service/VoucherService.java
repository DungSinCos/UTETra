package com.UTETra.app.service;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Locale;

@Service
public class VoucherService {

    public record Quote(long voucherId, String code, String description,
                        BigDecimal discount, BigDecimal total) {}

    private record Voucher(long id, String code, String description, String type,
                           BigDecimal value, BigDecimal minimum, BigDecimal maximum,
                           Integer usageLimit, int usedCount, boolean active, boolean inDateRange) {}

    private final JdbcTemplate jdbc;

    public VoucherService(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public Quote quote(String code, BigDecimal subtotal, BigDecimal deliveryFee) {
        if (code == null || code.isBlank()) return null;
        Voucher voucher = jdbc.query("""
                SELECT id, code, description, discount_type, discount_value,
                       min_order_amount, max_discount_amount, usage_limit, used_count,
                       is_active, (start_date <= NOW() AND end_date >= NOW()) AS in_date_range
                FROM vouchers WHERE code = ?
                """, this::mapVoucher, code.trim().toUpperCase(Locale.ROOT))
                .stream().findFirst().orElseThrow(() -> new IllegalArgumentException("Mã giảm giá không tồn tại."));

        if (!voucher.active() || !voucher.inDateRange()) {
            throw new IllegalArgumentException("Mã giảm giá đã hết hạn hoặc chưa có hiệu lực.");
        }
        if (voucher.usageLimit() != null && voucher.usedCount() >= voucher.usageLimit()) {
            throw new IllegalArgumentException("Mã giảm giá đã hết lượt sử dụng.");
        }
        if (subtotal.compareTo(voucher.minimum()) < 0) {
            throw new IllegalArgumentException("Đơn hàng chưa đạt giá trị tối thiểu để dùng mã này.");
        }

        BigDecimal discount = switch (voucher.type()) {
            case "PERCENT" -> subtotal.multiply(voucher.value()).divide(BigDecimal.valueOf(100), 0, RoundingMode.DOWN);
            case "FIXED_AMOUNT" -> voucher.value();
            case "FREESHIP" -> deliveryFee;
            default -> throw new IllegalArgumentException("Loại mã giảm giá không được hỗ trợ.");
        };
        if (voucher.maximum() != null && discount.compareTo(voucher.maximum()) > 0) discount = voucher.maximum();
        BigDecimal cap = "FREESHIP".equals(voucher.type()) ? deliveryFee : subtotal;
        if (discount.compareTo(cap) > 0) discount = cap;
        BigDecimal total = subtotal.add(deliveryFee).subtract(discount).max(BigDecimal.ZERO);
        return new Quote(voucher.id(), voucher.code(), voucher.description(), discount, total);
    }

    public boolean consume(long voucherId) {
        return jdbc.update("""
                UPDATE vouchers SET used_count = used_count + 1
                WHERE id = ? AND is_active = TRUE AND start_date <= NOW() AND end_date >= NOW()
                  AND (usage_limit IS NULL OR used_count < usage_limit)
                """, voucherId) == 1;
    }

    private Voucher mapVoucher(ResultSet rs, int rowNum) throws SQLException {
        return new Voucher(rs.getLong("id"), rs.getString("code"), rs.getString("description"),
                rs.getString("discount_type"), rs.getBigDecimal("discount_value"),
                rs.getBigDecimal("min_order_amount"), rs.getBigDecimal("max_discount_amount"),
                (Integer) rs.getObject("usage_limit"), rs.getInt("used_count"),
                rs.getBoolean("is_active"), rs.getBoolean("in_date_range"));
    }
}
