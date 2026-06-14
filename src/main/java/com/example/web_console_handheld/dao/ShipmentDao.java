package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.Shipment;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class ShipmentDao {

    public void insert(Connection conn, Shipment shipment) throws Exception {

        String sql =
                """
                INSERT INTO shipment(
                    order_id,
                    ghn_order_code,
                    shipping_fee,
                    shipping_status
                )
                VALUES(?,?,?,?)
                """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, shipment.getOrderId());
            ps.setString(2, shipment.getGhnOrderCode());
            ps.setDouble(3, shipment.getShippingFee());
            ps.setString(4, shipment.getShippingStatus());
            ps.executeUpdate();
        }
    }

    public String formatLeadTime(int leadtimeTimestamp) {
        java.time.Instant instant = java.time.Instant.ofEpochSecond(leadtimeTimestamp);
        java.time.LocalDate date = instant.atZone(java.time.ZoneId.systemDefault()).toLocalDate();
        return date.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }
}