/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.service.review;

import com.tourismapp.model.Review;
import com.tourismapp.model.StatisticReview;
import java.util.List;

/**
 *
 * @author Admin
 */
public interface IReviewService {
    
    int getTotalCommentsByProductId(int productId);
    
    StatisticReview getRatingCountByProductId(int productId);
    
     List<Review> getAllActiveReviews();
    
    Review getReviewById(int viewId);
    
    List<Review> getReviewsByProductId(int productId);
    
    boolean addReview(Review review);
    
    boolean updateReview(Review review);
    
    boolean deleteReview(int reviewId);
    
    List<StatisticReview> getStatisticReview();
    
    // Method to check if user has purchased the product
    boolean hasUserPurchasedProduct(int userId, int productId);
    
    List<Review> getReviewsByProductIdAndRating(int productId, int rating);
}
