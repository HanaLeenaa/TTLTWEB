package com.example.web_console_handheld.service;

import com.example.web_console_handheld.utils.GHNConfig;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

public class GHNService {

    private final String TOKEN = GHNConfig.getToken();
    private final String SHOP_ID = GHNConfig.getShopId();
    private final String API = GHNConfig.getApi();

    public int calculateFee(int fromDistrictId, int toDistrictId, int weight) throws Exception {
        String url = API + "/shiip/public-api/v2/shipping-order/fee";

        HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Token", TOKEN);
        conn.setRequestProperty("ShopId", SHOP_ID);
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        String body = "{"
                + "\"from_district_id\":" + fromDistrictId + ","
                + "\"to_district_id\":" + toDistrictId + ","
                + "\"service_type_id\":2,"
                + "\"weight\":" + weight
                + "}";

        try (OutputStream os = conn.getOutputStream()) {
            os.write(body.getBytes(StandardCharsets.UTF_8));
        }

        int code = conn.getResponseCode();

        BufferedReader br = new BufferedReader(new InputStreamReader(
                code >= 200 && code < 300 ? conn.getInputStream()
                        : conn.getErrorStream(), StandardCharsets.UTF_8));

        String result = br.lines().reduce("", String::concat);
        JsonObject json = JsonParser.parseString(result).getAsJsonObject();
        if (!json.has("data") || json.get("data").isJsonNull()) {
            throw new Exception("GHN FEE ERROR: " + result);
        }

        JsonObject data = json.getAsJsonObject("data");
        if (!data.has("total") || data.get("total").isJsonNull()) {
            throw new Exception("GHN FEE missing total: " + result);
        }

        return data.get("total").getAsInt();
    }

    public int calculateLeadTime(
            int fromDistrictId,
            String fromWardCode,
            int toDistrictId,
            String toWardCode
    ) throws Exception {

        String url = API + "/shiip/public-api/v2/shipping-order/leadtime";

        HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Token", TOKEN);
        conn.setRequestProperty("ShopId", SHOP_ID);
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        String body = "{"
                + "\"from_district_id\":" + fromDistrictId + ","
                + "\"from_ward_code\":\"" + fromWardCode + "\","
                + "\"to_district_id\":" + toDistrictId + ","
                + "\"to_ward_code\":\"" + toWardCode + "\","
                + "\"service_id\":2"
                + "}";

        try (OutputStream os = conn.getOutputStream()) {
            os.write(body.getBytes(StandardCharsets.UTF_8));
        }

        int code = conn.getResponseCode();

        BufferedReader br = new BufferedReader(new InputStreamReader(
                code >= 200 && code < 300 ? conn.getInputStream()
                        : conn.getErrorStream(), StandardCharsets.UTF_8));

        String result = br.lines().reduce("", String::concat);

        JsonObject json = JsonParser.parseString(result).getAsJsonObject();

        if (!json.has("data") || json.get("data").isJsonNull()) {
            throw new Exception("GHN LEADTIME ERROR: " + result);
        }

        JsonObject data = json.getAsJsonObject("data");

        if (data == null || !data.has("leadtime") || data.get("leadtime").isJsonNull()) {
            throw new Exception("GHN leadtime missing: " + result);
        }

        return data.get("leadtime").getAsInt();
    }
}