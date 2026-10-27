package com.UTETra.app.repository;

import com.UTETra.app.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface CategoryRepository extends JpaRepository<Category, Long> {

    List<Category> findByActiveTrueOrderByDisplayOrderAsc();

    List<Category> findByActiveTrueOrderByDisplayOrderAscIdAsc();

    List<Category> findAllByOrderByDisplayOrderAscIdAsc();

    Optional<Category> findBySlug(String slug);

    boolean existsBySlug(String slug);

    boolean existsBySlugAndIdNot(String slug, Long id);
}
