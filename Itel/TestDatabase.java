import com.tourismapp.dao.DBConnection;
import com.tourismapp.dao.order.OrderDAO;
import com.tourismapp.model.Orders;
import com.tourismapp.model.OrderStat;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;

public class TestDatabase {
    public static void main(String[] args) {
        try {
            System.out.println("=== Testing Database Connection ===");
            
            // Test connection
            Connection conn = DBConnection.getConnection();
            if (conn != null) {
                System.out.println("✅ Database connection successful");
                
                // Test Orders table
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as count FROM Orders");
                if (rs.next()) {
                    int orderCount = rs.getInt("count");
                    System.out.println("📊 Total orders in database: " + orderCount);
                }
                
                // Test Users table
                rs = stmt.executeQuery("SELECT COUNT(*) as count FROM Users");
                if (rs.next()) {
                    int userCount = rs.getInt("count");
                    System.out.println("👥 Total users in database: " + userCount);
                }
                
                // Test recent orders
                rs = stmt.executeQuery("SELECT TOP 5 order_id, user_id, order_date, status FROM Orders ORDER BY order_date DESC");
                System.out.println("\n📋 Recent orders:");
                while (rs.next()) {
                    System.out.println("Order ID: " + rs.getInt("order_id") + 
                                    ", User ID: " + rs.getInt("user_id") + 
                                    ", Date: " + rs.getTimestamp("order_date") + 
                                    ", Status: " + rs.getString("status"));
                }
                
                conn.close();
            } else {
                System.out.println("❌ Database connection failed");
            }
            
            // Test OrderDAO methods
            System.out.println("\n=== Testing OrderDAO ===");
            OrderDAO orderDAO = new OrderDAO();
            
            List<Orders> allOrders = orderDAO.getAllOrders();
            System.out.println("📦 getAllOrders returned: " + allOrders.size() + " orders");
            
            List<OrderStat> monthStats = orderDAO.getOrderStatsByMonth();
            System.out.println("📊 getOrderStatsByMonth returned: " + monthStats.size() + " stats");
            
            List<OrderStat> revenueStats = orderDAO.getRevenueStatsByMonth();
            System.out.println("💰 getRevenueStatsByMonth returned: " + revenueStats.size() + " stats");
            
        } catch (Exception e) {
            System.err.println("❌ Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
} 