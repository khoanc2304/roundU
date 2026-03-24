package com.tourismapp.repository.coupon;

import com.tourismapp.repository.DBConnection;
import com.tourismapp.model.Coupon;
import com.tourismapp.utils.ErrDialog;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Implementation for Coupon DAO
 */
public class CouponRepository {

    private static final String GET_ALL_COUPONS = "SELECT * FROM Coupon ORDER BY created_at DESC;";
    private static final String GET_ACTIVE_COUPONS = "SELECT * FROM Coupon WHERE is_active = 1 AND start_date <= GETDATE() AND end_date >= GETDATE() ORDER BY created_at DESC;";
    private static final String FIND_COUPON_BY_CODE = "SELECT * FROM Coupon WHERE code = ?;";
    private static final String CREATE_COUPON = "INSERT INTO Coupon (code, description, discount_percent, min_purchase_amount, start_date, end_date, is_active) VALUES (?, ?, ?, ?, ?, ?, ?);";
    private static final String UPDATE_COUPON = "UPDATE Coupon SET code = ?, description = ?, discount_percent = ?, min_purchase_amount = ?, start_date = ?, end_date = ?, is_active = ? WHERE coupon_id = ?;";
    private static final String DELETE_COUPON = "DELETE FROM Coupon WHERE coupon_id = ?;";

    public List<Coupon> getAllCoupons() {
        List<Coupon> coupons = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(GET_ALL_COUPONS);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                coupons.add(mapResultSetToCoupon(rs));
            }
        } catch (SQLException e) {
            ErrDialog.showError("Error retrieving coupons: " + e.getMessage());
        }

        return coupons;
    }

    public List<Coupon> getActiveCoupons() {
        List<Coupon> coupons = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(GET_ACTIVE_COUPONS);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                coupons.add(mapResultSetToCoupon(rs));
            }
        } catch (SQLException e) {
            ErrDialog.showError("Error retrieving active coupons: " + e.getMessage());
        }

        return coupons;
    }

    public Optional<Coupon> findCouponByCode(String code) {
        Coupon coupon = null;

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(FIND_COUPON_BY_CODE)) {

            stmt.setString(1, code);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    coupon = mapResultSetToCoupon(rs);
                }
            }
        } catch (SQLException e) {
            ErrDialog.showError("Error finding coupon by code: " + e.getMessage());
        }

        return Optional.ofNullable(coupon);
    }

    public boolean createCoupon(Coupon coupon) {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(CREATE_COUPON)) {

            stmt.setString(1, coupon.getCode());
            stmt.setString(2, coupon.getDescription());
            stmt.setBigDecimal(3, coupon.getDiscountPercent());
            stmt.setBigDecimal(4, coupon.getMinPurchaseAmount());
            stmt.setTimestamp(5, Timestamp.valueOf(coupon.getStartDate()));
            stmt.setTimestamp(6, Timestamp.valueOf(coupon.getEndDate()));
            stmt.setBoolean(7, coupon.isActive());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            ErrDialog.showError("Error creating coupon: " + e.getMessage());
            return false;
        }
    }

    public boolean updateCoupon(Coupon coupon) {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(UPDATE_COUPON)) {

            stmt.setString(1, coupon.getCode());
            stmt.setString(2, coupon.getDescription());
            stmt.setBigDecimal(3, coupon.getDiscountPercent());
            stmt.setBigDecimal(4, coupon.getMinPurchaseAmount());
            stmt.setTimestamp(5, Timestamp.valueOf(coupon.getStartDate()));
            stmt.setTimestamp(6, Timestamp.valueOf(coupon.getEndDate()));
            stmt.setBoolean(7, coupon.isActive());
            stmt.setInt(8, coupon.getCouponId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            ErrDialog.showError("Error updating coupon: " + e.getMessage());
            return false;
        }
    }

    public boolean deleteCoupon(int couponId) {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(DELETE_COUPON)) {

            stmt.setInt(1, couponId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            ErrDialog.showError("Error deleting coupon: " + e.getMessage());
            return false;
        }
    }

    private Coupon mapResultSetToCoupon(ResultSet rs) throws SQLException {
        return new Coupon(
                rs.getInt("coupon_id"),
                rs.getString("code"),
                rs.getString("description"),
                rs.getBigDecimal("discount_percent"),
                rs.getBigDecimal("min_purchase_amount"),
                rs.getTimestamp("start_date").toLocalDateTime(),
                rs.getTimestamp("end_date").toLocalDateTime(),
                rs.getBoolean("is_active"),
                rs.getTimestamp("created_at").toLocalDateTime());
    }
}