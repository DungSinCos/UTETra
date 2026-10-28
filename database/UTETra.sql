-- ============================================================
-- Database Schema: UTETra (Coffee & Milk Tea Chain Management)
-- Target DBMS    : MySQL 8.0+
-- ============================================================

CREATE DATABASE IF NOT EXISTS UTETra
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE UTETra;

-- ============================================================
-- 1. USERS & ACCESS CONTROL
-- ============================================================

CREATE TABLE users (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    full_name       VARCHAR(100) NOT NULL,
    email           VARCHAR(150) NOT NULL UNIQUE,
    phone           VARCHAR(20)  UNIQUE,
    password_hash   VARCHAR(255) NOT NULL,
    auth_provider   VARCHAR(20)  NOT NULL DEFAULT 'LOCAL',
    avatar_url      VARCHAR(500),
    role            ENUM('CUSTOMER', 'STAFF', 'MANAGER', 'ADMIN') NOT NULL DEFAULT 'CUSTOMER',
    loyalty_points  INT          NOT NULL DEFAULT 0,
    status          ENUM('ACTIVE', 'LOCKED', 'INACTIVE') NOT NULL DEFAULT 'ACTIVE',
    created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE user_addresses (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT       NOT NULL,
    recipient_name  VARCHAR(100) NOT NULL,
    recipient_phone VARCHAR(20)  NOT NULL,
    address_line    VARCHAR(255) NOT NULL,
    ward            VARCHAR(100),
    district        VARCHAR(100) NOT NULL,
    city            VARCHAR(100) NOT NULL,
    latitude        DECIMAL(10, 7),
    longitude       DECIMAL(10, 7),
    is_default       BOOLEAN      NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_address_user
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE password_reset_tokens (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    token           VARCHAR(36)  NOT NULL UNIQUE,
    user_id         BIGINT       NOT NULL,
    expiry_date     DATETIME     NOT NULL,
    used            BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at      DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_password_reset_user
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- 2. STORES / BRANCHES (CHUỖI CỬA HÀNG)
-- ============================================================

CREATE TABLE branches (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    code            VARCHAR(30)  NOT NULL UNIQUE,
    name            VARCHAR(150) NOT NULL,
    phone           VARCHAR(20),
    address_line    VARCHAR(255) NOT NULL,
    district        VARCHAR(100) NOT NULL,
    city            VARCHAR(100) NOT NULL,
    latitude        DECIMAL(10, 7),
    longitude       DECIMAL(10, 7),
    open_time       TIME         NOT NULL DEFAULT '07:00:00',
    close_time      TIME         NOT NULL DEFAULT '22:00:00',
    manager_id      BIGINT,
    is_active       BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_branch_manager
        FOREIGN KEY (manager_id) REFERENCES users (id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================================
-- 3. CATALOG: CATEGORIES, PRODUCTS, SIZES, TOPPINGS
-- ============================================================

CREATE TABLE categories (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    slug            VARCHAR(120) NOT NULL UNIQUE,
    description     VARCHAR(255),
    image_url       VARCHAR(500),
    display_order   INT          NOT NULL DEFAULT 0,
    is_active       BOOLEAN      NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;

CREATE TABLE products (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    category_id     BIGINT         NOT NULL,
    sku             VARCHAR(50)    NOT NULL UNIQUE,
    name            VARCHAR(150)   NOT NULL,
    slug            VARCHAR(180)   NOT NULL UNIQUE,
    description     TEXT,
    image_url       VARCHAR(500),
    image_public_id VARCHAR(255),   -- Cloudinary public id; NULL for images not hosted on our Cloudinary (e.g. seed data)
    base_price      DECIMAL(12, 2) NOT NULL CHECK (base_price >= 0),
    is_featured     BOOLEAN        NOT NULL DEFAULT FALSE,
    is_active       BOOLEAN        NOT NULL DEFAULT TRUE,
    created_at      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Sizes available for each drink (e.g., S / M / L with price differential)
CREATE TABLE product_sizes (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    product_id      BIGINT         NOT NULL,
    size_name       ENUM('S', 'M', 'L') NOT NULL,
    extra_price     DECIMAL(12, 2) NOT NULL DEFAULT 0.00 CHECK (extra_price >= 0),
    UNIQUE KEY uk_product_size (product_id, size_name),
    CONSTRAINT fk_size_product
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Toppings (Trân châu đen, Kem cheese, Pudding, Đậu đỏ, v.v.)
CREATE TABLE toppings (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(100)   NOT NULL UNIQUE,
    price           DECIMAL(12, 2) NOT NULL CHECK (price >= 0),
    image_url       VARCHAR(500),
    is_available    BOOLEAN        NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;

-- Which toppings are allowed on which products (e.g. Kem cheese might not apply to fruit tea)
CREATE TABLE product_toppings (
    product_id      BIGINT NOT NULL,
    topping_id      BIGINT NOT NULL,
    PRIMARY KEY (product_id, topping_id),
    CONSTRAINT fk_pt_product FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
    CONSTRAINT fk_pt_topping FOREIGN KEY (topping_id) REFERENCES toppings (id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Per-branch stock availability (allows a specific store to mark a drink out-of-stock)
CREATE TABLE branch_product_status (
    branch_id       BIGINT  NOT NULL,
    product_id      BIGINT  NOT NULL,
    is_available    BOOLEAN NOT NULL DEFAULT TRUE,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (branch_id, product_id),
    CONSTRAINT fk_bps_branch  FOREIGN KEY (branch_id)  REFERENCES branches (id) ON DELETE CASCADE,
    CONSTRAINT fk_bps_product FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- 4. SHOPPING CART (GIỎ HÀNG)
-- ============================================================

CREATE TABLE carts (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT   NOT NULL UNIQUE,
    branch_id       BIGINT,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_cart_user   FOREIGN KEY (user_id)   REFERENCES users (id)    ON DELETE CASCADE,
    CONSTRAINT fk_cart_branch FOREIGN KEY (branch_id) REFERENCES branches (id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE cart_items (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    cart_id         BIGINT NOT NULL,
    product_id      BIGINT NOT NULL,
    size_name       ENUM('S', 'M', 'L') NOT NULL DEFAULT 'M',
    sugar_level     ENUM('0%', '30%', '50%', '70%', '100%') NOT NULL DEFAULT '100%',
    ice_level       ENUM('0%', '30%', '50%', '70%', '100%') NOT NULL DEFAULT '100%',
    quantity        INT    NOT NULL DEFAULT 1 CHECK (quantity > 0),
    note            VARCHAR(255),
    CONSTRAINT fk_ci_cart    FOREIGN KEY (cart_id)    REFERENCES carts (id)    ON DELETE CASCADE,
    CONSTRAINT fk_ci_product FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE cart_item_toppings (
    cart_item_id    BIGINT NOT NULL,
    topping_id      BIGINT NOT NULL,
    quantity        INT    NOT NULL DEFAULT 1 CHECK (quantity > 0),
    PRIMARY KEY (cart_item_id, topping_id),
    CONSTRAINT fk_cit_item    FOREIGN KEY (cart_item_id) REFERENCES cart_items (id) ON DELETE CASCADE,
    CONSTRAINT fk_cit_topping FOREIGN KEY (topping_id)   REFERENCES toppings (id)   ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- 5. VOUCHERS & PROMOTIONS (MÃ GIẢM GIÁ)
-- ============================================================

CREATE TABLE vouchers (
    id                  BIGINT AUTO_INCREMENT PRIMARY KEY,
    code                VARCHAR(50)    NOT NULL UNIQUE,
    description         VARCHAR(255),
    discount_type       ENUM('PERCENT', 'FIXED_AMOUNT', 'FREESHIP') NOT NULL,
    discount_value      DECIMAL(12, 2) NOT NULL CHECK (discount_value >= 0),
    min_order_amount    DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    max_discount_amount DECIMAL(12, 2),
    usage_limit         INT,
    used_count          INT            NOT NULL DEFAULT 0,
    start_date          DATETIME       NOT NULL,
    end_date            DATETIME       NOT NULL,
    is_active           BOOLEAN        NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;

-- ============================================================
-- 6. ORDERS & PAYMENTS (ĐƠN HÀNG & THANH TOÁN)
-- ============================================================

CREATE TABLE orders (
    id                  BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_code          VARCHAR(40)    NOT NULL UNIQUE,
    user_id             BIGINT,
    branch_id           BIGINT         NOT NULL,
    voucher_id          BIGINT,
    order_type          ENUM('DELIVERY', 'PICKUP', 'DINE_IN') NOT NULL DEFAULT 'DELIVERY',
    recipient_name      VARCHAR(100)   NOT NULL,
    recipient_phone     VARCHAR(20)    NOT NULL,
    shipping_address    VARCHAR(500),
    subtotal_amount     DECIMAL(12, 2) NOT NULL,
    shipping_fee        DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    discount_amount     DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    total_amount        DECIMAL(12, 2) NOT NULL,
    payment_method      ENUM('COD', 'MOMO', 'VNPAY', 'ZALOPAY', 'BANK_TRANSFER') NOT NULL DEFAULT 'COD',
    payment_status      ENUM('UNPAID', 'PAID', 'REFUNDED', 'FAILED') NOT NULL DEFAULT 'UNPAID',
    order_status        ENUM('PENDING', 'CONFIRMED', 'PREPARING', 'SHIPPING', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
    note                VARCHAR(500),
    created_at          DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_order_user    FOREIGN KEY (user_id)    REFERENCES users (id)    ON DELETE SET NULL,
    CONSTRAINT fk_order_branch  FOREIGN KEY (branch_id)  REFERENCES branches (id) ON DELETE RESTRICT,
    CONSTRAINT fk_order_voucher FOREIGN KEY (voucher_id) REFERENCES vouchers (id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- Snapshot of each ordered drink at the time of purchase
CREATE TABLE order_items (
    id                  BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id            BIGINT         NOT NULL,
    product_id          BIGINT,
    product_name        VARCHAR(150)   NOT NULL,
    size_name           ENUM('S', 'M', 'L') NOT NULL,
    sugar_level         ENUM('0%', '30%', '50%', '70%', '100%') NOT NULL,
    ice_level           ENUM('0%', '30%', '50%', '70%', '100%') NOT NULL,
    unit_price          DECIMAL(12, 2) NOT NULL,
    topping_total_price DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    quantity            INT            NOT NULL CHECK (quantity > 0),
    line_total          DECIMAL(12, 2) NOT NULL,
    note                VARCHAR(255),
    CONSTRAINT fk_oi_order   FOREIGN KEY (order_id)   REFERENCES orders (id)   ON DELETE CASCADE,
    CONSTRAINT fk_oi_product FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- Snapshot of toppings attached to each ordered drink
CREATE TABLE order_item_toppings (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_item_id   BIGINT         NOT NULL,
    topping_id      BIGINT,
    topping_name    VARCHAR(100)   NOT NULL,
    topping_price   DECIMAL(12, 2) NOT NULL,
    quantity        INT            NOT NULL DEFAULT 1,
    CONSTRAINT fk_oit_order_item FOREIGN KEY (order_item_id) REFERENCES order_items (id) ON DELETE CASCADE,
    CONSTRAINT fk_oit_topping    FOREIGN KEY (topping_id)    REFERENCES toppings (id)    ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE payment_transactions (
    id                  BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id            BIGINT         NOT NULL,
    provider            ENUM('COD', 'MOMO', 'VNPAY', 'ZALOPAY', 'BANK_TRANSFER') NOT NULL,
    transaction_ref     VARCHAR(100)   UNIQUE,
    amount              DECIMAL(12, 2) NOT NULL,
    status              ENUM('PENDING', 'SUCCESS', 'FAILED', 'REFUNDED') NOT NULL DEFAULT 'PENDING',
    paid_at             DATETIME,
    created_at          DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_payment_order
        FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- 7. REVIEWS & SUPPORT TICKETS (ĐÁNH GIÁ & HỖ TRỢ)
-- ============================================================

CREATE TABLE reviews (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT   NOT NULL,
    product_id      BIGINT   NOT NULL,
    order_id        BIGINT   NOT NULL,
    rating          TINYINT  NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment         TEXT,
    is_visible      BOOLEAN  NOT NULL DEFAULT TRUE,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_review_once (user_id, product_id, order_id),
    CONSTRAINT fk_review_user    FOREIGN KEY (user_id)    REFERENCES users (id)    ON DELETE CASCADE,
    CONSTRAINT fk_review_product FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
    CONSTRAINT fk_review_order   FOREIGN KEY (order_id)   REFERENCES orders (id)   ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE support_tickets (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT,
    order_id        BIGINT,
    full_name       VARCHAR(100) NOT NULL,
    email           VARCHAR(150) NOT NULL,
    phone           VARCHAR(20),
    subject         VARCHAR(200) NOT NULL,
    message         TEXT         NOT NULL,
    status          ENUM('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED') NOT NULL DEFAULT 'OPEN',
    created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ticket_user  FOREIGN KEY (user_id)  REFERENCES users (id)  ON DELETE SET NULL,
    CONSTRAINT fk_ticket_order FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================================
-- 8. INDEXES FOR QUERY PERFORMANCE
-- ============================================================

CREATE INDEX idx_products_category_active ON products (category_id, is_active);
CREATE INDEX idx_products_featured        ON products (is_featured, is_active);
CREATE INDEX idx_orders_user_created      ON orders (user_id, created_at DESC);
CREATE INDEX idx_orders_branch_status     ON orders (branch_id, order_status);
CREATE INDEX idx_reviews_product          ON reviews (product_id, is_visible);

-- ============================================================
-- 9. SEED DATA (BRANCHES, CATEGORIES, PRODUCTS, SIZES, TOPPINGS)
-- ============================================================

INSERT INTO branches (id, code, name, phone, address_line, district, city, latitude, longitude, open_time, close_time, is_active) VALUES
(1, 'UTE-TD-01', 'UTETra Thủ Đức - Võ Văn Ngân', '02838968641', '1 Võ Văn Ngân, Phường Linh Chiểu', 'TP. Thủ Đức', 'TP. Hồ Chí Minh', 10.8506320, 106.7719130, '07:00:00', '22:00:00', TRUE),
(2, 'UTE-Q1-01', 'UTETra Quận 1 - Nguyễn Huệ', '02838225566', '68 Nguyễn Huệ, Phường Bến Nghé', 'Quận 1', 'TP. Hồ Chí Minh', 10.7743890, 106.7035160, '07:30:00', '22:30:00', TRUE);

INSERT INTO categories (id, name, slug, description, display_order, is_active) VALUES
(1, 'Trà sữa', 'tra-sua', 'Trà sữa truyền thống và hiện đại pha mới mỗi ngày', 1, TRUE),
(2, 'Kem Cheese', 'kem-cheese', 'Trà nguyên lá phủ lớp kem phô mai mặn béo mịn màng', 2, TRUE),
(3, 'Matcha & Latte', 'matcha-latte', 'Matcha Nhật Bản và các dòng Latte sữa tươi thanh trùng', 3, TRUE),
(4, 'Trà trái cây', 'tra-trai-cay', 'Trà thanh mát kết hợp trái cây tươi nhiệt đới', 4, TRUE);

INSERT INTO products (id, category_id, sku, name, slug, description, image_url, base_price, is_featured, is_active) VALUES
(1, 1, 'UTE-TS-001', 'Trà Sữa Trân Châu Đường Đen', 'tra-sua-tran-chau-duong-den', 'Sữa tươi béo ngậy hòa quyện cùng trân châu đường đen dẻo thơm. Trân châu được ninh kỹ cùng đường đen Hàn Quốc tạo độ bóng mượt, ấm nóng quyện cùng sữa tươi mát lạnh.', 'https://images.unsplash.com/photo-1525385133512-2f3bdd039054?auto=format&fit=crop&w=600&q=80', 45000.00, TRUE, TRUE),
(2, 2, 'UTE-KC-002', 'Trà Oolong Kem Cheese', 'tra-oolong-kem-cheese', 'Oolong rang thơm nồng phủ lớp kem cheese mặn mịn béo. Lá trà Oolong cao nguyên được ủ ở nhiệt độ chuẩn, giữ trọn hậu vị ngọt thanh tự nhiên kết hợp lớp kem phô mai đánh bông mịn màng mỗi ngày.', 'https://images.unsplash.com/photo-1541696490-8744a5dc0228?auto=format&fit=crop&w=600&q=80', 49000.00, TRUE, TRUE),
(3, 3, 'UTE-ML-003', 'Matcha Latte Đậu Đỏ', 'matcha-latte-dau-do', 'Matcha Uji Nhật Bản kết hợp đậu đỏ ninh mềm ngọt dịu. Bột trà xanh nguyên chất đánh tan cùng sữa tươi thanh trùng mát lạnh và hạt đậu đỏ bùi thơm nấu thủ công.', 'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?auto=format&fit=crop&w=600&q=80', 52000.00, TRUE, TRUE),
(4, 4, 'UTE-TC-004', 'Trà Đào Cam Sả', 'tra-dao-cam-sa', 'Trà đen thanh mát cùng đào miếng giòn ngọt, cam vàng tươi mọng nước và hương sả thơm dịu, mang lại cảm giác sảng khoái tức thì cho ngày dài năng động.', 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?auto=format&fit=crop&w=600&q=80', 42000.00, TRUE, TRUE),
(5, 1, 'UTE-TS-005', 'Trà Sữa Oolong Kem Cheese', 'tra-sua-oolong-kem-cheese', 'Lá trà nguyên chất, sữa tươi thanh trùng cùng trân châu nấu thủ công mỗi sáng. Sự giao thoa hoàn hảo giữa vị trà sữa Oolong đậm đà và lớp kem cheese béo mặn đặc trưng của UTETra.', 'https://images.unsplash.com/photo-1558857563-b371033873b8?auto=format&fit=crop&w=800&q=80', 55000.00, FALSE, TRUE),
(6, 1, 'UTE-TS-006', 'Trà Sữa Truyền Thống Hoàng Gia', 'tra-sua-truyen-thong-hoang-gia', 'Hồng trà Assam đậm vị kết hợp sữa tươi béo dịu cùng trân châu đen dẻo dai chuẩn vị truyền thống.', 'https://images.unsplash.com/photo-1525385133512-2f3bdd039054?auto=format&fit=crop&w=600&q=80', 40000.00, FALSE, TRUE),
(7, 1, 'UTE-TS-007', 'Trà Sữa Khoai Môn Tươi', 'tra-sua-khoai-mon-tuoi', 'Khoai môn tươi nghiền mịn nấu thủ công mỗi ngày quyện cùng sữa tươi thanh trùng thơm bùi tự nhiên.', 'https://images.unsplash.com/photo-1558857563-b371033873b8?auto=format&fit=crop&w=800&q=80', 48000.00, FALSE, TRUE),
(8, 1, 'UTE-TS-008', 'Trà Sữa Socola Hạt Dẻ', 'tra-sua-socola-hat-de', 'Socola nguyên chất Bỉ kết hợp hương hạt dẻ rang thơm lừng và lớp sữa tươi sánh mịn.', 'https://images.unsplash.com/photo-1541696490-8744a5dc0228?auto=format&fit=crop&w=600&q=80', 50000.00, FALSE, TRUE),
(9, 1, 'UTE-TS-009', 'Trà Sữa Bá Tước Earl Grey', 'tra-sua-ba-tuoc-earl-grey', 'Trà đen Bá Tước ướp tinh dầu cam Bergamot thanh lịch pha cùng sữa tươi ít ngọt.', 'https://images.unsplash.com/photo-1525385133512-2f3bdd039054?auto=format&fit=crop&w=600&q=80', 46000.00, FALSE, TRUE),
(10, 1, 'UTE-TS-010', 'Trà Sữa Pudding Trứng Nướng', 'tra-sua-pudding-trung-nuong', 'Trà sữa Oolong thơm dịu đi kèm lớp pudding trứng mềm mịn tan ngay đầu lưỡi.', 'https://images.unsplash.com/photo-1558857563-b371033873b8?auto=format&fit=crop&w=800&q=80', 49000.00, FALSE, TRUE),
(11, 2, 'UTE-KC-011', 'Hồng Trà Kem Cheese Bông Tuyết', 'hong-tra-kem-cheese-bong-tuyet', 'Hồng trà ủ lạnh thanh khiết phủ lớp kem phô mai mặn béo đánh bông như mây.', 'https://images.unsplash.com/photo-1541696490-8744a5dc0228?auto=format&fit=crop&w=600&q=80', 47000.00, FALSE, TRUE),
(12, 2, 'UTE-KC-012', 'Lục Trà Nhài Kem Cheese', 'luc-tra-nhai-kem-cheese', 'Lục trà ướp hoa nhài tươi thơm ngát kết hợp kem cheese sánh mịn hài hòa.', 'https://images.unsplash.com/photo-1541696490-8744a5dc0228?auto=format&fit=crop&w=600&q=80', 46000.00, FALSE, TRUE),
(13, 2, 'UTE-KC-013', 'Trà Đen Macchiato Kem Phô Mai', 'tra-den-macchiato-kem-pho-mai', 'Trà đen đậm đà quyện cùng lớp bọt kem macchiato phô mai béo ngậy.', 'https://images.unsplash.com/photo-1558857563-b371033873b8?auto=format&fit=crop&w=800&q=80', 48000.00, FALSE, TRUE),
(14, 2, 'UTE-KC-014', 'Trà Thiết Quan Âm Kem Cheese', 'tra-thiet-quan-am-kem-cheese', 'Trà Thiết Quan Âm nướng thơm sâu lắng cùng lớp kem cheese mặn dịu.', 'https://images.unsplash.com/photo-1541696490-8744a5dc0228?auto=format&fit=crop&w=600&q=80', 52000.00, FALSE, TRUE),
(15, 2, 'UTE-KC-015', 'Cacao Dầm Kem Cheese Hạnh Nhân', 'cacao-dam-kem-cheese-hanh-nhan', 'Cacao nguyên chất đậm vị phủ kem cheese và hạnh nhân lát nướng giòn rụm.', 'https://images.unsplash.com/photo-1525385133512-2f3bdd039054?auto=format&fit=crop&w=600&q=80', 54000.00, FALSE, TRUE),
(16, 3, 'UTE-ML-016', 'Matcha Macchiato Kem Phô Mai', 'matcha-macchiato-kem-pho-mai', 'Trà xanh Matcha Nhật Bản kết hợp lớp kem phô mai macchiato mặn ngọt cân bằng.', 'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?auto=format&fit=crop&w=600&q=80', 55000.00, FALSE, TRUE),
(17, 3, 'UTE-ML-017', 'Hojicha Latte Sữa Tươi', 'hojicha-latte-sua-tuoi', 'Trà xanh rang Hojicha thơm hương khói nhẹ nhàng hòa quyện cùng sữa tươi thanh trùng.', 'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?auto=format&fit=crop&w=600&q=80', 51000.00, FALSE, TRUE),
(18, 3, 'UTE-ML-018', 'Matcha Đá Xay Kem Tươi', 'matcha-da-xay-kem-tuoi', 'Matcha Uji xay nhuyễn mát lạnh phủ lớp kem tươi whipping mềm mịn.', 'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?auto=format&fit=crop&w=600&q=80', 58000.00, FALSE, TRUE),
(19, 3, 'UTE-ML-019', 'Sữa Tươi Trân Châu Đường Đen Latte', 'sua-tuoi-tran-chau-duong-den-latte', 'Sữa tươi nguyên kem thanh mát rót trên nền trân châu đường đen nấu ấm.', 'https://images.unsplash.com/photo-1525385133512-2f3bdd039054?auto=format&fit=crop&w=600&q=80', 49000.00, FALSE, TRUE),
(20, 3, 'UTE-ML-020', 'Matcha Sữa Yến Mạch Thuần Chay', 'matcha-sua-yen-mach-thuan-chay', 'Sự kết hợp lành mạnh giữa Matcha nguyên chất và sữa yến mạch thơm béo tự nhiên.', 'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?auto=format&fit=crop&w=600&q=80', 56000.00, FALSE, TRUE),
(21, 4, 'UTE-TC-021', 'Trà Vải Hoa Hồng Thanh Mát', 'tra-vai-hoa-hong-thanh-mat', 'Trà hoa hồng thơm dịu kết hợp trái vải ngâm giòn ngọt giải nhiệt ngày hè.', 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?auto=format&fit=crop&w=600&q=80', 45000.00, FALSE, TRUE),
(22, 4, 'UTE-TC-022', 'Trà Nhiệt Đới Bốn Mùa', 'tra-nhiet-doi-bon-mua', 'Lục trà nhài kết hợp cam, chanh dây, dưa hấu và đào tươi giàu vitamin.', 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?auto=format&fit=crop&w=600&q=80', 47000.00, FALSE, TRUE),
(23, 4, 'UTE-TC-023', 'Trà Dâu Tằm Pha Lê Tuyết', 'tra-dau-tam-pha-le-tuyet', 'Mứt dâu tằm Đà Lạt chua ngọt tự nhiên cùng thạch pha lê giòn sần sật.', 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?auto=format&fit=crop&w=600&q=80', 44000.00, FALSE, TRUE),
(24, 4, 'UTE-TC-024', 'Trà Xoài Chanh Dây Nha Đam', 'tra-xoai-chanh-day-nha-dam', 'Vị xoài chín ngọt ngào hòa quyện cùng chanh dây chua dịu và nha đam tươi mát.', 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?auto=format&fit=crop&w=600&q=80', 46000.00, FALSE, TRUE),
(25, 4, 'UTE-TC-025', 'Trà Ổi Hồng Muối Ớt', 'tra-oi-hong-muoi-ot', 'Nước ép ổi hồng tươi kết hợp lục trà thanh mát tạo hương vị độc đáo cuốn hút.', 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?auto=format&fit=crop&w=600&q=80', 43000.00, FALSE, TRUE);

INSERT INTO product_sizes (product_id, size_name, extra_price) VALUES
(1, 'S', 0.00), (1, 'M', 5000.00), (1, 'L', 10000.00),
(2, 'S', 0.00), (2, 'M', 5000.00), (2, 'L', 10000.00),
(3, 'S', 0.00), (3, 'M', 5000.00), (3, 'L', 10000.00),
(4, 'S', 0.00), (4, 'M', 5000.00), (4, 'L', 10000.00),
(5, 'S', 0.00), (5, 'M', 5000.00), (5, 'L', 10000.00),
(6, 'S', 0.00), (6, 'M', 5000.00), (6, 'L', 10000.00),
(7, 'S', 0.00), (7, 'M', 5000.00), (7, 'L', 10000.00),
(8, 'S', 0.00), (8, 'M', 5000.00), (8, 'L', 10000.00),
(9, 'S', 0.00), (9, 'M', 5000.00), (9, 'L', 10000.00),
(10, 'S', 0.00), (10, 'M', 5000.00), (10, 'L', 10000.00),
(11, 'S', 0.00), (11, 'M', 5000.00), (11, 'L', 10000.00),
(12, 'S', 0.00), (12, 'M', 5000.00), (12, 'L', 10000.00),
(13, 'S', 0.00), (13, 'M', 5000.00), (13, 'L', 10000.00),
(14, 'S', 0.00), (14, 'M', 5000.00), (14, 'L', 10000.00),
(15, 'S', 0.00), (15, 'M', 5000.00), (15, 'L', 10000.00),
(16, 'S', 0.00), (16, 'M', 5000.00), (16, 'L', 10000.00),
(17, 'S', 0.00), (17, 'M', 5000.00), (17, 'L', 10000.00),
(18, 'S', 0.00), (18, 'M', 5000.00), (18, 'L', 10000.00),
(19, 'S', 0.00), (19, 'M', 5000.00), (19, 'L', 10000.00),
(20, 'S', 0.00), (20, 'M', 5000.00), (20, 'L', 10000.00),
(21, 'S', 0.00), (21, 'M', 5000.00), (21, 'L', 10000.00),
(22, 'S', 0.00), (22, 'M', 5000.00), (22, 'L', 10000.00),
(23, 'S', 0.00), (23, 'M', 5000.00), (23, 'L', 10000.00),
(24, 'S', 0.00), (24, 'M', 5000.00), (24, 'L', 10000.00),
(25, 'S', 0.00), (25, 'M', 5000.00), (25, 'L', 10000.00);

INSERT INTO toppings (id, name, price, is_available) VALUES
(1, 'Trân châu đường đen', 10000.00, TRUE),
(2, 'Kem cheese macchiato', 12000.00, TRUE),
(3, 'Đậu đỏ Nhật Bản', 10000.00, TRUE),
(4, 'Thạch đào', 8000.00, TRUE),
(5, 'Pudding trứng', 10000.00, TRUE);

INSERT INTO product_toppings (product_id, topping_id) VALUES
(1, 1), (1, 2), (1, 5),
(2, 1), (2, 2), (2, 5),
(3, 1), (3, 2), (3, 3), (3, 5),
(4, 4),
(5, 1), (5, 2), (5, 5),
(6, 1), (6, 5),
(7, 1), (7, 5),
(8, 1), (8, 2), (8, 5),
(9, 1), (9, 2),
(10, 1), (10, 5),
(11, 2), (11, 5),
(12, 2),
(13, 1), (13, 2),
(14, 2),
(15, 2), (15, 5),
(16, 2), (16, 3),
(17, 1), (17, 3),
(18, 3), (18, 5),
(19, 1), (19, 5),
(20, 3),
(21, 4),
(22, 4),
(23, 4),
(24, 4),
(25, 4);

INSERT INTO branch_product_status (branch_id, product_id, is_available) VALUES
(1, 1, TRUE), (1, 2, TRUE), (1, 3, TRUE), (1, 4, TRUE), (1, 5, TRUE),
(1, 6, TRUE), (1, 7, TRUE), (1, 8, TRUE), (1, 9, TRUE), (1, 10, TRUE),
(1, 11, TRUE), (1, 12, TRUE), (1, 13, TRUE), (1, 14, TRUE), (1, 15, TRUE),
(1, 16, TRUE), (1, 17, TRUE), (1, 18, TRUE), (1, 19, TRUE), (1, 20, TRUE),
(1, 21, TRUE), (1, 22, TRUE), (1, 23, TRUE), (1, 24, TRUE), (1, 25, TRUE),
(2, 1, TRUE), (2, 2, TRUE), (2, 3, TRUE), (2, 4, TRUE), (2, 5, TRUE),
(2, 6, TRUE), (2, 7, FALSE), (2, 8, TRUE), (2, 9, TRUE), (2, 10, TRUE),
(2, 11, TRUE), (2, 12, FALSE), (2, 13, TRUE), (2, 14, TRUE), (2, 15, TRUE),
(2, 16, TRUE), (2, 17, TRUE), (2, 18, FALSE), (2, 19, TRUE), (2, 20, TRUE),
(2, 21, TRUE), (2, 22, TRUE), (2, 23, TRUE), (2, 24, FALSE), (2, 25, TRUE);

