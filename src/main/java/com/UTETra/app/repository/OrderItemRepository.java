package com.UTETra.app.repository;

import com.UTETra.app.entity.OrderItem;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface OrderItemRepository extends JpaRepository<OrderItem, Long> {

    @EntityGraph(attributePaths = "toppings")
    List<OrderItem> findByOrder_IdOrderByIdAsc(Long orderId);
}
