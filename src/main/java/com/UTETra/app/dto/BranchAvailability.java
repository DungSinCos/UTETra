package com.UTETra.app.dto;

public class BranchAvailability {

    private final Long id;
    private final String name;
    private final boolean available;

    public BranchAvailability(Long id, String name, boolean available) {
        this.id = id;
        this.name = name;
        this.available = available;
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public boolean isAvailable() {
        return available;
    }
}
