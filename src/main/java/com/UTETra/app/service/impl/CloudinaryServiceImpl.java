package com.UTETra.app.service.impl;

import com.UTETra.app.dto.UploadResult;
import com.UTETra.app.exception.FileStorageException;
import com.UTETra.app.service.CloudinaryService;
import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Map;
import java.util.Set;

@Service
public class CloudinaryServiceImpl implements CloudinaryService {

    private static final Set<String> ALLOWED_TYPES =
            Set.of("image/jpeg", "image/png", "image/webp", "image/gif");
    private static final long MAX_SIZE_BYTES = 10L * 1024 * 1024; // keep in sync with spring.servlet.multipart.max-file-size

    private final Cloudinary cloudinary;

    public CloudinaryServiceImpl(Cloudinary cloudinary) {
        this.cloudinary = cloudinary;
    }

    @Override
    public UploadResult uploadImage(MultipartFile file, String folder) {
        validate(file);
        try {
            Map<?, ?> result = cloudinary.uploader().upload(
                    file.getBytes(),
                    ObjectUtils.asMap(
                            "folder", folder,
                            "resource_type", "image"));
            return new UploadResult(
                    String.valueOf(result.get("secure_url")),
                    String.valueOf(result.get("public_id")));
        } catch (IOException | RuntimeException e) {
            // Cloudinary throws unchecked exceptions for bad credentials or network errors
            throw new FileStorageException("Upload ảnh thất bại, vui lòng thử lại", e);
        }
    }

    @Override
    public void deleteImage(String publicId) {
        if (publicId == null || publicId.isBlank()) {
            return;
        }
        try {
            cloudinary.uploader().destroy(publicId, ObjectUtils.emptyMap());
        } catch (IOException | RuntimeException e) {
            throw new FileStorageException("Xóa ảnh thất bại", e);
        }
    }

    private void validate(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new FileStorageException("Vui lòng chọn một file ảnh");
        }
        if (file.getSize() > MAX_SIZE_BYTES) {
            throw new FileStorageException("Ảnh vượt quá dung lượng tối đa 10MB");
        }
        String type = file.getContentType();
        if (type == null || !ALLOWED_TYPES.contains(type)) {
            throw new FileStorageException("Chỉ chấp nhận ảnh JPEG, PNG, WEBP hoặc GIF");
        }
    }
}
