package com.example.web_console_handheld.dao;

import com.mysql.cj.jdbc.MysqlDataSource;
import org.jdbi.v3.core.Jdbi;
import java.sql.SQLException;

public abstract class BaseDao {
    private static Jdbi jdbi; // Chuyển thành static để dùng chung một Instance duy nhất cho toàn bộ ứng dụng

    protected synchronized Jdbi get() {
        if (jdbi == null) {
            makeConnect();
        }
        return jdbi;
    }

    private void makeConnect() {
        MysqlDataSource src = new MysqlDataSource();
        String url = "jdbc:mysql://" + DBProperties.host() + ":" + DBProperties.port() + "/" + DBProperties.dbname() + "?" + DBProperties.option();
        src.setURL(url);
        src.setUser(DBProperties.username());
        src.setPassword(DBProperties.password());
        try {
            src.setUseCompression(true);
            src.setAutoReconnect(true);
        } catch (SQLException e) {
            throw new RuntimeException("Không thể thiết lập cấu hình kết nối MySQL", e);
        }
        jdbi = Jdbi.create(src);
    }
}