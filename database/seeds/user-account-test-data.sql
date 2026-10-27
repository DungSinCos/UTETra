-- Development/test data for the User Account feature.
-- Run after database/UTETra.sql has created the schema and base catalog data.
-- All three accounts use the development-only password: UTETraTest123!
-- Do not use this seed data in a production database.

USE UTETra;

INSERT INTO users (full_name, email, phone, password_hash, role, loyalty_points, status)
VALUES
    ('Khách hàng kiểm thử', 'account.test@utetra.local', '0900000031',
     '$2a$10$buW42BXGd3w5n.WaMWQTnuaEzbNlDe5R7qKOCDFNinTsIgIz3y.ma', 'CUSTOMER', 25, 'ACTIVE'),
    ('Khách bị khóa kiểm thử', 'account.locked@utetra.local', '0900000032',
     '$2a$10$buW42BXGd3w5n.WaMWQTnuaEzbNlDe5R7qKOCDFNinTsIgIz3y.ma', 'CUSTOMER', 0, 'LOCKED'),
    ('Admin kiểm thử', 'account.admin@utetra.local', '0900000033',
     '$2a$10$buW42BXGd3w5n.WaMWQTnuaEzbNlDe5R7qKOCDFNinTsIgIz3y.ma', 'ADMIN', 0, 'ACTIVE')
ON DUPLICATE KEY UPDATE
    full_name = VALUES(full_name),
    phone = VALUES(phone),
    password_hash = VALUES(password_hash),
    role = VALUES(role),
    loyalty_points = VALUES(loyalty_points),
    status = VALUES(status);

-- A sample completed order makes the account order-history page testable.
INSERT INTO orders (
    order_code, user_id, branch_id, order_type, recipient_name, recipient_phone,
    shipping_address, subtotal_amount, shipping_fee, discount_amount, total_amount,
    payment_method, payment_status, order_status, note
)
SELECT
    'TEST-ACCOUNT-ORDER-001', u.id, 1, 'DELIVERY', u.full_name, u.phone,
    'Địa chỉ kiểm thử, TP. Thủ Đức', 55000.00, 0.00, 0.00, 55000.00,
    'COD', 'PAID', 'COMPLETED', 'Đơn mẫu cho trang lịch sử đơn hàng'
FROM users u
WHERE u.email = 'account.test@utetra.local'
  AND EXISTS (SELECT 1 FROM branches WHERE id = 1)
  AND NOT EXISTS (SELECT 1 FROM orders WHERE order_code = 'TEST-ACCOUNT-ORDER-001');

INSERT INTO order_items (
    order_id, product_id, product_name, size_name, sugar_level, ice_level,
    unit_price, topping_total_price, quantity, line_total, note
)
SELECT
    o.id, (SELECT MIN(id) FROM products), 'Trà sữa mẫu', 'M', '50%', '50%',
    55000.00, 0.00, 1, 55000.00, 'Sản phẩm mẫu cho đơn kiểm thử'
FROM orders o
WHERE o.order_code = 'TEST-ACCOUNT-ORDER-001'
  AND NOT EXISTS (SELECT 1 FROM order_items WHERE order_id = o.id);
