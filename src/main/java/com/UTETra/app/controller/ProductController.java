package com.UTETra.app.controller;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ProductController {

    // TODO: dữ liệu mẫu để dựng giao diện, thay bằng ProductService/Repository khi có DB
    private static final List<Map<String, Object>> SAMPLE = List.of(
        item(1, "Trà sữa trân châu đường đen", "Trà sữa", 45000, "🧋", "Trà đen, sữa tươi, trân châu nấu đường đen."),
        item(2, "Trà sữa Thái xanh", "Trà sữa", 40000, "🧋", "Vị trà Thái đậm, béo nhẹ."),
        item(3, "Matcha latte", "Trà sữa", 49000, "🍵", "Matcha Nhật pha sữa, ít ngọt."),
        item(4, "Trà đào cam sả", "Trà trái cây", 42000, "🍑", "Đào miếng, cam vàng, sả thơm."),
        item(5, "Trà vải hoa hồng", "Trà trái cây", 44000, "🌸", "Vải thiều, hương hoa hồng thanh."),
        item(6, "Trà chanh mật ong", "Trà trái cây", 35000, "🍋", "Chanh tươi vắt, mật ong nguyên chất."),
        item(7, "Cà phê sữa đá", "Cà phê", 32000, "☕", "Cà phê phin đậm, sữa đặc."),
        item(8, "Bạc xỉu", "Cà phê", 34000, "☕", "Nhiều sữa, ít cà phê, dễ uống.")
    );

    @GetMapping("/products")
    public String products(@RequestParam(required = false) String category, Model model) {
        List<Map<String, Object>> list = SAMPLE;
        if (category != null && !category.isBlank()) {
            list = SAMPLE.stream()
                    .filter(p -> category.equals(p.get("category")))
                    .collect(Collectors.toList());
        }

        List<Object> categories = SAMPLE.stream()
                .map(p -> p.get("category"))
                .distinct()
                .collect(Collectors.toList());

        model.addAttribute("products", list);
        model.addAttribute("categories", categories);
        model.addAttribute("currentCategory", category);
        return "products";
    }

    private static Map<String, Object> item(int id, String name, String category, int price, String icon, String description) {
        return Map.of("id", id, "name", name, "category", category,
                "price", price, "icon", icon, "description", description);
    }
}
