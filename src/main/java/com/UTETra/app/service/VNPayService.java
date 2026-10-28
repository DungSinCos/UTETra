package com.UTETra.app.service;

import com.UTETra.app.entity.CustomerOrder;
import jakarta.servlet.http.HttpServletRequest;

import java.util.Map;

public interface VNPayService {

    String createPaymentUrl(CustomerOrder order, HttpServletRequest request);

    boolean verifySignature(Map<String, String> queryParams);

    boolean isPaymentSuccess(Map<String, String> queryParams);

    String getTransactionRef(Map<String, String> queryParams);

    String getOrderCode(Map<String, String> queryParams);

    String getResponseDescription(String responseCode);
}
