/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.service.review;

import com.tourismapp.repository.review.ReviewRepository;
import com.tourismapp.model.Review;
import com.tourismapp.model.StatisticReview;
import java.util.List;

/**
 *
 * @author Admin
 */
import org.springframework.stereotype.Service;

@Service
public class ReviewService implements IReviewService {

    private final ReviewRepository ReviewRepository = new ReviewRepository();

    @Override
    public int getTotalCommentsByProductId(int productId) {
        return ReviewRepository.getTotalCommentsByProductId(productId);
    }

    @Override
    public StatisticReview getRatingCountByProductId(int productId) {
        return ReviewRepository.getRatingCountByProductId(productId);
    }

    @Override
    public List<Review> getAllActiveReviews() {
        return ReviewRepository.getAllActiveReviews();
    }

    @Override
    public Review getReviewById(int viewId) {
        return ReviewRepository.getReviewById(viewId);
    }

    @Override
    public List<Review> getReviewsByProductId(int productId) {
        return ReviewRepository.getReviewsByProductId(productId);
    }

    @Override
    public boolean addReview(Review review) {
        return ReviewRepository.addReview(review);
    }

    @Override
    public boolean updateReview(Review review) {
        return ReviewRepository.updateReview(review);
    }

    @Override
    public boolean deleteReview(int id) {
        return ReviewRepository.deleteReview(id);
    }

    @Override
    public List<StatisticReview> getStatisticReview() {
        return ReviewRepository.getStatisticReview();
    }

    @Override
    public boolean hasUserPurchasedProduct(int userId, int productId) {
        return ReviewRepository.hasUserPurchasedProduct(userId, productId);
    }

    @Override
    public List<Review> getReviewsByProductIdAndRating(int productId, int rating) {
        return ReviewRepository.getReviewsByProductIdAndRating(productId, rating);
    }
}
