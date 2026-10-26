package com.UTETra.app.service;

import com.UTETra.app.dto.UploadResult;
import org.springframework.web.multipart.MultipartFile;

/**
 * Contract for image storage. Any module (products, user avatars, banners...) injects this
 * interface and picks its own folder, so uploads never collide.
 */
public interface CloudinaryService {

    /** Folder names used across the app. Add new ones here so everybody shares the same convention. */
    String FOLDER_PRODUCTS = "utetra/products";
    String FOLDER_USERS = "utetra/users";
    String FOLDER_CATEGORIES = "utetra/categories";

    /**
     * Validates and uploads an image.
     *
     * @param file   the uploaded image (jpeg, png, webp, gif; max 10 MB)
     * @param folder target folder, usually one of the FOLDER_* constants
     * @throws com.UTETra.app.exception.FileStorageException if the file is invalid or the upload fails
     */
    UploadResult uploadImage(MultipartFile file, String folder);

    /** Deletes an image by its Cloudinary public id. Deleting a missing image is not an error. */
    void deleteImage(String publicId);
}
