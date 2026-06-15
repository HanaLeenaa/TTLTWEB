package com.example.web_console_handheld.service;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

import org.json.JSONObject;

public class GHNService {

    private static final String TOKEN = "4b07c206-5e4f-11f1-a973-aee5264794df";
    private static final String SHOP_ID = "200530";
    private static final String BASE_URL = "https://dev-online-gateway.ghn.vn";

    // TÍNH PHÍ VẬN CHUYỂN GHN
    public int calculateFee(int fromDistrictId, int toDistrictId, int weight) {

        HttpURLConnection conn = null;

        try {
            URL url = new URL(BASE_URL + "/shiip/public-api/v2/shipping-order/fee");
            conn = (HttpURLConnection) url.openConnection();

            conn.setRequestMethod("POST");
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(5000);

            conn.setRequestProperty("Token", TOKEN);
            conn.setRequestProperty("ShopId", SHOP_ID);
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");

            conn.setDoOutput(true);

            JSONObject body = new JSONObject();
            body.put("from_district_id", fromDistrictId);
            body.put("to_district_id", toDistrictId);
            body.put("weight", weight);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(body.toString().getBytes(StandardCharsets.UTF_8));
            }

            int responseCode = conn.getResponseCode();

            InputStream is = (responseCode >= 200 && responseCode < 300)
                    ? conn.getInputStream()
                    : conn.getErrorStream();

            String response = readStream(is);

            JSONObject json = new JSONObject(response);

            // =========================
            // GHN RESPONSE STRUCTURE:
            // {
            //   "code": 200,
            //   "message": "Success",
            //   "data": {
            //       "total": 25000
            //   }
            // }
            // =========================

            if (json.has("code") && json.getInt("code") == 200) {
                JSONObject data = json.optJSONObject("data");
                if (data != null) {
                    return data.optInt("total", 30000);
                }
            }

            System.out.println("GHN error response: " + response);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (conn != null) conn.disconnect();
        }

        // fallback
        return 30000;
    }

    private String readStream(InputStream is) throws IOException {
        if (is == null) return "";

        BufferedReader br = new BufferedReader(
                new InputStreamReader(is, StandardCharsets.UTF_8)
        );

        StringBuilder sb = new StringBuilder();
        String line;

        while ((line = br.readLine()) != null) {
            sb.append(line);
        }

        return sb.toString();
    }
}