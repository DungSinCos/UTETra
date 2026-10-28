<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="productDetailUrl" value="${pageContext.request.contextPath}/products/${param.id}" />

<article class="product-item"
         id="product-${param.id}"
         data-product-card
         data-product-id="<c:out value='${param.id}'/>"
         data-category="<c:out value='${param.category}'/>"
         data-name="<c:out value='${param.name}'/>"
         data-price="<c:out value='${param.price}'/>"
         onclick="if(!event.target.closest('[data-add-to-cart]')){window.location.href='<c:out value="${productDetailUrl}"/>';}"
         role="link"
         tabindex="0"
         onkeydown="if((event.key==='Enter'||event.key===' ')&&!event.target.closest('[data-add-to-cart]')){event.preventDefault();window.location.href='<c:out value="${productDetailUrl}"/>';}">
    <div class="product-thumb">
        <c:if test="${not empty param.badge}">
            <span class="product-badge ${not empty param.badgeClass ? param.badgeClass : ''}"><c:out value="${param.badge}"/></span>
        </c:if>
        <img src="<c:out value='${param.image}'/>" alt="<c:out value='${param.name}'/>" loading="lazy">
    </div>
    <div class="product-body">
        <h3 class="product-name"><c:out value="${param.name}"/></h3>
        <p class="product-desc"><c:out value="${param.desc}"/></p>
        <div class="product-footer">
            <span class="product-price"><c:out value="${param.price}"/></span>
            <button type="button"
                    class="product-add"
                    data-add-to-cart="<c:out value='${param.id}'/>"
                    data-product-name="<c:out value='${param.name}'/>"
                    aria-label="Thêm <c:out value='${param.name}'/> vào giỏ hàng">+</button>
        </div>
    </div>
</article>
