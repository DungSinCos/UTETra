package com.UTETra.app.repository;

import com.UTETra.app.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ProductRepository extends JpaRepository<Product, Long> {

    /** Public menu: only products that are on sale. */
    List<Product> findByActiveTrueOrderByNameAsc();

    List<Product> findByActiveTrueAndCategoryIdOrderByNameAsc(Long categoryId);

    List<Product> findByActiveTrueAndFeaturedTrueOrderByNameAsc();

    Optional<Product> findBySlug(String slug);

    boolean existsBySku(String sku);

    boolean existsBySlug(String slug);

    long countByActiveTrue();
}
