package com.UTETra.app.service;

import com.UTETra.app.entity.Category;

import java.util.List;

/** Business operations for product categories. Categories are hidden, never physically deleted. */
public interface CategoryService {

    List<Category> findAll();

    List<Category> findActive();

    Category getById(Long id);

    Category create(Category category);

    Category update(Long id, Category changes);

    void deactivate(Long id);

    void activate(Long id);
}
