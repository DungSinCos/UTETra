package com.UTETra.app.dto;

/**
 * Result of an upload to Cloudinary.
 *
 * @param secureUrl public https URL, store this in the database (e.g. products.image_url)
 * @param publicId  Cloudinary id, keep it if you need to delete or transform the image later
 */
public record UploadResult(String secureUrl, String publicId) {
}
