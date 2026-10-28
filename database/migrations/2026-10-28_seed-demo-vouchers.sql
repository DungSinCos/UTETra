-- Demo vouchers for the UTETra cart/checkout flow.
-- Valid from 2026-10-28 through 2027-12-31; rerunnable by voucher code.
INSERT INTO vouchers (code, description, discount_type, discount_value, min_order_amount, max_discount_amount, usage_limit, used_count, start_date, end_date, is_active)
VALUES
  ('UTETRA10', 'Giảm 10% cho đơn từ 100.000đ, tối đa 30.000đ', 'PERCENT', 10.00, 100000.00, 30000.00, 500, 0, '2026-10-28 00:00:00', '2027-12-31 23:59:59', TRUE),
  ('UTETRA15K', 'Giảm 15.000đ cho đơn từ 80.000đ', 'FIXED_AMOUNT', 15000.00, 80000.00, NULL, 500, 0, '2026-10-28 00:00:00', '2027-12-31 23:59:59', TRUE),
  ('FREESHIP', 'Miễn phí giao hàng', 'FREESHIP', 0.00, 0.00, NULL, 500, 0, '2026-10-28 00:00:00', '2027-12-31 23:59:59', TRUE)
ON DUPLICATE KEY UPDATE
  description = VALUES(description), discount_type = VALUES(discount_type),
  discount_value = VALUES(discount_value), min_order_amount = VALUES(min_order_amount),
  max_discount_amount = VALUES(max_discount_amount), usage_limit = VALUES(usage_limit),
  start_date = VALUES(start_date), end_date = VALUES(end_date), is_active = VALUES(is_active);
