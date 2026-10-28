package com.UTETra.app.repository;

import com.UTETra.app.entity.CustomerOrder;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Optional;

public interface OrderRepository extends JpaRepository<CustomerOrder, Long>, JpaSpecificationExecutor<CustomerOrder> {

    Page<CustomerOrder> findByUser_IdOrderByCreatedAtDesc(Long userId, Pageable pageable);

    @Override
    @EntityGraph(attributePaths = {"user", "branch"})
    Page<CustomerOrder> findAll(org.springframework.data.jpa.domain.Specification<CustomerOrder> spec,
                                Pageable pageable);

    @EntityGraph(attributePaths = {"user", "branch"})
    Optional<CustomerOrder> findWithCustomerAndBranchById(Long id);

    @EntityGraph(attributePaths = {"user", "branch"})
    Optional<CustomerOrder> findByOrderCode(String orderCode);

    Optional<CustomerOrder> findByOrderCodeAndRecipientPhone(String orderCode, String recipientPhone);

    @Query("""
            select count(o) from CustomerOrder o
            where (:fromDate is null or o.createdAt >= :fromDate)
              and (:toExclusive is null or o.createdAt < :toExclusive)
            """)
    long countInPeriod(@Param("fromDate") LocalDateTime fromDate,
                       @Param("toExclusive") LocalDateTime toExclusive);

    @Query("""
            select count(o) from CustomerOrder o
            where o.orderStatus = :status
              and (:fromDate is null or o.createdAt >= :fromDate)
              and (:toExclusive is null or o.createdAt < :toExclusive)
            """)
    long countByStatusInPeriod(@Param("status") CustomerOrder.OrderStatus status,
                               @Param("fromDate") LocalDateTime fromDate,
                               @Param("toExclusive") LocalDateTime toExclusive);

    @Query("""
            select sum(o.totalAmount) from CustomerOrder o
            where o.paymentStatus = :status
              and o.paidAt is not null
              and (:fromDate is null or o.paidAt >= :fromDate)
              and (:toExclusive is null or o.paidAt < :toExclusive)
            """)
    BigDecimal sumPaidRevenueInPeriod(@Param("status") CustomerOrder.PaymentStatus status,
                                      @Param("fromDate") LocalDateTime fromDate,
                                      @Param("toExclusive") LocalDateTime toExclusive);
}
