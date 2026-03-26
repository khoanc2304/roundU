package com.tourismapp.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

public class RegisterRequest {

    @NotBlank(message = "Tên đăng nhập không được để trống.")
    private String username;

    @NotBlank(message = "Mật khẩu không được để trống.")
    private String password;

    @NotBlank(message = "Họ tên không được để trống.")
    private String fullName;

    @NotBlank(message = "Email không được để trống.")
    @Email(message = "Địa chỉ email không hợp lệ.")
    private String email;

    @NotBlank(message = "Số điện thoại không được để trống.")
    @Pattern(regexp = "^\\d{10,11}$", message = "Số điện thoại phải gồm 10 hoặc 11 chữ số.")
    private String phone;

    @NotBlank(message = "Địa chỉ không được để trống.")
    private String address;

    // Getters and Setters
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
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
