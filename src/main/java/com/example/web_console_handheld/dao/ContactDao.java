package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.Contact;
import com.example.web_console_handheld.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ContactDao {

    private static final String GET_CONTACT_SQL =
            "SELECT ID, gmail, phone, address FROM contact LIMIT 1";

    public Contact getContactInfo() {
        Contact contact = null;

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(GET_CONTACT_SQL);
                ResultSet rs = ps.executeQuery()
        ) {
            if (rs.next()) {
                contact = new Contact();
                contact.setId(rs.getInt("ID"));
                contact.setGmail(rs.getString("gmail"));
                contact.setPhone(rs.getString("phone"));
                contact.setAddress(rs.getString("address"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return contact;
    }
}
