<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="productDetailUrl" value="${pageContext.request.contextPath}/products/${requestScope.productCardId}" />

<article class="product-item"
         id="product-${requestScope.productCardId}"
         data-product-card
         data-product-id="<c:out value='${requestScope.productCardId}'/>"
         data-category="<c:out value='${requestScope.productCardCategory}'/>"
         data-name="<c:out value='${requestScope.productCardName}'/>"
         data-price="<c:out value='${requestScope.productCardPrice}'/>"
         onclick="if(!event.target.closest('[data-add-to-cart]')){window.location.href='<c:out value="${productDetailUrl}"/>';}"
         role="link"
         tabindex="0"
         onkeydown="if((event.key==='Enter'||event.key===' ')&&!event.target.closest('[data-add-to-cart]')){event.preventDefault();window.location.href='<c:out value="${productDetailUrl}"/>';}">
    <div class="product-thumb">
        <c:if test="${not empty requestScope.productCardBadge}">
            <span class="product-badge ${requestScope.productCardBadgeClass}"><c:out value="${requestScope.productCardBadge}"/></span>
        </c:if>
        <img src="<c:out value='${requestScope.productCardImage}'/>" alt="<c:out value='${requestScope.productCardName}'/>" loading="lazy">
    </div>
    <div class="product-body">
        <h3 class="product-name"><c:out value="${requestScope.productCardName}"/></h3>
        <p class="product-desc"><c:out value="${requestScope.productCardDesc}"/></p>
        <div class="product-footer">
            <span class="product-price"><c:out value="${requestScope.productCardPrice}"/></span>
            <button type="button"
                    class="product-add"
                    data-add-to-cart="<c:out value='${requestScope.productCardId}'/>"
                    data-product-name="<c:out value='${requestScope.productCardName}'/>"
                    aria-label="Thêm <c:out value='${requestScope.productCardName}'/> vào giỏ hàng">+</button>
        </div>
    </div>
</article>
