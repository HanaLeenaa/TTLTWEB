package com.example.web_console_handheld.utils;

public class ValidationUtil {

    // Username: chỉ cấm ký tự đặc biệt
    // Cho phép chữ (kể cả có dấu), số và khoảng trắng
    public static boolean isValidUsername(String username) {
        if (username == null) return false;

        username = username.trim();
        if (username.isEmpty()) return false;

        return username.matches("^[\\p{L}\\p{N}\\s]+$");
    }

    // Password: ít nhất 8 ký tự, có chữ hoa, chữ thường, số, ký tự đặc biệt
    public static boolean isValidPassword(String password) {
        if (password == null) return false;

        return password.matches(
                "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&]).{8,}$"
        );
    }

    // Email: định dạng email cơ bản
    public static boolean isValidEmail(String email) {
        if (email == null) return false;

        return email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$");
    }
}
