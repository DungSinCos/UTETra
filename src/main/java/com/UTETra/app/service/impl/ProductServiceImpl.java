package com.UTETra.app.service.impl;

import com.UTETra.app.dto.UploadResult;
import com.UTETra.app.entity.Product;
import com.UTETra.app.exception.ResourceNotFoundException;
import com.UTETra.app.repository.ProductRepository;
import com.UTETra.app.service.CloudinaryService;
import com.UTETra.app.service.ProductService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import org.springframework.web.multipart.MultipartFile;

import java.math.BigDecimal;
import java.text.Normalizer;
import java.util.List;
import java.util.Locale;

@Service
@Transactional
public class ProductServiceImpl implements ProductService {

    private static final Logger log = LoggerFactory.getLogger(ProductServiceImpl.class);

    private final ProductRepository productRepository;
    private final CloudinaryService cloudinaryService;

    public ProductServiceImpl(ProductRepository productRepository, CloudinaryService cloudinaryService) {
        this.productRepository = productRepository;
        this.cloudinaryService = cloudinaryService;
    }

    // ---------------------------------------------------------------- read side

    @Override
    @Transactional(readOnly = true)
    public List<Product> findActive() {
        return productRepository.findByActiveTrueOrderByIdAsc();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Product> findActiveByCategory(Long categoryId) {
        return productRepository.findByActiveTrueAndCategoryIdOrderByIdAsc(categoryId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Product> findFeatured() {
        return productRepository.findByActiveTrueAndFeaturedTrueOrderByIdAsc();
    }

    @Override
    @Transactional(readOnly = true)
    public Product getById(Long id) {
        return productRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Product", id));
    }

    @Override
    @Transactional(readOnly = true)
    public Product getBySlug(String slug) {
        return productRepository.findBySlug(slug)
                .orElseThrow(() -> new ResourceNotFoundException("Product", slug));
    }

    // --------------------------------------------------------------- admin side

    @Override
    @Transactional(readOnly = true)
    public List<Product> findAll() {
        return productRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public long countActive() {
        return productRepository.countByActiveTrue();
    }

    @Override
    public Product create(Product product, MultipartFile image) {
        requireText(product.getName(), "Tên sản phẩm không được để trống");
        requireText(product.getSku(), "SKU không được để trống");
        if (product.getCategoryId() == null) {
            throw new IllegalArgumentException("Vui lòng chọn danh mục");
        }
        requirePrice(product.getBasePrice());

        product.setId(null); // guarantees an INSERT, never an accidental overwrite
        product.setSku(product.getSku().trim());
        if (productRepository.existsBySku(product.getSku())) {
            throw new IllegalArgumentException("SKU đã tồn tại: " + product.getSku());
        }

        String slug = isBlank(product.getSlug()) ? slugify(product.getName()) : slugify(product.getSlug());
        if (productRepository.existsBySlug(slug)) {
            throw new IllegalArgumentException("Slug đã tồn tại: " + slug);
        }
        product.setSlug(slug);

        // Image fields are never taken from the submitted form: they only come from an upload.
        product.setImageUrl(null);
        product.setImagePublicId(null);
        applyImage(product, image);
        return productRepository.save(product);
    }

    @Override
    public Product update(Long id, Product changes, MultipartFile image) {
        Product existing = getById(id);

        requireText(changes.getName(), "Tên sản phẩm không được để trống");
        if (changes.getCategoryId() == null) {
            throw new IllegalArgumentException("Vui lòng chọn danh mục");
        }
        requirePrice(changes.getBasePrice());

        // sku and slug are identifiers used in URLs and orders, so they are not editable here.
        existing.setName(changes.getName().trim());
        existing.setDescription(changes.getDescription());
        existing.setCategoryId(changes.getCategoryId());
        existing.setBasePrice(changes.getBasePrice());
        existing.setFeatured(changes.isFeatured());
        existing.setActive(changes.isActive());

        applyImage(existing, image);
        return productRepository.save(existing);
    }

    @Override
    public void deactivate(Long id) {
        getById(id).setActive(false); // managed entity: flushed at commit
    }

    @Override
    public void activate(Long id) {
        getById(id).setActive(true);
    }

    // ------------------------------------------------------------------ helpers

    /**
     * Uploads the image only when one was actually chosen; otherwise leaves the current image
     * (url and public id) untouched.
     * <p>
     * Cloudinary is not part of the database transaction, so cleanup is tied to its outcome:
     * the new image is uploaded first, and the old one is deleted only after the commit succeeded.
     * If the transaction rolls back, the freshly uploaded image is deleted instead. The image that
     * is still referenced by the database is therefore never removed early.
     */
    private void applyImage(Product product, MultipartFile image) {
        if (image == null || image.isEmpty()) {
            return;
        }
        String oldPublicId = product.getImagePublicId();
        UploadResult uploaded = cloudinaryService.uploadImage(image, CloudinaryService.FOLDER_PRODUCTS);
        product.setImageUrl(uploaded.secureUrl());
        product.setImagePublicId(uploaded.publicId());
        deleteImagesAfterTransaction(oldPublicId, uploaded.publicId());
    }

    private void deleteImagesAfterTransaction(String oldPublicId, String newPublicId) {
        if (!TransactionSynchronizationManager.isSynchronizationActive()) {
            return; // not running inside a transaction (should not happen: the class is @Transactional)
        }
        TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
            @Override
            public void afterCompletion(int status) {
                if (status == STATUS_COMMITTED) {
                    deleteQuietly(oldPublicId, newPublicId);
                } else {
                    deleteQuietly(newPublicId, null); // rolled back: drop the upload nobody references
                }
            }
        });
    }

    /** Deletes an image, logging instead of throwing: a leftover image is only wasted storage. */
    private void deleteQuietly(String publicId, String keepPublicId) {
        if (publicId == null || publicId.isBlank() || publicId.equals(keepPublicId)) {
            return;
        }
        try {
            cloudinaryService.deleteImage(publicId);
        } catch (RuntimeException e) {
            log.warn("Could not delete Cloudinary image '{}', remove it manually later", publicId, e);
        }
    }

    private static void requireText(String value, String message) {
        if (isBlank(value)) {
            throw new IllegalArgumentException(message);
        }
    }

    private static void requirePrice(BigDecimal price) {
        if (price == null || price.signum() < 0) {
            throw new IllegalArgumentException("Giá phải lớn hơn hoặc bằng 0");
        }
    }

    private static boolean isBlank(String s) {
        return s == null || s.isBlank();
    }

    /** "Trà sữa Trân Châu" -> "tra-sua-tran-chau" */
    static String slugify(String input) {
        String s = Normalizer.normalize(input.trim(), Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "")
                .replace('đ', 'd').replace('Đ', 'D')
                .toLowerCase(Locale.ROOT)
                .replaceAll("[^a-z0-9]+", "-")
                .replaceAll("^-+|-+$", "");
        return s.isEmpty() ? "san-pham" : s;
    }
}
