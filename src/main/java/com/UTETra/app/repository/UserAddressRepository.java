package com.UTETra.app.repository;

import com.UTETra.app.entity.UserAddress;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UserAddressRepository extends JpaRepository<UserAddress, Long> {

    List<UserAddress> findByUserIdOrderByDefaultAddressDescIdDesc(Long userId);
}
