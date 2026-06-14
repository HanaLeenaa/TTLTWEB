package com.example.web_console_handheld.service;

public class DeliveryTimeService {

    public int estimateDays(int fromDistrict, int toDistrict) {

        // Cùng quận
        if (fromDistrict == toDistrict) {
            return 1;
        }

        // Nội thành HCM
        if (isHCM(fromDistrict) && isHCM(toDistrict)) {
            return 2;
        }

        // Khác tỉnh
        return 3 + (int)(Math.random() * 2); // 3-4 ngày
    }

    private boolean isHCM(int districtId) {
        // danh sách district HCM (rút gọn)
        int[] hcm = {1452,1453,1454,1455,1456};
        for (int d : hcm) {
            if (d == districtId) return true;
        }
        return false;
    }
}
