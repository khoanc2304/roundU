/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.dao.brand;

import com.tourismapp.common.Status;
import com.tourismapp.dao.DBConnection;
import com.tourismapp.dao.category.CategoryDAO;
import com.tourismapp.model.Brand;
import com.tourismapp.model.Category;
import com.tourismapp.utils.ErrDialog;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 *
 * @author Admin
 */
public class BrandDAO implements IBrandDAO {

    private static final String GET_ALL_BRANDS = "SELECT * FROM Brand;";
    private static final String FIND_BRAND_BY_ID = "SELECT * FROM Brand WHERE brand_id = ?";

    @Override
    public Brand mapBrand(ResultSet rs) throws SQLException {
        return new Brand(
                rs.getInt("brand_id"),
                rs.getString("name"),
                rs.getString("country"),
                rs.getString("description"),
                rs.getString("image_url"),
                Status.valueOf(rs.getString("status").toUpperCase())
        );
    }

    @Override
    public List<Brand> getAllBrands() {
        List<Brand> brands = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(GET_ALL_BRANDS); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Brand brand = mapBrand(rs);
                brands.add(brand);
            }
//            ErrDialog.showError("size active products: " + activeProducts.size());
        } catch (SQLException e) {
            ErrDialog.showError("Lỗi khi truy vấn sản phẩm: " + e.getMessage());
//            e.printStackTrace(); 
        }
        return brands;
    }

    @Override
    public Optional<Brand> findBrandById(int brandId) {
        Brand brand = null;
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(FIND_BRAND_BY_ID)) {

            ps.setInt(1, brandId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return Optional.of(mapBrand(rs));
            }
        } catch (SQLException e) {
            ErrDialog.showError("PBrandDAO findBrandById getId fail");
        }
        return Optional.empty();
    }

    public static void main(String[] args) {
        BrandDAO bDAO = new BrandDAO();
        Optional<Brand> brand = bDAO.findBrandById(1);
          ErrDialog.showError("Bradn : " + brand.get() );
    }

}
