package com.tourismapp.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

public class ProfileUpdateRequest {

    private String action;

    @NotBlank(message = "Tên không được để trống.")
    @Pattern(regexp = "^[a-zA-ZÀ-ỹ\\s]{2,50}$", message = "Tên phải từ 2-50 ký tự, chỉ chứa chữ cái và khoảng trắng.")
    private String fullName;

    @NotBlank(message = "Email không được để trống.")
    @Email(message = "Email không hợp lệ.")
    private String email;

    @NotBlank(message = "Số điện thoại không được để trống.")
    @Pattern(regexp = "^[0-9]{10,11}$", message = "Số điện thoại phải có 10-11 chữ số.")
    private String phone;

    @NotBlank(message = "Địa chỉ không được để trống.")
    @Pattern(regexp = "^.{5,200}$", message = "Địa chỉ phải từ 5-200 ký tự.")
    private String address;

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }
}
