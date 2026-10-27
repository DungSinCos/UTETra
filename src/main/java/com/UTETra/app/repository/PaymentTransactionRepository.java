package com.UTETra.app.repository;

import com.UTETra.app.entity.PaymentTransaction;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PaymentTransactionRepository extends JpaRepository<PaymentTransaction, Long> {

    List<PaymentTransaction> findByOrder_IdOrderByCreatedAtDesc(Long orderId);
}
