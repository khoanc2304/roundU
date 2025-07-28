package com.tourismapp.service.coupon;

import com.tourismapp.dao.coupon.CouponDAO;
import com.tourismapp.dao.coupon.ICouponDAO;
import com.tourismapp.model.Coupon;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Implementation for Coupon Service
 */
public class CouponService implements ICouponService {

    private final ICouponDAO couponDAO = new CouponDAO();
    
    @Override
    public List<Coupon> getAllCoupons() {
        return couponDAO.getAllCoupons();
    }

    @Override
    public List<Coupon> getActiveCoupons() {
        return couponDAO.getActiveCoupons();
    }

    @Override
    public Optional<Coupon> findCouponByCode(String code) {
        return couponDAO.findCouponByCode(code);
    }

    @Override
    public boolean createCoupon(Coupon coupon) {
        return couponDAO.createCoupon(coupon);
    }

    @Override
    public boolean updateCoupon(Coupon coupon) {
        return couponDAO.updateCoupon(coupon);
    }

    @Override
    public boolean deleteCoupon(int couponId) {
        return couponDAO.deleteCoupon(couponId);
    }
    
    @Override
    public Optional<Coupon> validateCoupon(String code, BigDecimal totalAmount) {
        if (code == null || code.trim().isEmpty()) {
            return Optional.empty();
        }
        
        Optional<Coupon> couponOpt = findCouponByCode(code.trim());
        
        if (!couponOpt.isPresent()) {
            return Optional.empty();
        }
        
        Coupon coupon = couponOpt.get();
        
        // Check if coupon is active
        if (!coupon.isActive()) {
            return Optional.empty();
        }
        
        // Check if coupon is valid for current date
        LocalDateTime now = LocalDateTime.now();
        if (now.isBefore(coupon.getStartDate()) || now.isAfter(coupon.getEndDate())) {
            return Optional.empty();
        }
        
        // Check if total amount meets minimum purchase requirement
        if (totalAmount.compareTo(coupon.getMinPurchaseAmount()) < 0) {
            return Optional.empty();
        }
        
        return Optional.of(coupon);
    }
} 