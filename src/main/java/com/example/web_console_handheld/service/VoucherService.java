package com.example.web_console_handheld.service;

import com.example.web_console_handheld.model.Voucher;

import java.util.List;

public class VoucherService {
    //tính giảm giá theo loại voucher (PERCENT / FIXED)
    public long calculateDiscount(Voucher v, long totalAmount) {
        if ("PERCENT".equals(v.getDiscount_type())) {
            long discount = (long) (totalAmount * v.getDiscount_value().doubleValue() / 100);

            if (v.getMax_discount() != null) {
                discount = Math.min(discount, v.getMax_discount().longValue());
            }

            return discount;
        }
        return v.getDiscount_value().longValue();
    }

    //SORT DESC để đề xuất voucher tốt nhất
    public List<Voucher> sortBestVoucher(List<Voucher> vouchers, long totalAmount) {

        vouchers.sort((v1, v2) -> {
            long d1 = calculateDiscount(v1, totalAmount);
            long d2 = calculateDiscount(v2, totalAmount);

            int cmp = Long.compare(d2, d1);
            if (cmp != 0) return cmp;

            return v2.getID() - v1.getID();
        });

        return vouchers;
    }
}
