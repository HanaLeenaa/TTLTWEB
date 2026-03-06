package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.utils.DBConnection;
import com.example.web_console_handheld.utils.PasswordUtil;

import java.sql.*;
import java.time.LocalDateTime;

public class OtpDao {

    // Lưu OTP
    public void saveOtp(int userId, String otpHash, LocalDateTime expiredAt) throws SQLException {

        String deleteSql = "DELETE FROM otp_tokens WHERE user_id = ?";
        String insertSql = """
                INSERT INTO otp_tokens (user_id, otp_hash, expired_at, used)
                VALUES (?, ?, ?, false)
                """;

        try (Connection conn = DBConnection.getConnection()) {

            try (PreparedStatement ps = conn.prepareStatement(deleteSql)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setInt(1, userId);
                ps.setString(2, otpHash);
                ps.setTimestamp(3, Timestamp.valueOf(expiredAt));
                ps.executeUpdate();
            }
        }
    }

    // Verify OTP
    public boolean verify(int userId, String rawOtp) throws SQLException {

        String sql = """
                SELECT id, otp_hash, expired_at
                FROM otp_tokens
                WHERE user_id = ?
                  AND used = false
                ORDER BY id DESC
                LIMIT 1
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return false;

                int otpId = rs.getInt("id");
                String hash = rs.getString("otp_hash");
                Timestamp expiredAt = rs.getTimestamp("expired_at");

                // So sánh thời gian trong java
                if (expiredAt.toLocalDateTime().isBefore(LocalDateTime.now())) {
                    return false;
                }

                boolean match = PasswordUtil.verify(rawOtp, hash);

                if (match) {
                    markUsed(otpId);
                }

                return match;
            }
        }
    }

    private void markUsed(int otpId) throws SQLException {
        String sql = "UPDATE otp_tokens SET used = true WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, otpId);
            ps.executeUpdate();
        }
    }
}
