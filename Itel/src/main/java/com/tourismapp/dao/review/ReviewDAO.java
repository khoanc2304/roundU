package com.tourismapp.dao.review;

import com.sun.tools.xjc.reader.xmlschema.bindinfo.BIConversion.User;
import com.tourismapp.common.Status;
import com.tourismapp.dao.DBConnection;
import com.tourismapp.dao.product.IProductDAO;
import com.tourismapp.dao.product.ProductDAO;
import com.tourismapp.dao.user.IUserDAO;
import com.tourismapp.dao.user.UserDAO;
import com.tourismapp.model.Product;
import com.tourismapp.model.Users;
import com.tourismapp.model.Review;
import com.tourismapp.model.StatisticReview;
import com.tourismapp.utils.ErrDialog;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ReviewDAO implements IReviewDAO {
    
    private final IProductDAO productDAO = new ProductDAO();
    private final IUserDAO userDAO = new UserDAO(); 
    
    private static final String GET_ALL_ACTIVE_REVIEWS = "SELECT * FROM Review WHERE status = 'ACTIVE'";
    private static final String GET_REVIEW_BY_ID = "SELECT * FROM Review WHERE review_id = ?";
    private static final String GET_REVIEW_BY_PRODUCT_ID = "SELECT * FROM Review WHERE product_id = ? AND status = 'ACTIVE'";
    private static final String ADD_REVIEW = "INSERT INTO Review (product_id, user_id, rating, comment, parent_review_id) VALUES (?, ?, ?, ?, ?)";
    private static final String UPDATE_REVIEW = "UPDATE Review SET rating = ?, comment = ?, updated_at = GETDATE() WHERE review_id = ?";
    private static final String DELETE_REVIEW = "UPDATE Review SET status = 'INACTIVE' WHERE review_id = ?";
    private static final String STAT_REVIEW = "SELECT "
            + "COUNT(*) AS total_count, "
            + "AVG(CAST(rating AS FLOAT)) AS average_rating, "
            + "SUM(CASE WHEN rating = 1 THEN 1 ELSE 0 END) AS count_1_star, "
            + "SUM(CASE WHEN rating = 2 THEN 1 ELSE 0 END) AS count_2_star, "
            + "SUM(CASE WHEN rating = 3 THEN 1 ELSE 0 END) AS count_3_star, "
            + "SUM(CASE WHEN rating = 4 THEN 1 ELSE 0 END) AS count_4_star, "
            + "SUM(CASE WHEN rating = 5 THEN 1 ELSE 0 END) AS count_5_star "
            + "FROM Review WHERE product_id = ? AND status = 'ACTIVE'";

    private static final String COUNT_COMMENTS
            = "SELECT COUNT(*) AS total_comments FROM Review WHERE product_id = ? AND status = 'ACTIVE'";
    
    private static final String GET_REVIEW_WITH_USER = "SELECT r.*, u.username, u.fullName, u.email FROM Review r " +
            "JOIN Users u ON r.user_id = u.user_id " +
            "WHERE r.product_id = ? AND r.status = 'ACTIVE' " +
            "ORDER BY r.created_at DESC";
    
    // Method to check if user has purchased the product
    private static final String CHECK_USER_PURCHASED_PRODUCT = 
            "SELECT COUNT(*) FROM Order_Detail od " +
            "JOIN Orders o ON od.order_id = o.order_id " +
            "WHERE o.user_id = ? AND od.product_id = ? AND o.status = 'completed'";
    
    public boolean hasUserPurchasedProduct(int userId, int productId) {
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(CHECK_USER_PURCHASED_PRODUCT)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            ErrDialog.showError("hasUserPurchasedProduct(): " + e.getMessage());
        }
        return false;
    }
    
    @Override
    public int getTotalCommentsByProductId(int productId) {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(COUNT_COMMENTS)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total_comments");
                }
            }
        } catch (Exception e) {
            ErrDialog.showError("getTotalCommentsByProductId(): " + e.getMessage());
        }
        return 0;
    }

    @Override
    public StatisticReview getRatingCountByProductId(int productId) {
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(STAT_REVIEW)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new StatisticReview(
                            rs.getInt("total_count"),
                            Math.round(rs.getDouble("average_rating") * 10.0) / 10.0,
                            rs.getInt("count_1_star"),
                            rs.getInt("count_2_star"),
                            rs.getInt("count_3_star"),
                            rs.getInt("count_4_star"),
                            rs.getInt("count_5_star")
                    );
                }
            }
        } catch (Exception e) {
            ErrDialog.showError("getRatingCountByProductId(): " + e.getMessage());
        }
        return null;
    }

    @Override
    public List<Review> getAllActiveReviews() {
        List<Review> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(GET_ALL_ACTIVE_REVIEWS); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(extractReview(rs));
            }
        } catch (Exception e) {
            ErrDialog.showError("getAllActiveReviews(): " + e.getMessage());
        }
        return list;
    }

    @Override
    public Review getReviewById(int reviewId) {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(GET_REVIEW_BY_ID)) {
            ps.setInt(1, reviewId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractReview(rs);
                }
            }
        } catch (Exception e) {
            ErrDialog.showError("getReviewById(): " + e.getMessage());
        }
        return null;
    }

    @Override
    public List<Review> getReviewsByProductId(int productId) {
        List<Review> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(GET_REVIEW_WITH_USER)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractReview(rs));
                }
            }
        } catch (Exception e) {
            ErrDialog.showError("getReviewsByProductId(): " + e.getMessage());
        }
        return list;
    }

    @Override
    public boolean addReview(Review review) {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(ADD_REVIEW)) {
            ps.setInt(1, review.getProduct().getProductId());
            ps.setInt(2, review.getUser().getUserId());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getComment());
            if (review.getParent_review_id() != null) {
                ps.setInt(5, review.getParent_review_id());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            ErrDialog.showError("addReview(): " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean updateReview(Review review) {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(UPDATE_REVIEW)) {
            ps.setInt(1, review.getRating());
            ps.setString(2, review.getComment());
            ps.setInt(3, review.getReviewId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            ErrDialog.showError("updateReview(): " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean deleteReview(int reviewId) {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(DELETE_REVIEW)) {
            ps.setInt(1, reviewId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            ErrDialog.showError("deleteReview(): " + e.getMessage());
        }
        return false;
    }

    private Review extractReview(ResultSet rs) throws SQLException {
        int reviewId = rs.getInt("review_id");
        int productId = rs.getInt("product_id");
        int userId = rs.getInt("user_id");
        int rating = rs.getInt("rating");
        String comment = rs.getString("comment");
        Integer parent_review_id = rs.getInt("parent_review_id");
        String statusStr = rs.getString("status");
        Status status = Status.valueOf(statusStr.toUpperCase());
        LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime();
        LocalDateTime updatedAt = rs.getTimestamp("updated_at").toLocalDateTime();

        Optional<Product> product = productDAO.findProductById(productId);
        
        Users user = userDAO.getUserById(userId);

        return new Review(reviewId, product.get(), user, rating, comment, parent_review_id, status, createdAt, updatedAt);
    }
    
    public static void main(String[] args) {
        int productId = 1; // ID sản phẩm muốn test

        ReviewDAO reviewDAO = new ReviewDAO();
        List<Review> reviews = reviewDAO.getReviewsByProductId(productId);

        if (reviews.isEmpty()) {
            System.out.println("Không có đánh giá nào cho sản phẩm có ID = " + productId);
        } else {
            for (Review r : reviews) {
                System.out.println("User: " + r.getUser().getUsername());
                System.out.println("Rating: " + r.getRating());
                System.out.println("Comment: " + r.getComment());
                System.out.println("Date: " + r.getCreatedAt());
                System.out.println("------------------------------");
            }
        }
    }

    @Override
    public List<StatisticReview> getStatisticReview() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<Review> getReviewsByProductIdAndRating(int productId, int rating) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.*, u.username, u.fullName, u.email FROM Review r " +
                "JOIN Users u ON r.user_id = u.user_id " +
                "WHERE r.product_id = ? AND r.rating = ? AND r.status = 'active' " +
                "ORDER BY r.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, rating);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractReview(rs));
                }
            }
        } catch (Exception e) {
            ErrDialog.showError("getReviewsByProductIdAndRating(): " + e.getMessage());
        }
        return list;
    }
}
