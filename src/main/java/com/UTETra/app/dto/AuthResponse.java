package com.UTETra.app.dto;

import com.fasterxml.jackson.annotation.JsonInclude;

/** JSON body returned by POST /login and POST /register. */
@JsonInclude(JsonInclude.Include.NON_NULL)
public record AuthResponse(boolean success, String message, String redirect) {

    public static AuthResponse ok(String redirect) {
        return new AuthResponse(true, null, redirect);
    }

    public static AuthResponse error(String message) {
        return new AuthResponse(false, message, null);
    }
}
