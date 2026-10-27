package com.UTETra.app.service.impl;

import com.UTETra.app.entity.Category;
import com.UTETra.app.exception.ResourceNotFoundException;
import com.UTETra.app.repository.CategoryRepository;
import com.UTETra.app.service.CategoryService;
import com.UTETra.app.util.SlugUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class CategoryServiceImpl implements CategoryService {

    private final CategoryRepository categoryRepository;

    public CategoryServiceImpl(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Category> findAll() {
        return categoryRepository.findAllByOrderByDisplayOrderAscIdAsc();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Category> findActive() {
        return categoryRepository.findByActiveTrueOrderByDisplayOrderAscIdAsc();
    }

    @Override
    @Transactional(readOnly = true)
    public Category getById(Long id) {
        return categoryRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Category", id));
    }

    @Override
    public Category create(Category category) {
        validate(category);
        String slug = resolveSlug(category.getSlug(), category.getName());
        ensureSlugAvailable(slug, null);

        category.setId(null);
        category.setName(category.getName().trim());
        category.setSlug(slug);
        category.setDescription(blankToNull(category.getDescription()));
        category.setImageUrl(blankToNull(category.getImageUrl()));
        category.setActive(true);
        return categoryRepository.save(category);
    }

    @Override
    public Category update(Long id, Category changes) {
        Category existing = getById(id);
        validate(changes);

        String slug = resolveSlug(changes.getSlug(), changes.getName());
        ensureSlugAvailable(slug, id);

        existing.setName(changes.getName().trim());
        existing.setSlug(slug);
        existing.setDescription(blankToNull(changes.getDescription()));
        existing.setImageUrl(blankToNull(changes.getImageUrl()));
        existing.setDisplayOrder(changes.getDisplayOrder());
        return categoryRepository.save(existing);
    }

    @Override
    public void deactivate(Long id) {
        getById(id).setActive(false);
    }

    @Override
    public void activate(Long id) {
        getById(id).setActive(true);
    }

    private void validate(Category category) {
        if (category == null || category.getName() == null || category.getName().isBlank()) {
            throw new IllegalArgumentException("Tên danh mục không được để trống");
        }
        if (category.getName().trim().length() > 100) {
            throw new IllegalArgumentException("Tên danh mục tối đa 100 ký tự");
        }
        if (category.getDisplayOrder() < 0) {
            throw new IllegalArgumentException("Thứ tự hiển thị phải lớn hơn hoặc bằng 0");
        }
        if (category.getDescription() != null && category.getDescription().length() > 255) {
            throw new IllegalArgumentException("Mô tả danh mục tối đa 255 ký tự");
        }
        if (category.getImageUrl() != null && category.getImageUrl().length() > 500) {
            throw new IllegalArgumentException("Đường dẫn ảnh tối đa 500 ký tự");
        }
    }

    private String resolveSlug(String submittedSlug, String name) {
        String source = submittedSlug == null || submittedSlug.isBlank() ? name : submittedSlug;
        String slug = SlugUtil.slugify(source, "danh-muc");
        if (slug.length() > 120) {
            throw new IllegalArgumentException("Slug danh mục tối đa 120 ký tự");
        }
        return slug;
    }

    private void ensureSlugAvailable(String slug, Long currentId) {
        boolean exists = currentId == null
                ? categoryRepository.existsBySlug(slug)
                : categoryRepository.existsBySlugAndIdNot(slug, currentId);
        if (exists) {
            throw new IllegalArgumentException("Slug danh mục đã tồn tại: " + slug);
        }
    }

    private String blankToNull(String value) {
        return value == null || value.isBlank() ? null : value.trim();
    }
}
