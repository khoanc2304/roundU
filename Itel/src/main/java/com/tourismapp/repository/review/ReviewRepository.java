package com.tourismapp.repository.review;

import com.tourismapp.common.Status;
import com.tourismapp.repository.product.ProductRepository;
import com.tourismapp.repository.user.UserRepository;
import com.tourismapp.entity.Product;
import com.tourismapp.entity.Users;
import com.tourismapp.entity.Review;
import com.tourismapp.dto.StatisticReview;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.ArrayList;

import org.springframework.stereotype.Repository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.dao.EmptyResultDataAccessException;

@Repository
public class ReviewRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private ProductRepository productRepository;
    
    @Autowired
    private UserRepository userRepository;

    private static final String GET_ALL_ACTIVE_REVIEWS = "SELECT * FROM Review WHERE status = 'ACTIVE'";
    private static final String GET_REVIEW_BY_ID = "SELECT * FROM Review WHERE review_id = ?";
    private static final String GET_REVIEW_BY_PRODUCT_ID = "SELECT * FROM Review WHERE product_id = ? AND status = 'ACTIVE'";
    private static final String ADD_REVIEW = "INSERT INTO Review (product_id, user_id, rating, comment, parent_review_id) VALUES (?, ?, ?, ?, ?)";
    private static final String UPDATE_REVIEW = "UPDATE Review SET rating = ?, comment = ?, updated_at = CURRENT_TIMESTAMP WHERE review_id = ?";
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

    private static final String COUNT_COMMENTS = "SELECT COUNT(*) AS total_comments FROM Review WHERE product_id = ? AND status = 'ACTIVE'";

    private static final String GET_REVIEW_WITH_USER = "SELECT r.*, u.username, u.fullName, u.email FROM Review r " +
            "JOIN Users u ON r.user_id = u.user_id " +
            "WHERE r.product_id = ? AND r.status = 'ACTIVE' " +
            "ORDER BY r.created_at DESC";

    private static final String CHECK_USER_PURCHASED_PRODUCT = "SELECT COUNT(*) FROM Order_Detail od " +
            "JOIN Orders o ON od.order_id = o.order_id " +
            "WHERE o.user_id = ? AND od.product_id = ? AND o.status = 'completed'";

    private final RowMapper<Review> reviewRowMapper = (rs, rowNum) -> mapReview(rs);

    private Review mapReview(ResultSet rs) throws SQLException {
        int reviewId = rs.getInt("review_id");
        int productId = rs.getInt("product_id");
        int userId = rs.getInt("user_id");
        int rating = rs.getInt("rating");
        String comment = rs.getString("comment");
        Integer parent_review_id = rs.getInt("parent_review_id");
        if (rs.wasNull()) {
            parent_review_id = null;
        }
        String statusStr = rs.getString("status");
        Status status = Status.valueOf(statusStr.toUpperCase());
        LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime();
        LocalDateTime updatedAt = rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null;

        Optional<Product> product = productRepository.findProductById(productId);
        Users user = userRepository.getUserById(userId);

        return new Review(reviewId, product.orElse(null), user, rating, comment, parent_review_id, status, createdAt, updatedAt);
    }

    public boolean hasUserPurchasedProduct(int userId, int productId) {
        Integer count = jdbcTemplate.queryForObject(CHECK_USER_PURCHASED_PRODUCT, Integer.class, userId, productId);
        return count != null && count > 0;
    }

    public int getTotalCommentsByProductId(int productId) {
        Integer total = jdbcTemplate.queryForObject(COUNT_COMMENTS, Integer.class, productId);
        return total != null ? total : 0;
    }

    public StatisticReview getRatingCountByProductId(int productId) {
        try {
            return jdbcTemplate.queryForObject(STAT_REVIEW, (rs, rowNum) -> new StatisticReview(
                    rs.getInt("total_count"),
                    Math.round(rs.getDouble("average_rating") * 10.0) / 10.0,
                    rs.getInt("count_1_star"),
                    rs.getInt("count_2_star"),
                    rs.getInt("count_3_star"),
                    rs.getInt("count_4_star"),
                    rs.getInt("count_5_star")
            ), productId);
        } catch (EmptyResultDataAccessException e) {
            return new StatisticReview(0, 0.0, 0, 0, 0, 0, 0);
        }
    }

    public List<Review> getAllActiveReviews() {
        return jdbcTemplate.query(GET_ALL_ACTIVE_REVIEWS, reviewRowMapper);
    }

    public Review getReviewById(int reviewId) {
        try {
            return jdbcTemplate.queryForObject(GET_REVIEW_BY_ID, reviewRowMapper, reviewId);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    public List<Review> getReviewsByProductId(int productId) {
        return jdbcTemplate.query(GET_REVIEW_WITH_USER, reviewRowMapper, productId);
    }

    public boolean addReview(Review review) {
        int rows = jdbcTemplate.update(ADD_REVIEW,
                review.getProduct().getProductId(),
                review.getUser().getUserId(),
                review.getRating(),
                review.getComment(),
                review.getParent_review_id());
        return rows > 0;
    }

    public boolean updateReview(Review review) {
        int rows = jdbcTemplate.update(UPDATE_REVIEW,
                review.getRating(),
                review.getComment(),
                review.getReviewId());
        return rows > 0;
    }

    public boolean deleteReview(int reviewId) {
        int rows = jdbcTemplate.update(DELETE_REVIEW, reviewId);
        return rows > 0;
    }

    public List<StatisticReview> getStatisticReview() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public List<Review> getReviewsByProductIdAndRating(int productId, int rating) {
        String sql = "SELECT r.*, u.username, u.fullName, u.email FROM Review r " +
                "JOIN Users u ON r.user_id = u.user_id " +
                "WHERE r.product_id = ? AND r.rating = ? AND r.status = 'active' " +
                "ORDER BY r.created_at DESC";
        return jdbcTemplate.query(sql, reviewRowMapper, productId, rating);
    }
}
