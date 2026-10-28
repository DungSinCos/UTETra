<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<article class="cart-item"
         data-cart-item
         data-item-id="<c:out value='${param.itemId}'/>"
         data-product-id="<c:out value='${param.productId}'/>"
         data-size="<c:out value='${param.size}' default='M'/>"
         data-unit-price="<c:out value='${param.rawPrice}' default='0'/>"
         data-quantity="<c:out value='${param.quantity}' default='1'/>">

    <!-- Left part: Product Detail (Image, Name, Size, Price) -->
    <div class="cart-item-detail">
        <div class="cart-item-thumb">
            <img src="<c:out value='${param.image}'/>" alt="<c:out value='${param.name}'/>">
        </div>
        <div class="cart-item-info">
            <h3 class="cart-item-name"><c:out value="${param.name}"/></h3>
            <div class="cart-item-meta">
                <span class="cart-item-size">Size: <strong><c:out value="${param.size}" default="M"/></strong></span>
            </div>
            <div class="cart-item-price" data-item-price><c:out value="${param.price}"/></div>
        </div>
    </div>

    <!-- Right part: Delete option & Quantity controls -->
    <div class="cart-item-actions">
        <button type="button" class="cart-item-delete" data-item-delete aria-label="Xóa sản phẩm khỏi giỏ hàng" title="Xóa khỏi giỏ hàng">
            <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <polyline points="3 6 5 6 21 6"></polyline>
                <path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"></path>
                <path d="M10 11v6"></path>
                <path d="M14 11v6"></path>
                <path d="M9 6V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"></path>
            </svg>
        </button>

        <div class="cart-item-qty">
            <button type="button" class="qty-btn" data-qty-decrease aria-label="Giảm số lượng">&minus;</button>
            <span class="qty-value" data-qty-value><c:out value="${param.quantity}" default="1"/></span>
            <button type="button" class="qty-btn" data-qty-increase aria-label="Tăng số lượng">+</button>
        </div>
    </div>
</article>
