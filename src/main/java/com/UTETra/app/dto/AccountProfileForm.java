package com.UTETra.app.dto;

/** Only editable profile fields are accepted from the account form. */
public class AccountProfileForm {

    private String fullName;
    private String phone;

    public AccountProfileForm() {
    }

    public AccountProfileForm(String fullName, String phone) {
        this.fullName = fullName;
        this.phone = phone;
    }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
}
