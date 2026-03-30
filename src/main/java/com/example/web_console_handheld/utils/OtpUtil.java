package com.example.web_console_handheld.utils;

import java.security.SecureRandom;
import java.util.HashSet;
import java.util.Set;

public class OtpUtil {
    private static final SecureRandom random = new SecureRandom();
    private static final Set<String> activeOtps = new HashSet<>();

    public static String generateUniqueOtp() {
        String otp;
        do {
            otp = String.valueOf(100000 + random.nextInt(900000));
        } while (activeOtps.contains(otp)); // nếu trùng, tạo lại
        activeOtps.add(otp); // lưu OTP mới vào danh sách đang hoạt động
        return otp;
    }

    // Khi OTP hết hạn hoặc được sử dụng, xóa nó
    public static void expireOtp(String otp) {
        activeOtps.remove(otp);
    }
}