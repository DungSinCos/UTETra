package com.UTETra.app.service;

import com.UTETra.app.entity.Product;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

/**
 * Contract for product business logic. Controllers (public menu, admin, cart...) depend on this
 * interface, never on the implementation.
 */
public interface ProductService {

    // ---- Read side (public menu) ----

    /** Products on sale, ordered by name. */
    List<Product> findActive();

    List<Product> findActiveByCategory(Long categoryId);

    List<Product> findFeatured();

    /** @throws com.UTETra.app.exception.ResourceNotFoundException if no product has this id */
    Product getById(Long id);

    /** @throws com.UTETra.app.exception.ResourceNotFoundException if no product has this slug */
    Product getBySlug(String slug);

    // ---- Admin side ----

    /** All products including hidden ones. */
    List<Product> findAll();

    long countActive();

    /**
     * Creates a product. Generates a slug from the name when blank; uploads the image when provided.
     *
     * @throws IllegalArgumentException if sku/slug already exists or a required field is missing
     */
    Product create(Product product, MultipartFile image);

    /** Updates editable fields. Keeps the current image unless a new one is provided. */
    Product update(Long id, Product changes, MultipartFile image);

    /** Soft delete: hides the product from the menu but keeps order history intact. */
    void deactivate(Long id);

    void activate(Long id);
}
