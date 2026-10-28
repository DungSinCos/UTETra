package com.UTETra.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/** Public informational pages: About UTETra and Customer Support. */
@Controller
public class InfoPageController {

    @GetMapping("/about")
    public String about() {
        return "about";
    }

    @GetMapping("/support")
    public String support() {
        return "support";
    }
}
