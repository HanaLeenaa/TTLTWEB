package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.User;
import com.example.web_console_handheld.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import org.mindrot.jbcrypt.BCrypt;
import java.time.LocalDateTime;
import java.sql.Timestamp;
import java.time.ZoneId;

public class UserDao extends BaseDao{

    // Kiểm tra username đã tồn tại chưa
    public boolean existsUsername(String username) {
        String sql = "SELECT 1 FROM users WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // true nếu có record
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false; // lỗi thì coi như chưa tồn tại
        }
    }

    // Kiểm tra email đã tồn tại chưa
    public boolean existsEmail(String email) {
        String sql = "SELECT 1 FROM users WHERE email=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    //kiểm tra sđt đã tồn tại chưa
    public boolean existsPhoneNum(String phoneNum) {
        String sql = "SELECT 1 FROM users WHERE phoneNum = ? LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, phoneNum.trim());
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Thêm user mới, trả về ID
    public int insert(User u) throws SQLException {
        // Đã loại bỏ fullname khỏi câu lệnh INSERT
        String sql = "INSERT INTO users (username, password, email, phoneNum, active, created_at) VALUES (?, ?, ?, ?, ?, NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getPassword());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getPhoneNum());
            ps.setBoolean(5, false);

            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        throw new SQLException("Thêm user thất bại.");
    }

    // Kích hoạt user
    public void activate(int userId) throws SQLException {
        String sql = "UPDATE users SET active=true, updated_at=NOW() WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }

    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setFullname(rs.getString("fullname"));
                u.setPhoneNum(rs.getString("phoneNum"));
                u.setLocation(rs.getString("location"));
                u.setActive(rs.getBoolean("active"));
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // cập nhật thông tin người dùng
    public boolean updateProfile(User u) {
        String sql = """ 
        UPDATE users
        SET username = ?,
            email = ?,
            phoneNum = ?,
            location = ?,
            updated_at = NOW()
        WHERE id = ?""";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, u.getUsername());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPhoneNum());
            ps.setString(4, u.getLocation());
            ps.setInt(5, u.getId());

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public void updateAddress(int userId, String address) {
        get().useHandle(handle ->
                handle.createUpdate(
                                "UPDATE users SET location = :address WHERE id = :id"
                        )
                        .bind("address", address)
                        .bind("id", userId)
                        .execute()
        );
    }
    public void updateLocation(int userId, String location) {
        String sql = "UPDATE users SET location = ? WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, location);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    public int countAll() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM users";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }
    /* ================= ĐỔI QUYỀN ================= */
    public void updateRole(int userId, String role) {
        String sql = "UPDATE users SET role=? WHERE id=?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, role);
            ps.setInt(2, userId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    /* ================= KHOÁ / MỞ ================= */
    public void toggleActive(int userId) {
        String sql = "UPDATE users SET active = NOT active WHERE id=?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    /* ================= XOÁ USER ================= */
    public void delete(int userId) {
        String sql = "DELETE FROM users WHERE id=?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public List<User> getAll() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("ID"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
//                u.setRole(rs.getString("role"));
                u.setActive(rs.getBoolean("active"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public User getUserByEmail(String email) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM users WHERE email = :email")
                        .bind("email", email)
                        .mapToBean(User.class)
                        .findOne()
                        .orElse(null));
    }

    public void insertGoogleUser(String email, String name) {
        get().withHandle(handle ->
                handle.createUpdate("""
                INSERT INTO users(username, email, password, active, created_at, provider)
                VALUES(:username, :email, '', true, NOW(), 'google')""")
                        .bind("username", name)
                        .bind("email", email)
                        .execute());
    }

    public boolean isResetTokenValid(String token) {
        String sql = "SELECT reset_token_expiry FROM users WHERE reset_token = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Timestamp expiry = rs.getTimestamp("reset_token_expiry");
                if (expiry == null) return false;

                // so sánh thời gian hiện tại với thời gian hết hạn
                LocalDateTime now = LocalDateTime.now();
                LocalDateTime expiryTime = expiry.toInstant()
                        .atZone(ZoneId.systemDefault())
                        .toLocalDateTime();
                return now.isBefore(expiryTime);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePasswordByToken(String token, String newPassword) {
        String sql = """
        UPDATE users
        SET password = ?, 
            reset_token = NULL,
            reset_token_expiry = NULL,
            updated_at = NOW()
        WHERE reset_token = ?""";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            // hash password bằng BCrypt
            String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
            ps.setString(1, hashedPassword);
            ps.setString(2, token);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setPassword(rs.getString("password"));
                u.setActive(rs.getBoolean("active"));
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void saveResetToken(String email, String token, LocalDateTime expireAt) {
        String sql = """
        UPDATE users
        SET reset_token = ?, 
            reset_token_expiry = ?
        WHERE email = ?""";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.setTimestamp(2, Timestamp.valueOf(expireAt));
            ps.setString(3, email);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
