package com.UTETra.app.repository;

import com.UTETra.app.entity.ProductSize;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ProductSizeRepository extends JpaRepository<ProductSize, Long> {

    List<ProductSize> findByProductIdOrderByIdAsc(Long productId);
}
