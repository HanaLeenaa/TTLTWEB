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
        String sql = "UPDATE users SET active = NOT active WHERE id=? AND deleted = false";

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
                u.setRole(rs.getString("role"));
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
    // lấy danh sách user đang hoạt đông (không bị admin xóa mềm)
    public List<User> getAllActiveUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE deleted = false ORDER BY id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                u.setActive(rs.getBoolean("active"));
                u.setDeleted(rs.getBoolean("deleted"));
                list.add(u);

            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // lấy danh sách user ngừng hoạt đông (bị admin xóa mềm)
    public List<User> getDeletedUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE deleted = true ORDER BY id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                u.setActive(rs.getBoolean("active"));
                u.setDeleted(rs.getBoolean("deleted"));
                list.add(u);

            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Xóa mềm user => không xóa khỏi DB
    public void softDeleteUser(int userId) {
        String sql = "UPDATE users SET deleted = true, active = false WHERE id = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)){

            ps.setInt(1, userId);
            ps.executeUpdate();
        }catch (Exception e) {
            e.printStackTrace();
        }
    }

    // khôi phục user đã xóa
    public void restoreUser(int userId) {
        String sql = "UPDATE users SET deleted = false , active = true WHERE id = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)){

            ps.setInt(1, userId);
            ps.executeUpdate();
        }catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean updatePassword(int userId, String newPassword) {

        String sql = "UPDATE users SET password=? WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String hash = BCrypt.hashpw(newPassword, BCrypt.gensalt());

            ps.setString(1, hash);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public void increaseForgotPasswordAttempts(int userId) {

        String sql = """
            UPDATE users
            SET forgot_password_attempts =
                forgot_password_attempts + 1
            WHERE id = ?
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int getForgotPasswordAttempts(int userId) {

        String sql = """
            SELECT forgot_password_attempts
            FROM users
            WHERE id = ?
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("forgot_password_attempts");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public void lockForgotPassword(int userId) {

        String sql = """
            UPDATE users
            SET forgot_lock_until = ?
            WHERE id = ?
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            LocalDateTime lockTime = LocalDateTime.now().plusMinutes(15);

            ps.setTimestamp(1, Timestamp.valueOf(lockTime));

            ps.setInt(2, userId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean isForgotPasswordLocked(int userId) {

        String sql = """
            SELECT forgot_lock_until
            FROM users
            WHERE id = ?
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Timestamp lockUntil =
                        rs.getTimestamp("forgot_lock_until");

                if (lockUntil == null) {
                    return false;
                }

                return lockUntil.toLocalDateTime()
                        .isAfter(LocalDateTime.now());
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public Integer verifyResetToken(String token) {

        Integer userId = null;

        String sql = """
        SELECT id
        FROM users
        WHERE reset_token = ?
        AND reset_token_expiry > NOW()
        """;

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, token);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                userId = rs.getInt("id");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return userId;
    //chức năng sửa user ở admin page
    public boolean updateUserByAdmin(int id, String username, String role, String phone, String address, boolean active) {
        String sql = "UPDATE users SET username = ?, role = ?, phoneNum = ?, location = ?, active = ?, updated_at = NOW() WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, role);
            ps.setString(3, phone);
            ps.setString(4, address);
            ps.setBoolean(5, active);
            ps.setInt(6, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    }

}

