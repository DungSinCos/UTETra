package com.UTETra.app.repository;

import com.UTETra.app.entity.OrderItemTopping;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface OrderItemToppingRepository extends JpaRepository<OrderItemTopping, Long> {

    List<OrderItemTopping> findByOrderItem_IdOrderByIdAsc(Long orderItemId);
}
