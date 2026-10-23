document.addEventListener("DOMContentLoaded", function () {
    var toggle = document.querySelector("[data-nav-toggle]");
    var collapse = document.querySelector("[data-nav-collapse]");

    if (toggle && collapse) {
        toggle.addEventListener("click", function () {
            var open = collapse.classList.toggle("is-open");
            toggle.classList.toggle("is-open", open);
            toggle.setAttribute("aria-expanded", open ? "true" : "false");
        });
    }

    var brand = document.querySelector(".brand");
    var base = brand ? new URL(brand.href).pathname.replace(/\/$/, "") : "";
    var current = window.location.pathname.substring(base.length).replace(/\/$/, "") || "/";
    if (current === "/home") {
        current = "/";
    }

    document.querySelectorAll(".nav-item[data-path]").forEach(function (link) {
        var path = link.getAttribute("data-path");
        var match = path === "/" ? current === "/" : current === path || current.indexOf(path + "/") === 0;
        link.classList.toggle("is-active", match);
    });
});
