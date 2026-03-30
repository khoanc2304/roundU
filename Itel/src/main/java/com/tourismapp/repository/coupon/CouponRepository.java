package com.tourismapp.repository.coupon;

import com.tourismapp.entity.Coupon;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

/**
 * Implementation for Coupon DAO
 */
@Repository
public class CouponRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final String GET_ALL_COUPONS = "SELECT * FROM Coupon ORDER BY created_at DESC;";
    private static final String GET_ACTIVE_COUPONS = "SELECT * FROM Coupon WHERE is_active = 1 AND start_date <= CURRENT_TIMESTAMP AND end_date >= CURRENT_TIMESTAMP ORDER BY created_at DESC;";
    private static final String FIND_COUPON_BY_CODE = "SELECT * FROM Coupon WHERE code = ?;";
    private static final String CREATE_COUPON = "INSERT INTO Coupon (code, description, discount_percent, min_purchase_amount, start_date, end_date, is_active) VALUES (?, ?, ?, ?, ?, ?, ?);";
    private static final String UPDATE_COUPON = "UPDATE Coupon SET code = ?, description = ?, discount_percent = ?, min_purchase_amount = ?, start_date = ?, end_date = ?, is_active = ? WHERE coupon_id = ?;";
    private static final String DELETE_COUPON = "DELETE FROM Coupon WHERE coupon_id = ?;";

    private final RowMapper<Coupon> couponRowMapper = (rs, rowNum) -> new Coupon(
            rs.getInt("coupon_id"),
            rs.getString("code"),
            rs.getString("description"),
            rs.getBigDecimal("discount_percent"),
            rs.getBigDecimal("min_purchase_amount"),
            rs.getTimestamp("start_date").toLocalDateTime(),
            rs.getTimestamp("end_date").toLocalDateTime(),
            rs.getBoolean("is_active"),
            rs.getTimestamp("created_at").toLocalDateTime()
    );

    public List<Coupon> getAllCoupons() {
        return jdbcTemplate.query(GET_ALL_COUPONS, couponRowMapper);
    }

    public List<Coupon> getActiveCoupons() {
        return jdbcTemplate.query(GET_ACTIVE_COUPONS, couponRowMapper);
    }

    public Optional<Coupon> findCouponByCode(String code) {
        try {
            Coupon coupon = jdbcTemplate.queryForObject(FIND_COUPON_BY_CODE, couponRowMapper, code);
            return Optional.ofNullable(coupon);
        } catch (EmptyResultDataAccessException e) {
            return Optional.empty();
        }
    }

    public boolean createCoupon(Coupon coupon) {
        int rowsAffected = jdbcTemplate.update(CREATE_COUPON,
                coupon.getCode(),
                coupon.getDescription(),
                coupon.getDiscountPercent(),
                coupon.getMinPurchaseAmount(),
                Timestamp.valueOf(coupon.getStartDate()),
                Timestamp.valueOf(coupon.getEndDate()),
                coupon.isActive());
        return rowsAffected > 0;
    }

    public boolean updateCoupon(Coupon coupon) {
        int rowsAffected = jdbcTemplate.update(UPDATE_COUPON,
                coupon.getCode(),
                coupon.getDescription(),
                coupon.getDiscountPercent(),
                coupon.getMinPurchaseAmount(),
                Timestamp.valueOf(coupon.getStartDate()),
                Timestamp.valueOf(coupon.getEndDate()),
                coupon.isActive(),
                coupon.getCouponId());
        return rowsAffected > 0;
    }

    public boolean deleteCoupon(int couponId) {
        int rowsAffected = jdbcTemplate.update(DELETE_COUPON, couponId);
        return rowsAffected > 0;
    }
}