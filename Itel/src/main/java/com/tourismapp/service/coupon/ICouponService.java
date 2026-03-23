package com.tourismapp.service.coupon;

import com.tourismapp.model.Coupon;
import java.util.List;
import java.util.Optional;

/**
 * Interface for Coupon Service
 */
public interface ICouponService {
    
    /**
     * Get all coupons
     * @return List of all coupons
     */
    List<Coupon> getAllCoupons();
    
    /**
     * Get active coupons
     * @return List of active coupons
     */
    List<Coupon> getActiveCoupons();
    
    /**
     * Find coupon by code
     * @param code Coupon code
     * @return Optional containing coupon if found, empty otherwise
     */
    Optional<Coupon> findCouponByCode(String code);
    
    /**
     * Create a new coupon
     * @param coupon Coupon to create
     * @return true if successful, false otherwise
     */
    boolean createCoupon(Coupon coupon);
    
    /**
     * Update an existing coupon
     * @param coupon Coupon to update
     * @return true if successful, false otherwise
     */
    boolean updateCoupon(Coupon coupon);
    
    /**
     * Delete a coupon
     * @param couponId ID of coupon to delete
     * @return true if successful, false otherwise
     */
    boolean deleteCoupon(int couponId);
    
    /**
     * Validate coupon code
     * @param code Coupon code
     * @param totalAmount Order total amount
     * @return Optional containing valid coupon if found and valid, empty otherwise
     */
    Optional<Coupon> validateCoupon(String code, java.math.BigDecimal totalAmount);
} 