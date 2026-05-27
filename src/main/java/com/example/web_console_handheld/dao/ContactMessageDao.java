package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.ContactMessage;
import com.example.web_console_handheld.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ContactMessageDao {
    private Connection conn;
    public ContactMessageDao(Connection conn) {
        this.conn = conn;
    }

    public ContactMessageDao() {
        try {
            conn = DBConnection.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //insert
    public void insert(ContactMessage c) throws SQLException {
        String sql = "INSERT INTO contact_message(user_id, name, email, phone, message) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, c.getUserId());
        ps.setString(2, c.getName());
        ps.setString(3, c.getEmail());
        ps.setString(4, c.getPhone());
        ps.setString(5, c.getMessage());
        ps.executeUpdate();
    }
    //get all contact message
    public List<ContactMessage> getAll() throws SQLException {
        List<ContactMessage> list = new ArrayList<>();
        String sql = "SELECT * FROM contact_message ORDER BY created_at DESC";
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            ContactMessage c= new ContactMessage();
            c.setID(rs.getInt("ID"));
            c.setUserId(rs.getInt("user_id"));
            c.setName(rs.getString("name"));
            c.setEmail(rs.getString("email"));
            c.setPhone(rs.getString("phone"));
            c.setMessage(rs.getString("message"));
            c.setStatus(rs.getString("status"));
            c.setCreatedAt(rs.getTimestamp("created_at"));
            c.setRead(rs.getBoolean("is_read"));
            list.add(c);
        }
        return list;
    }

    //delete
    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM contact_message WHERE ID=?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, id);
        ps.executeUpdate();
    }

    //update Status
    public void updateStatus(int id, String status) throws SQLException {
        String sql = "UPDATE contact_message SET status=? WHERE ID=?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, status);
        ps.setInt(2, id);
        ps.executeUpdate();
    }

    //reply to user
    public void reply(int id, String reply) throws SQLException {
        String sql = "UPDATE contact_message SET reply=?, status='REPLIED' WHERE ID=?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, reply);
        ps.setInt(2, id);
        ps.executeUpdate();
    }

    public int countReplied(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM contact_message WHERE user_id=? AND status='REPLIED'";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            return rs.getInt(1);
        }
        return 0;
    }

    public List<ContactMessage> getRepliedByUser(int userId) throws SQLException {
        List<ContactMessage> list = new ArrayList<>();
        String sql = "SELECT * FROM contact_message WHERE user_id=? AND status='REPLIED' ORDER BY created_at DESC";

        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            ContactMessage c = new ContactMessage();
            c.setID(rs.getInt("ID"));
            c.setMessage(rs.getString("message"));
            c.setReply(rs.getString("reply"));
            c.setCreatedAt(rs.getTimestamp("created_at"));
            list.add(c);
        }
        return list;
    }

    public ContactMessage getById(int id) {
        String sql = "SELECT * FROM contact_message WHERE ID=?";
        try(Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new ContactMessage(
                        rs.getInt("ID"),
                        rs.getInt("user_id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("message"),
                        rs.getString("status"),
                        rs.getTimestamp("created_at"),
                        rs.getString("reply"),
                        rs.getBoolean("is_read")
                );
            }
        }catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void markAsRead(int id) {
        String sql = "UPDATE contact_message SET is_read = true WHERE ID = ?";
        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)){

            ps.setInt(1, id);
            ps.executeUpdate();

        }catch(Exception e){
            e.printStackTrace();
        }
    }

    public int countUnread(int userId) {
        String sql = "SELECT COUNT(*) FROM contact_message WHERE user_id = ? AND reply IS NOT NULL AND  is_read = false";

        try(PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                return rs.getInt(1);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return 0;
    }
}
