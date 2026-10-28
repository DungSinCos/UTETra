-- MySQL 8 migration for OAuth provider metadata and one-time password reset tokens.
-- Apply once to an existing database before starting the updated application.
-- If Hibernate ddl-auto=update has already created these objects, do not run this file.

USE UTETra;

ALTER TABLE users
    ADD COLUMN auth_provider VARCHAR(20) NOT NULL DEFAULT 'LOCAL';

CREATE TABLE password_reset_tokens (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    token       VARCHAR(36) NOT NULL UNIQUE,
    user_id     BIGINT NOT NULL,
    expiry_date DATETIME NOT NULL,
    used        BOOLEAN NOT NULL DEFAULT FALSE,
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_password_reset_user
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB;
