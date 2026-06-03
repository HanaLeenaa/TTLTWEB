package com.example.web_console_handheld.utils;

import java.io.InputStream;
import java.util.Properties;

public class GHNConfig {

    private static final Properties props = new Properties();

    static {
        try {
            InputStream is = GHNConfig.class.getClassLoader().getResourceAsStream("ghn.properties");
            props.load(is);

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static String getToken() {
        return props.getProperty("ghn.token");
    }

    public static String getShopId() {
        return props.getProperty("ghn.shopid");
    }

    public static String getApi() {
        return props.getProperty("ghn.api");
    }
}
