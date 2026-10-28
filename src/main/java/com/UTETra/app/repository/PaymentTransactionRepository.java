package com.UTETra.app.repository;

import com.UTETra.app.entity.PaymentTransaction;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface PaymentTransactionRepository extends JpaRepository<PaymentTransaction, Long> {

    List<PaymentTransaction> findByOrder_IdOrderByCreatedAtDesc(Long orderId);

    Optional<PaymentTransaction> findByTransactionRef(String transactionRef);

    Optional<PaymentTransaction> findTopByOrder_IdOrderByCreatedAtDesc(Long orderId);
}
