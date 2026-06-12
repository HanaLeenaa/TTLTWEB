package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.Admin;
import com.example.web_console_handheld.utils.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AdminDao {
    public Admin login(String username, String password) {
        // In sẵn một chuỗi băm "chính chủ" của chữ "staff" ra Console để bạn dễ lấy nạp vào DB bằng tay khi cần
        System.out.println("\n[BCRYPT GENERATOR] Chuoi ma hoa xon cua chu 'staff' la: " + BCrypt.hashpw("staff", BCrypt.gensalt()));

        String sql = "Select * from admin where username=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String pass = rs.getString("password");

                // 🌟 ĐOẠN IN LOG THẦN THÁNH ĐỂ BẮT BỆNH TẠI ĐÂY:
                System.out.println("\n============ LOG KIEM TRA DANG NHAP ============");
                System.out.println("-> [1] Tai khoan dang nhap: [" + username + "]");
                System.out.println("-> [2] Mat khau ban go tren Web gui xuong: [" + password + "]");
                System.out.println("-> [3] Chuoi ma hoa lay tu Database len : [" + pass + "]");

                if (pass != null) {
                    System.out.println("-> [4] Do dai chuoi mat khau trong DB  : " + pass.length() + " ky tu");
                }

                // Thử nghiệm so khớp
                boolean isMatch = false;
                try {
                    isMatch = BCrypt.checkpw(password, pass);
                } catch (Exception ex) {
                    System.out.println("-> [LÕI] Chuoi trong DB khong dung dinh dang BCrypt! Huong dan: Phai dung chuoi dang $2a$10$...");
                }

                System.out.println("-> [5] Ket qua doi chieu Bcrypt: " + (isMatch ? "✅ KHOP (THANH CONG)" : "❌ LECH (THAT BAI)"));
                System.out.println("================================================\n");

                if (isMatch) {
                    return new Admin(
                            rs.getInt("ID"),
                            rs.getString("username"),
                            pass,
                            rs.getString("fullname"),
                            rs.getInt("role")
                    );
                }
            } else {
                System.out.println("\n❌ [LOG] Khong tim thay tai khoan [" + username + "] trong Database!");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertAdmin(String username, String rawPassword, String fullname, int role) {
        String sql = "INSERT INTO admin(username, password, fullname, status, role) VALUES (?, ?, ?, 1, ?)";

        // Tự động băm khi gọi hàm qua code Java
        String hashedPassword = BCrypt.hashpw(rawPassword, BCrypt.gensalt());

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, hashedPassword);
            ps.setString(3, fullname);
            ps.setInt(4, role);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}