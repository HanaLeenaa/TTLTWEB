package com.example.web_console_handheld.utils;

public class ValidationUtil {

    // tên
    public static boolean isValidName(String name) {
        if (name == null) return false;
        name = name.trim();
        if (name.isEmpty()) return false;
        return name.matches("^[\\p{L} ]+$"); //Tên chỉ được chứa chữ (có thể có dấu) và khoảng trắng
    }

    // email
    //đầu bằng(a–z, A–Z), (0–9), các ký tự (+, _, ., -), tiếp theo là ký tự @,
    //sau đó là một hoặc nhiều ký tự chữ cái, số, dấu chấm hoặc dấu gạch ngang, và không được chứa ký tự khác.
    public static boolean isValidEmail(String email) {
        if (email == null) return false;
        email = email.trim();
        return email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
    }

    // phone number
    public static boolean isValidPhone(String phone) {
        if (phone == null) return false;
        phone = phone.trim();
        // phải đúng 10 số và bắt đầu bằng 0
        if (!phone.matches("^0\\d{9}$")) {
            return false;
        }

        // không cho phép tất cả số giống nhau
        char first = phone.charAt(1);
        boolean allSame = true;

        for (int i = 1; i < phone.length(); i++) {
            if (phone.charAt(i) != first) {
                allSame = false;
                break;
            }
        }
        return !allSame;
    }

    // password
    public static boolean isValidPassword(String password) {
        if (password == null) return false;
        return password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&]).{8,}$");
        //≥8 ký tự gồm chữ hoa, chữ thường, số và ký tự đặc biệt
    }

    // confirm password
    public static boolean isPasswordMatch(String password, String confirmPassword) {
        if (password == null || confirmPassword == null) return false;
        return password.equals(confirmPassword);
    }
}