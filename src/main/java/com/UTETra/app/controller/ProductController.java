package com.UTETra.app.controller;

import com.UTETra.app.dto.BranchAvailability;
import com.UTETra.app.entity.Branch;
import com.UTETra.app.entity.Category;
import com.UTETra.app.entity.Product;
import com.UTETra.app.repository.BranchRepository;
import com.UTETra.app.repository.CategoryRepository;
import com.UTETra.app.repository.ProductSizeRepository;
import com.UTETra.app.repository.ToppingRepository;
import com.UTETra.app.service.ProductService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Public, read-only product pages backed by the database.
 * Writes live in AdminProductController (/admin/products).
 */
@Controller
@RequestMapping("/products")
public class ProductController {

    private final ProductService productService;
    private final CategoryRepository categoryRepository;
    private final ProductSizeRepository productSizeRepository;
    private final ToppingRepository toppingRepository;
    private final BranchRepository branchRepository;

    public ProductController(ProductService productService,
                             CategoryRepository categoryRepository,
                             ProductSizeRepository productSizeRepository,
                             ToppingRepository toppingRepository,
                             BranchRepository branchRepository) {
        this.productService = productService;
        this.categoryRepository = categoryRepository;
        this.productSizeRepository = productSizeRepository;
        this.toppingRepository = toppingRepository;
        this.branchRepository = branchRepository;
    }

    /** GET /products or GET /products?categoryId=1 */
    @GetMapping
    public String list(@RequestParam(required = false) Long categoryId,
                       @RequestParam(required = false) String category,
                       Model model) {
        List<Category> categories = categoryRepository.findByActiveTrueOrderByDisplayOrderAsc();
        Map<Long, String> categorySlugMap = new HashMap<>();
        for (Category c : categories) {
            categorySlugMap.put(c.getId(), c.getSlug());
        }

        List<Product> products = (categoryId == null)
                ? productService.findActive()
                : productService.findActiveByCategory(categoryId);

        model.addAttribute("categories", categories);
        model.addAttribute("categorySlugMap", categorySlugMap);
        model.addAttribute("products", products);
        model.addAttribute("categoryId", categoryId);
        model.addAttribute("selectedCategory", category != null ? category : "all");
        return "products/list"; // /WEB-INF/views/products/list.jsp
    }

    /** GET /products/{id} */
    @GetMapping("/{id}")
    public String detail(@PathVariable("id") Long id, Model model) {
        Product product = productService.getById(id);
        List<Product> relatedProducts = productService.findActive().stream()
                .filter(p -> !p.getId().equals(id))
                .limit(4)
                .toList();

        List<Branch> activeBranches = branchRepository.findByActiveTrueOrderByIdAsc();
        Set<Long> availableBranchIds = new HashSet<>(branchRepository.findAvailableBranchIdsByProductId(id));
        List<BranchAvailability> branchOptions = new ArrayList<>();
        Long firstAvailableBranchId = null;

        for (Branch b : activeBranches) {
            boolean isAvailable = availableBranchIds.contains(b.getId());
            if (isAvailable && firstAvailableBranchId == null) {
                firstAvailableBranchId = b.getId();
            }
            branchOptions.add(new BranchAvailability(b.getId(), b.getName(), isAvailable));
        }

        model.addAttribute("productId", id);
        model.addAttribute("product", product);
        model.addAttribute("sizes", productSizeRepository.findByProductIdOrderByIdAsc(id));
        model.addAttribute("toppings", toppingRepository.findAvailableByProductId(id));
        model.addAttribute("branchOptions", branchOptions);
        model.addAttribute("firstAvailableBranchId", firstAvailableBranchId);
        model.addAttribute("relatedProducts", relatedProducts);
        return "products/detail"; // /WEB-INF/views/products/detail.jsp
    }
}
