package com.UTETra.app.repository;

import com.UTETra.app.entity.Topping;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ToppingRepository extends JpaRepository<Topping, Long> {

    @Query(value = "SELECT t.* FROM toppings t " +
                   "INNER JOIN product_toppings pt ON t.id = pt.topping_id " +
                   "WHERE pt.product_id = :productId AND t.is_available = TRUE " +
                   "ORDER BY t.id ASC", nativeQuery = true)
    List<Topping> findAvailableByProductId(@Param("productId") Long productId);
}
