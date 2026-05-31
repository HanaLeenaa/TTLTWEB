package com.example.web_console_handheld.utils;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

public class VNPayUtil {
    public static String hmacSHA512(String key, String data) {
        try {
            Mac hmac512 = Mac.getInstance("HmacSHA512");
            SecretKeySpec secretKey = new SecretKeySpec(
                    key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");

            hmac512.init(secretKey);
            byte[] bytes = hmac512.doFinal(data.getBytes(StandardCharsets.UTF_8));

            StringBuilder hash = new StringBuilder();

            for (byte b : bytes) {
                hash.append(String.format("%02x", b));
            }
            return hash.toString();

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static String hashAllFields(Map<String, String> fields, String secretKey) {
        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();

        try {
            for (String fieldName : fieldNames) {
                String value = fields.get(fieldName);

                if (value != null && !value.isEmpty()) {
                    hashData.append(
                            URLEncoder.encode(
                                    fieldName,
                                    StandardCharsets.US_ASCII.toString()
                            )
                    );

                    hashData.append("=");

                    hashData.append(URLEncoder.encode(value, StandardCharsets.US_ASCII.toString()));

                    hashData.append("&");
                }
            }
            if (hashData.length() > 0) {
                hashData.deleteCharAt(hashData.length() - 1);
            }

            return hmacSHA512(secretKey, hashData.toString());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static String buildQuery(Map<String, String> fields) {
        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);
        StringBuilder query = new StringBuilder();
        try {

            for (String fieldName : fieldNames) {
                String value = fields.get(fieldName);
                if (value != null && !value.isEmpty()) {
                    query.append(URLEncoder.encode(fieldName, StandardCharsets.UTF_8));
                    query.append("=");
                    query.append(URLEncoder.encode(value, StandardCharsets.UTF_8));
                    query.append("&");
                }
            }

            if (query.length() > 0) {
                query.deleteCharAt(query.length() - 1);
            }
            return query.toString();
        }catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static String createPaymentUrl(long amount, String txnRef, String ipAddr) {

        try {

            Map<String, String> params = new HashMap<>();

            params.put("vnp_Version", "2.1.0");
            params.put("vnp_Command", "pay");
            params.put("vnp_TmnCode", VNPayConfig.vnp_TmnCode);

            params.put("vnp_Amount",
                    String.valueOf(amount));

            params.put("vnp_CurrCode", "VND");

            params.put("vnp_TxnRef", txnRef);

            params.put("vnp_OrderInfo",
                    "Thanh toan don hang " + txnRef);

            params.put("vnp_OrderType", "other");

            params.put("vnp_Locale", "vn");

            params.put("vnp_ReturnUrl",
                    VNPayConfig.vnp_ReturnUrl);

            params.put("vnp_IpAddr", ipAddr);

            TimeZone vnTimeZone = TimeZone.getTimeZone("Asia/Ho_Chi_Minh");

            Calendar calendar = Calendar.getInstance(vnTimeZone);

            SimpleDateFormat formatter =
                    new SimpleDateFormat("yyyyMMddHHmmss");

            formatter.setTimeZone(vnTimeZone);

            System.out.println("Current Time = " + new Date());
            System.out.println("Default TZ = " + TimeZone.getDefault().getID());


            String createDate = formatter.format(calendar.getTime());
            params.put("vnp_CreateDate", createDate);
            // Hết hạn sau 15 phút
            calendar.add(Calendar.MINUTE, 15);

            String expireDate = formatter.format(calendar.getTime());
            params.put("vnp_ExpireDate", expireDate);

            String secureHash = hashAllFields(params, VNPayConfig.secretKey);

            params.put("vnp_SecureHash", secureHash);

            return VNPayConfig.vnp_PayUrl + "?" + buildQuery(params);

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
