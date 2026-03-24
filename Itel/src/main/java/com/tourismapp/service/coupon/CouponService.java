package com.tourismapp.service.coupon;

import com.tourismapp.repository.coupon.CouponRepository;
import com.tourismapp.repository.coupon.CouponRepository;
import com.tourismapp.model.Coupon;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Implementation for Coupon Service
 */
public class CouponService implements ICouponService {

    private final CouponRepository CouponRepository = new CouponRepository();
    
    @Override
    public List<Coupon> getAllCoupons() {
        return CouponRepository.getAllCoupons();
    }

    @Override
    public List<Coupon> getActiveCoupons() {
        return CouponRepository.getActiveCoupons();
    }

    @Override
    public Optional<Coupon> findCouponByCode(String code) {
        return CouponRepository.findCouponByCode(code);
    }

    @Override
    public boolean createCoupon(Coupon coupon) {
        return CouponRepository.createCoupon(coupon);
    }

    @Override
    public boolean updateCoupon(Coupon coupon) {
        return CouponRepository.updateCoupon(coupon);
    }

    @Override
    public boolean deleteCoupon(int couponId) {
        return CouponRepository.deleteCoupon(couponId);
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