package com.tourismapp.model;

import com.tourismapp.common.Status;
import java.time.LocalDateTime;

/**
 *
 * @author Admin
 */
public class Review {

    private int reviewId;
    private Product product;
    private Users user;
    private int rating;
    private String comment;
    private Integer parent_review_id;
    private Status status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Review() {
    }

    public Review(int reviewId, Product product, Users user, int rating,
            String comment, Integer parent_review_id, Status status, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.reviewId = reviewId;
        this.product = product;
        this.user = user;
        this.rating = rating;
        this.comment = comment;
        this.parent_review_id = parent_review_id;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    
    public Review(Product product, Users user, int rating,
            String comment, Integer parent_review_id) {
        this.product = product;
        this.user = user;
        this.rating = rating;
        this.comment = comment;
        this.parent_review_id = parent_review_id;
    }
    
    public Review(int reviewId, int rating, String comment) {
        this.reviewId = reviewId;
        this.rating = rating;
        this.comment = comment;
    }

    public Review(Product product, Users user, int rating,
            String comment, Integer parent_review_id, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.product = product;
        this.user = user;
        this.rating = rating;
        this.comment = comment;
        this.parent_review_id = parent_review_id;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public Users getUser() {
        return user;
    }

    public void setUser(Users user) {
        this.user = user;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Integer getParent_review_id() {
        return parent_review_id;
    }

    public void setParent_review_id(Integer parent_review_id) {
        this.parent_review_id = parent_review_id;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "Review{"
                + "reviewId=" + reviewId
                + ", product=" + (product != null ? product.getProductId() : "null")
                + ", user=" + (user != null ? user.getUserId() : "null")
                + ", rating=" + rating
                + ", comment='" + comment + '\''
                + ", parent_review_id='" + parent_review_id + '\''
                + ", status='" + status + '\''
                + ", createdAt=" + createdAt
                + ", updatedAt=" + updatedAt
                + '}';
    }
}
