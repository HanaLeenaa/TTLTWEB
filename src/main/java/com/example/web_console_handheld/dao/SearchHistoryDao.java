package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.SearchHistory;
import java.util.List;

public class SearchHistoryDao extends BaseDao {

    // Lưu từ khóa: Nếu trùng thì cập nhật thời gian mới nhất (ON DUPLICATE KEY UPDATE)
    public void saveSearchHistory(int userId, String keyword) {
        get().useHandle(handle -> {
            String sql = """
                INSERT INTO search_history (user_id, keyword, searched_at) 
                VALUES (:userId, :keyword, NOW())
                ON DUPLICATE KEY UPDATE searched_at = NOW()
            """;
            handle.createUpdate(sql)
                    .bind("userId", userId)
                    .bind("keyword", keyword.trim())
                    .execute();
        });
    }

    // Lấy 5 từ khóa gần nhất
    public List<SearchHistory> getRecentSearches(int userId, int limit) {
        return get().withHandle(handle -> {
            String sql = "SELECT * FROM search_history WHERE user_id = :userId ORDER BY searched_at DESC LIMIT :limit";
            return handle.createQuery(sql)
                    .bind("userId", userId)
                    .bind("limit", limit)
                    .mapToBean(SearchHistory.class)
                    .list();
        });
    }

    // CHỨC NĂNG MỚI: Xóa toàn bộ lịch sử tìm kiếm của một User
    public void clearAllHistory(int userId) {
        get().useHandle(handle -> {
            String sql = "DELETE FROM search_history WHERE user_id = :userId";
            handle.createUpdate(sql)
                    .bind("userId", userId)
                    .execute();
        });
    }
}