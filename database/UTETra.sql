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
