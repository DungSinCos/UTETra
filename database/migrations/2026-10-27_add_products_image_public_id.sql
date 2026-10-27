-- Run once on databases created BEFORE this change (new databases get the column from UTETra.sql).
-- Needed so the app can delete the old Cloudinary image when a product image is replaced.
-- Note: with spring.jpa.hibernate.ddl-auto=update Hibernate also adds this column on startup;
-- this script is for teammates who prefer to apply schema changes explicitly.
USE UTETra;

ALTER TABLE products
    ADD COLUMN image_public_id VARCHAR(255) NULL AFTER image_url;
