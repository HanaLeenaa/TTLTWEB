package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.StatisticsItem;
import com.example.web_console_handheld.model.TopProduct;
import com.example.web_console_handheld.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

public class DashboardStatisticsDao {
    //thống kê theo tháng
    public List<StatisticsItem> getRevenueByMonth(int year) {
        List<StatisticsItem> list = new ArrayList<>();

        String sql = """
                SELECT 
                    MONTH(o.order_date) as month,
                    COUNT(DISTINCT o.ID) as total_orders,
                    SUM(oi.quantity) as total_products,
                    SUM(oi.quantity * oi.price_at_purchase) as revenue
                 
                FROM orders o
                JOIN order_items oi
                ON o.ID = oi.order_id
                WHERE YEAR(o.order_date) = ?
                AND o.status = 'Đã giao'
                GROUP BY MONTH(o.order_date)
                ORDER BY MONTH(o.order_date)
                """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             ps.setInt(1, year);
             ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                StatisticsItem item = new StatisticsItem();
                item.setLabel("Tháng " + rs.getInt("month"));
                item.setTotalOrders(rs.getInt("total_orders"));
                item.setTotalProducts(rs.getInt("total_products"));
                item.setRevenue(rs.getInt("revenue"));
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //thống kê theo quý
    public List<StatisticsItem> getRevenueByQuarter(int year) {

        List<StatisticsItem> list = new ArrayList<>();

        String sql = """
            SELECT
                QUARTER(o.order_date) as quarter,

                COUNT(DISTINCT o.ID) as total_orders,

                SUM(oi.quantity) as total_products,

                SUM(oi.quantity * oi.price_at_purchase) as revenue

            FROM orders o
            JOIN order_items oi
            ON o.ID = oi.order_id
            WHERE YEAR(o.order_date) = ?
            AND o.status = 'Đã giao'
            GROUP BY QUARTER(o.order_date)
            ORDER BY QUARTER(o.order_date)
            """;

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, year);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                StatisticsItem item = new StatisticsItem();

                item.setLabel("Quý " + rs.getInt("quarter"));
                item.setTotalOrders(rs.getInt("total_orders"));
                item.setTotalProducts(rs.getInt("total_products"));
                item.setRevenue(rs.getDouble("revenue"));
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //thống kê theo năm
    public List<StatisticsItem> getRevenueByYear() {
        List<StatisticsItem> list = new ArrayList<>();

        String sql = """
        SELECT
            YEAR(o.order_date) as year,
            COUNT(DISTINCT o.ID) as total_orders,
            SUM(oi.quantity) as total_products,
            SUM(oi.quantity * oi.price_at_purchase) as revenue

        FROM orders o
        JOIN order_items oi
        ON o.ID = oi.order_id
        WHERE o.status = 'Đã giao'
        GROUP BY YEAR(o.order_date)
        ORDER BY YEAR(o.order_date)
    """;

        try (
                Connection conn = DBConnection.getConnection();

                PreparedStatement ps = conn.prepareStatement(sql)) {

                ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                StatisticsItem item = new StatisticsItem();
                item.setLabel(String.valueOf(rs.getInt("year")));
                item.setTotalOrders(rs.getInt("total_orders"));
                item.setTotalProducts(rs.getInt("total_products"));
                item.setRevenue(rs.getDouble("revenue"));
                list.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //thống kê theo trạng thái đơn (status)
    public Map<String, Integer> getOrderStatusStatistics() {
        Map<String, Integer> map = new LinkedHashMap<>();

        String sql = """
                SELECT status, count(*) as total
                FROM orders 
                GROUP BY status
                """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(
                        rs.getString("status"),
                        rs.getInt("total")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    return map;
    }

    //Top sản phẩm bán chạy nhất theo tháng
    public List<TopProduct> getTopProductsByMonth(int month, int year) {
        List<TopProduct> list = new ArrayList<>();

        String sql = """
                    SELECT
                    p.name, 
                    SUM(oi.quantity) as total_sold,
                    SUM(oi.quantity * oi.price_at_purchase) as revenue
                    
                    FROM order_items oi
                    JOIN products p ON oi.product_id = p.ID
                    JOIN orders o ON o.ID = oi.order_id
                    
                    WHERE MONTH(o.order_date) = ?
                    AND YEAR(o.order_date) = ?
                    AND o.status = "Đã giao"
                    GROUP BY p.ID, p.name
                    ORDER BY total_sold DESC LIMIT 5           
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                TopProduct topProduct = new TopProduct();

                topProduct.setProductName(rs.getString("name"));
                topProduct.setTotalSold(rs.getInt("total_sold"));
                topProduct.setRevenue(rs.getDouble("revenue"));
                list.add(topProduct);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // thống kê top sản phẩm bán chạy theo quý
    public List<TopProduct> getTopProductsByQuarter(int quarter, int year) {

        List<TopProduct> list = new ArrayList<>();

        String sql = """
        SELECT
            p.name,
            SUM(oi.quantity) as total_sold,
            SUM(oi.quantity * oi.price_at_purchase) as revenue

        FROM order_items oi
        JOIN products p
        ON oi.product_id = p.ID

        JOIN orders o
        ON oi.order_id = o.ID

        WHERE QUARTER(o.order_date) = ?
        AND YEAR(o.order_date) = ?
        AND o.status = 'Đã giao'

        GROUP BY p.ID, p.name
        ORDER BY total_sold DESC LIMIT 5
    """;

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, quarter);
            ps.setInt(2, year);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                TopProduct p = new TopProduct();

                p.setProductName(rs.getString("name"));
                p.setTotalSold(rs.getInt("total_sold"));
                p.setRevenue(rs.getDouble("revenue"));

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    //thống kê top sản phẩm bán chạy theo năm
    public List<TopProduct> getTopProductsByYear(int year) {

        List<TopProduct> list = new ArrayList<>();

        String sql = """
        SELECT
            p.name,
            SUM(oi.quantity) as total_sold,
            SUM(oi.quantity * oi.price_at_purchase) as revenue

        FROM order_items oi
        JOIN products p
        ON oi.product_id = p.ID

        JOIN orders o
        ON oi.order_id = o.ID

        WHERE YEAR(o.order_date) = ?
        AND o.status = 'Đã giao'
        GROUP BY p.ID, p.name
        ORDER BY total_sold DESC LIMIT 5
    """;

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, year);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                TopProduct p = new TopProduct();

                p.setProductName(rs.getString("name"));
                p.setTotalSold(rs.getInt("total_sold"));
                p.setRevenue(rs.getDouble("revenue"));

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
