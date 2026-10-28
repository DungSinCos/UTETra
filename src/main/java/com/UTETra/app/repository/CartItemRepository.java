package com.UTETra.app.repository;

import com.UTETra.app.entity.CartItem;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface CartItemRepository extends JpaRepository<CartItem, Long> {

    List<CartItem> findByCartIdOrderByIdAsc(Long cartId);

    Optional<CartItem> findByCartIdAndProductIdAndSizeName(Long cartId, Long productId, String sizeName);

    Optional<CartItem> findByIdAndCartId(Long id, Long cartId);
}
