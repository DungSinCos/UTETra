package com.UTETra.app.util;

import java.text.Normalizer;
import java.util.Locale;

/** Shared Vietnamese-friendly slug generation for products and categories. */
public final class SlugUtil {

    private SlugUtil() {
    }

    public static String slugify(String input) {
        return slugify(input, "san-pham");
    }

    public static String slugify(String input, String fallback) {
        if (input == null || input.isBlank()) {
            return fallback;
        }
        String slug = Normalizer.normalize(input.trim(), Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "")
                .replace('đ', 'd')
                .replace('Đ', 'D')
                .toLowerCase(Locale.ROOT)
                .replaceAll("[^a-z0-9]+", "-")
                .replaceAll("^-+|-+$", "");
        return slug.isEmpty() ? fallback : slug;
    }
}
