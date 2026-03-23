/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.service.review;

import com.tourismapp.dao.review.IReviewDAO;
import com.tourismapp.dao.review.ReviewDAO;
import com.tourismapp.model.Review;
import com.tourismapp.model.StatisticReview;
import java.util.List;

/**
 *
 * @author Admin
 */
public class ReviewService implements IReviewService {
    
    private final IReviewDAO reviewDAO = new ReviewDAO();

    @Override
    public int getTotalCommentsByProductId(int productId) {
        return reviewDAO.getTotalCommentsByProductId(productId);
    }
    
    @Override
    public StatisticReview getRatingCountByProductId(int productId){
        return reviewDAO.getRatingCountByProductId(productId);
    }
    
    @Override
    public List<Review> getAllActiveReviews() {
        return reviewDAO.getAllActiveReviews();
    }

    @Override
    public Review getReviewById(int viewId) {
        return reviewDAO.getReviewById(viewId);
    }

    @Override
    public List<Review> getReviewsByProductId(int productId) {
        return reviewDAO.getReviewsByProductId(productId);
    }

    @Override
    public boolean addReview(Review review) {
        return reviewDAO.addReview(review);
    }

    @Override
    public boolean updateReview(Review review) {
        return reviewDAO.updateReview(review);
    }

    @Override
    public boolean deleteReview(int id) {
        return reviewDAO.deleteReview(id);
    }

    @Override
    public List<StatisticReview> getStatisticReview() {
        return reviewDAO.getStatisticReview();
    }
    
    @Override
    public boolean hasUserPurchasedProduct(int userId, int productId) {
        return reviewDAO.hasUserPurchasedProduct(userId, productId);
    }

    @Override
    public List<Review> getReviewsByProductIdAndRating(int productId, int rating) {
        return reviewDAO.getReviewsByProductIdAndRating(productId, rating);
    }
}
