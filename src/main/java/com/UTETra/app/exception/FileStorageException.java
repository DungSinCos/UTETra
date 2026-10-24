package com.UTETra.app.exception;

/**
 * Thrown when a file is rejected (wrong type, too large, empty) or the upload to Cloudinary fails.
 * The message is safe to show to the user.
 */
public class FileStorageException extends RuntimeException {

    public FileStorageException(String message) {
        super(message);
    }

    public FileStorageException(String message, Throwable cause) {
        super(message, cause);
    }
}
