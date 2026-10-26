package com.UTETra.app.repository;

import com.UTETra.app.entity.Branch;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface BranchRepository extends JpaRepository<Branch, Long> {

    List<Branch> findByActiveTrueOrderByIdAsc();

    @Query(value = "SELECT b.branch_id FROM branch_product_status b " +
                   "WHERE b.product_id = :productId AND b.is_available = TRUE", nativeQuery = true)
    List<Long> findAvailableBranchIdsByProductId(@Param("productId") Long productId);
}
