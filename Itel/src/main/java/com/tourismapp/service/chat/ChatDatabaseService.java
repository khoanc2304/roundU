package com.tourismapp.service.chat;

import com.tourismapp.model.Product;
import com.tourismapp.model.Orders;
import com.tourismapp.model.Users;
import com.tourismapp.model.Brand;
import com.tourismapp.model.Category;
import com.tourismapp.service.product.ProductService;
import com.tourismapp.service.order.OrderService;
import com.tourismapp.service.user.UserService;
import com.tourismapp.service.brand.BrandService;
import com.tourismapp.service.category.CategoryService;
import com.tourismapp.service.brand.IBrandService;
import com.tourismapp.service.category.ICategoryService;

import java.util.List;
import java.util.Optional;
import java.util.regex.Pattern;
import java.util.regex.Matcher;
import java.math.BigDecimal;
import java.util.stream.Collectors;

/**
 * Service để xử lý logic phân tích câu hỏi và truy vấn database cho chatbox
 */
public class ChatDatabaseService {
    
    private final ProductService productService = new ProductService();
    private final OrderService orderService = new OrderService();
    private final UserService userService = new UserService();
    private final IBrandService brandService = new BrandService();
    private final ICategoryService categoryService = new CategoryService();
    
    /**
     * Phân tích câu hỏi và trả về dữ liệu từ database nếu có liên quan
     * @param question Câu hỏi của user
     * @return DatabaseResponse chứa thông tin về loại câu hỏi và dữ liệu
     */
    public DatabaseResponse analyzeQuestion(String question) {
        String lowerQuestion = question.toLowerCase();
        
        // Kiểm tra câu hỏi về sản phẩm
        if (isProductQuestion(lowerQuestion)) {
            return handleProductQuestion(lowerQuestion);
        }
        
        // Kiểm tra câu hỏi về đơn hàng
        if (isOrderQuestion(lowerQuestion)) {
            return handleOrderQuestion(lowerQuestion);
        }
        
        // Kiểm tra câu hỏi về user
        if (isUserQuestion(lowerQuestion)) {
            return handleUserQuestion(lowerQuestion);
        }
        
        // Kiểm tra câu hỏi về thương hiệu
        if (isBrandQuestion(lowerQuestion)) {
            return handleBrandQuestion(lowerQuestion);
        }
        
        // Kiểm tra câu hỏi về danh mục
        if (isCategoryQuestion(lowerQuestion)) {
            return handleCategoryQuestion(lowerQuestion);
        }
        
        // Kiểm tra câu hỏi về thống kê
        if (isStatisticsQuestion(lowerQuestion)) {
            return handleStatisticsQuestion(lowerQuestion);
        }
        
        // Không phải câu hỏi liên quan đến database
        return new DatabaseResponse(false, null, null, null);
    }
    
    private boolean isProductQuestion(String question) {
        String[] productKeywords = {
            "sản phẩm", "product", "laptop", "phone", "điện thoại", "chuột", "mouse", 
            "tai nghe", "headphone", "bàn phím", "keyboard", "macbook", "iphone", 
            "samsung", "dell", "hp", "lenovo", "asus", "acer", "giá", "price", 
            "có bao nhiêu", "tìm kiếm", "search", "thông tin", "information"
        };
        
        return containsAnyKeyword(question, productKeywords);
    }
    
    private boolean isOrderQuestion(String question) {
        String[] orderKeywords = {
            "đơn hàng", "order", "mua hàng", "purchase", "tổng tiền", "total amount",
            "trạng thái", "status", "ngày đặt", "order date", "shipping", "giao hàng"
        };
        
        return containsAnyKeyword(question, orderKeywords);
    }
    
    private boolean isUserQuestion(String question) {
        String[] userKeywords = {
            "user", "người dùng", "khách hàng", "customer", "admin", "thành viên",
            "membership", "level", "bronze", "silver", "gold", "diamond", "đồng", "bạc", "vàng", "kim cương"
        };
        
        return containsAnyKeyword(question, userKeywords);
    }
    
    private boolean isBrandQuestion(String question) {
        String[] brandKeywords = {
            "thương hiệu", "brand", "apple", "samsung", "dell", "hp", "lenovo", "asus", "acer",
            "xiaomi", "oppo", "vivo", "realme", "nokia", "logitech", "razer", "corsair"
        };
        
        return containsAnyKeyword(question, brandKeywords);
    }
    
    private boolean isCategoryQuestion(String question) {
        String[] categoryKeywords = {
            "danh mục", "category", "laptop", "phone", "điện thoại", "chuột", "mouse",
            "tai nghe", "headphone", "bàn phím", "keyboard"
        };
        
        return containsAnyKeyword(question, categoryKeywords);
    }
    
    private boolean isStatisticsQuestion(String question) {
        String[] statisticsKeywords = {
            "thống kê", "statistics", "tổng số", "total", "bao nhiêu", "count", "số lượng",
            "doanh thu", "revenue", "bán được", "sold", "phổ biến", "popular"
        };
        
        return containsAnyKeyword(question, statisticsKeywords);
    }
    
    private boolean containsAnyKeyword(String text, String[] keywords) {
        for (String keyword : keywords) {
            if (text.contains(keyword)) {
                return true;
            }
        }
        return false;
    }
    
    private DatabaseResponse handleProductQuestion(String question) {
        try {
            // Tìm kiếm sản phẩm theo tên
            if (question.contains("tìm") || question.contains("search") || question.contains("thông tin")) {
                String productName = extractProductName(question);
                if (productName != null) {
                    List<Product> products = productService.searchActiveProductsByName(productName);
                    if (!products.isEmpty()) {
                        return new DatabaseResponse(true, "product_search", products, 
                            "Tìm thấy " + products.size() + " sản phẩm phù hợp với '" + productName + "'");
                    }
                }
            }
            
            // Đếm số lượng sản phẩm
            if (question.contains("bao nhiêu") || question.contains("count") || question.contains("tổng số")) {
                List<Product> allProducts = productService.getActiveProducts();
                return new DatabaseResponse(true, "product_count", allProducts.size(), 
                    "Có tổng cộng " + allProducts.size() + " sản phẩm đang hoạt động");
            }
            
            // Lấy tất cả sản phẩm
            List<Product> products = productService.getActiveProducts();
            return new DatabaseResponse(true, "product_list", products, 
                "Danh sách tất cả sản phẩm (" + products.size() + " sản phẩm)");
            
        } catch (Exception e) {
            return new DatabaseResponse(false, null, null, "Lỗi khi truy vấn sản phẩm: " + e.getMessage());
        }
    }
    
    private DatabaseResponse handleOrderQuestion(String question) {
        try {
            // Đếm số đơn hàng
            if (question.contains("bao nhiêu") || question.contains("count") || question.contains("tổng số")) {
                List<Orders> allOrders = orderService.findAllOrders();
                return new DatabaseResponse(true, "order_count", allOrders.size(), 
                    "Có tổng cộng " + allOrders.size() + " đơn hàng");
            }
            
            // Lấy tất cả đơn hàng
            List<Orders> orders = orderService.findAllOrders();
            return new DatabaseResponse(true, "order_list", orders, 
                "Danh sách tất cả đơn hàng (" + orders.size() + " đơn hàng)");
            
        } catch (Exception e) {
            return new DatabaseResponse(false, null, null, "Lỗi khi truy vấn đơn hàng: " + e.getMessage());
        }
    }
    
    private DatabaseResponse handleUserQuestion(String question) {
        try {
            // Đếm số user
            if (question.contains("bao nhiêu") || question.contains("count") || question.contains("tổng số")) {
                List<Users> allUsers = userService.getAllUsers();
                return new DatabaseResponse(true, "user_count", allUsers.size(), 
                    "Có tổng cộng " + allUsers.size() + " người dùng");
            }
            
            // Lấy tất cả user
            List<Users> users = userService.getAllUsers();
            return new DatabaseResponse(true, "user_list", users, 
                "Danh sách tất cả người dùng (" + users.size() + " người dùng)");
            
        } catch (Exception e) {
            return new DatabaseResponse(false, null, null, "Lỗi khi truy vấn người dùng: " + e.getMessage());
        }
    }
    
    private DatabaseResponse handleBrandQuestion(String question) {
        try {
            List<Brand> brands = brandService.getAllBrands();
            return new DatabaseResponse(true, "brand_list", brands, 
                "Danh sách tất cả thương hiệu (" + brands.size() + " thương hiệu)");
        } catch (Exception e) {
            return new DatabaseResponse(false, null, null, "Lỗi khi truy vấn thương hiệu: " + e.getMessage());
        }
    }
    
    private DatabaseResponse handleCategoryQuestion(String question) {
        try {
            List<Category> categories = categoryService.getAllCategories();
            return new DatabaseResponse(true, "category_list", categories, 
                "Danh sách tất cả danh mục (" + categories.size() + " danh mục)");
        } catch (Exception e) {
            return new DatabaseResponse(false, null, null, "Lỗi khi truy vấn danh mục: " + e.getMessage());
        }
    }
    
    private DatabaseResponse handleStatisticsQuestion(String question) {
        try {
            // Thống kê tổng quan
            List<Product> products = productService.getActiveProducts();
            List<Orders> orders = orderService.findAllOrders();
            List<Users> users = userService.getAllUsers();
            
            StatisticsData stats = new StatisticsData();
            stats.setTotalProducts(products.size());
            stats.setTotalOrders(orders.size());
            stats.setTotalUsers(users.size());
            
            // Tính tổng doanh thu
            BigDecimal totalRevenue = orders.stream()
                .map(Orders::getTotalAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
            stats.setTotalRevenue(totalRevenue);
            
            return new DatabaseResponse(true, "statistics", stats, 
                "Thống kê tổng quan hệ thống");
            
        } catch (Exception e) {
            return new DatabaseResponse(false, null, null, "Lỗi khi truy vấn thống kê: " + e.getMessage());
        }
    }
    
    private String extractProductName(String question) {
        // Pattern để tìm tên sản phẩm trong câu hỏi
        Pattern pattern = Pattern.compile("(?:tìm|search|thông tin)\\s+(?:về\\s+)?([\\w\\s]+?)(?:\\?|$)", Pattern.CASE_INSENSITIVE);
        Matcher matcher = pattern.matcher(question);
        
        if (matcher.find()) {
            return matcher.group(1).trim();
        }
        
        return null;
    }
    
    /**
     * Tạo prompt cho AI dựa trên dữ liệu từ database
     * @param question Câu hỏi gốc
     * @param dbResponse Dữ liệu từ database
     * @return Prompt được format để gửi cho AI
     */
    public String createAIPrompt(String question, DatabaseResponse dbResponse) {
        StringBuilder prompt = new StringBuilder();
        
        prompt.append("Bạn là trợ lý AI của cửa hàng Itel Shop. Dưới đây là thông tin từ database của chúng tôi:\n\n");
        
        if (dbResponse.getDataType().equals("product_search") || dbResponse.getDataType().equals("product_list")) {
            List<Product> products = (List<Product>) dbResponse.getData();
            prompt.append("DANH SÁCH SẢN PHẨM:\n");
            for (Product product : products) {
                prompt.append("- ").append(product.getName())
                      .append(" (ID: ").append(product.getProductId()).append(")")
                      .append(" - Giá: ").append(product.getPrice()).append(" VNĐ")
                      .append(" - Thương hiệu: ").append(product.getBrand() != null ? product.getBrand().getName() : "N/A")
                      .append(" - Danh mục: ").append(product.getCategory() != null ? product.getCategory().getName() : "N/A")
                      .append("\n");
            }
        } else if (dbResponse.getDataType().equals("product_count")) {
            prompt.append("SỐ LƯỢNG SẢN PHẨM: ").append(dbResponse.getData()).append(" sản phẩm\n");
        } else if (dbResponse.getDataType().equals("order_count")) {
            prompt.append("SỐ LƯỢNG ĐƠN HÀNG: ").append(dbResponse.getData()).append(" đơn hàng\n");
        } else if (dbResponse.getDataType().equals("user_count")) {
            prompt.append("SỐ LƯỢNG NGƯỜI DÙNG: ").append(dbResponse.getData()).append(" người dùng\n");
        } else if (dbResponse.getDataType().equals("brand_list")) {
            List<Brand> brands = (List<Brand>) dbResponse.getData();
            prompt.append("DANH SÁCH THƯƠNG HIỆU:\n");
            for (Brand brand : brands) {
                prompt.append("- ").append(brand.getName())
                      .append(" (").append(brand.getCountry()).append(")\n");
            }
        } else if (dbResponse.getDataType().equals("category_list")) {
            List<Category> categories = (List<Category>) dbResponse.getData();
            prompt.append("DANH SÁCH DANH MỤC:\n");
            for (Category category : categories) {
                prompt.append("- ").append(category.getName())
                      .append(": ").append(category.getDescription()).append("\n");
            }
        } else if (dbResponse.getDataType().equals("statistics")) {
            StatisticsData stats = (StatisticsData) dbResponse.getData();
            prompt.append("THỐNG KÊ TỔNG QUAN:\n");
            prompt.append("- Tổng sản phẩm: ").append(stats.getTotalProducts()).append("\n");
            prompt.append("- Tổng đơn hàng: ").append(stats.getTotalOrders()).append("\n");
            prompt.append("- Tổng người dùng: ").append(stats.getTotalUsers()).append("\n");
            prompt.append("- Tổng doanh thu: ").append(stats.getTotalRevenue()).append(" VNĐ\n");
        }
        
        prompt.append("\nCÂU HỎI CỦA NGƯỜI DÙNG: ").append(question).append("\n\n");
        prompt.append("Hãy trả lời dựa trên thông tin database trên. Nếu câu hỏi không liên quan đến thông tin này, hãy trả lời chung chung về Itel Shop.");
        
        return prompt.toString();
    }
    
    /**
     * Class để chứa dữ liệu thống kê
     */
    public static class StatisticsData {
        private int totalProducts;
        private int totalOrders;
        private int totalUsers;
        private BigDecimal totalRevenue;
        
        // Getters and setters
        public int getTotalProducts() { return totalProducts; }
        public void setTotalProducts(int totalProducts) { this.totalProducts = totalProducts; }
        
        public int getTotalOrders() { return totalOrders; }
        public void setTotalOrders(int totalOrders) { this.totalOrders = totalOrders; }
        
        public int getTotalUsers() { return totalUsers; }
        public void setTotalUsers(int totalUsers) { this.totalUsers = totalUsers; }
        
        public BigDecimal getTotalRevenue() { return totalRevenue; }
        public void setTotalRevenue(BigDecimal totalRevenue) { this.totalRevenue = totalRevenue; }
    }
    
    /**
     * Class để chứa response từ database
     */
    public static class DatabaseResponse {
        private boolean hasData;
        private String dataType;
        private Object data;
        private String message;
        
        public DatabaseResponse(boolean hasData, String dataType, Object data, String message) {
            this.hasData = hasData;
            this.dataType = dataType;
            this.data = data;
            this.message = message;
        }
        
        // Getters
        public boolean hasData() { return hasData; }
        public String getDataType() { return dataType; }
        public Object getData() { return data; }
        public String getMessage() { return message; }
    }
} 