package com.tourismapp.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import jakarta.persistence.*;

/**
 * Model class for Coupon
 */
@Entity
@Table(name = "Coupon")
public class Coupon {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "coupon_id")
    private int couponId;
    private String code;
    private String description;
    private BigDecimal discountPercent;
    private BigDecimal minPurchaseAmount;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private boolean isActive;
    private LocalDateTime createdAt;
    private String discountType; // "percent" or "fixed"

    public Coupon() {
    }

    public Coupon(int couponId, String code, String description, BigDecimal discountPercent, 
                 BigDecimal minPurchaseAmount, LocalDateTime startDate, LocalDateTime endDate, 
                 boolean isActive, LocalDateTime createdAt) {
        this.couponId = couponId;
        this.code = code;
        this.description = description;
        this.discountPercent = discountPercent;
        this.minPurchaseAmount = minPurchaseAmount;
        this.startDate = startDate;
        this.endDate = endDate;
        this.isActive = isActive;
        this.createdAt = createdAt;
        this.discountType = "percent"; // Default to percent
    }

    public Coupon(int couponId, String code, String description, BigDecimal discountPercent, 
                 BigDecimal minPurchaseAmount, LocalDateTime startDate, LocalDateTime endDate, 
                 boolean isActive, LocalDateTime createdAt, String discountType) {
        this.couponId = couponId;
        this.code = code;
        this.description = description;
        this.discountPercent = discountPercent;
        this.minPurchaseAmount = minPurchaseAmount;
        this.startDate = startDate;
        this.endDate = endDate;
        this.isActive = isActive;
        this.createdAt = createdAt;
        this.discountType = discountType;
    }

    public Coupon(String code, String description, BigDecimal discountPercent, 
                 BigDecimal minPurchaseAmount, LocalDateTime startDate, LocalDateTime endDate) {
        this.code = code;
        this.description = description;
        this.discountPercent = discountPercent;
        this.minPurchaseAmount = minPurchaseAmount;
        this.startDate = startDate;
        this.endDate = endDate;
        this.isActive = true;
        this.createdAt = LocalDateTime.now();
        this.discountType = "percent"; // Default to percent
    }

    public Coupon(String code, String description, BigDecimal discountPercent, 
                 BigDecimal minPurchaseAmount, LocalDateTime startDate, LocalDateTime endDate,
                 String discountType) {
        this.code = code;
        this.description = description;
        this.discountPercent = discountPercent;
        this.minPurchaseAmount = minPurchaseAmount;
        this.startDate = startDate;
        this.endDate = endDate;
        this.isActive = true;
        this.createdAt = LocalDateTime.now();
        this.discountType = discountType;
    }

    public int getCouponId() {
        return couponId;
    }

    public void setCouponId(int couponId) {
        this.couponId = couponId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(BigDecimal discountPercent) {
        this.discountPercent = discountPercent;
    }

    public BigDecimal getMinPurchaseAmount() {
        return minPurchaseAmount;
    }

    public void setMinPurchaseAmount(BigDecimal minPurchaseAmount) {
        this.minPurchaseAmount = minPurchaseAmount;
    }

    public LocalDateTime getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDateTime startDate) {
        this.startDate = startDate;
    }

    public LocalDateTime getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDateTime endDate) {
        this.endDate = endDate;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getDiscountType() {
        return discountType;
    }
    
    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }
    
    /**
     * Check if coupon is valid for the current date
     * @return true if coupon is valid, false otherwise
     */
    public boolean isValid() {
        LocalDateTime now = LocalDateTime.now();
        return isActive && now.isAfter(startDate) && now.isBefore(endDate);
    }
    
    /**
     * Check if coupon is valid for the given amount
     * @param amount Purchase amount
     * @return true if coupon is valid for the amount, false otherwise
     */
    public boolean isValidForAmount(BigDecimal amount) {
        return amount.compareTo(minPurchaseAmount) >= 0;
    }
    
    /**
     * Calculate discount amount based on the discount type
     * @param originalAmount Original purchase amount
     * @return Discount amount
     */
    public BigDecimal calculateDiscount(BigDecimal originalAmount) {
        if ("fixed".equals(discountType)) {
            return discountPercent; // For fixed discount, discountPercent is the actual amount
        } else {
            // For percentage discount, calculate the percentage of the original amount
            return originalAmount.multiply(discountPercent.divide(BigDecimal.valueOf(100)));
        }
    }

    @Override
    public String toString() {
        return "Coupon{" +
                "couponId=" + couponId +
                ", code='" + code + '\'' +
                ", description='" + description + '\'' +
                ", discountPercent=" + discountPercent +
                ", minPurchaseAmount=" + minPurchaseAmount +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", isActive=" + isActive +
                ", createdAt=" + createdAt +
                ", discountType='" + discountType + '\'' +
                '}';
    }
} 