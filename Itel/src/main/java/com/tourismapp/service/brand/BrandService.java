package com.tourismapp.service.brand;

import com.tourismapp.common.Status;
import com.tourismapp.dao.brand.IBrandDAO;
import com.tourismapp.model.Brand;
import com.tourismapp.model.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class BrandService implements IBrandService {

    @Autowired
    private IBrandDAO brandDAO;

    @Override
    public List<Brand> getAllBrands() {
        return brandDAO.getAllBrands();
    }

    @Override
    public Optional<Brand> findBrandById(int id) {
        return brandDAO.findBrandById(id);
    }
    
    @Override
    public List<Brand> getActiveBrands() {
        return brandDAO.getActiveBrands();
    }
    
    @Override
    public void createBrand(Brand brand) {
        validateBrandForCreate(brand);
        if (brand.getStatus() == null) {
            brand.setStatus(Status.ACTIVE);
        }
        brandDAO.createBrand(brand);
    }

    @Override
    public Brand getBrandById(int brandId) {
        if (brandId <= 0) {
            throw new IllegalArgumentException("Invalid brand ID");
        }
        return brandDAO.getBrandById(brandId);
    }

    @Override
    public List<Brand> findBrandsByName(String name) {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Search name cannot be empty");
        }
        return brandDAO.findBrandsByName(name);
    }

    @Override
    public void updateBrand(Brand brand) {
        validateBrandForUpdate(brand);
        if (brand.getBrandId() <= 0) {
            throw new IllegalArgumentException("Invalid brand ID");
        }
        brandDAO.updateBrand(brand);
    }

    @Override
    public void deleteBrand(int brandId) {
        if (brandId <= 0) {
            throw new IllegalArgumentException("Invalid brand ID");
        }
        brandDAO.deleteBrand(brandId);
    }

    private void validateBrandForCreate(Brand brand) {
        if (brand.getName() == null || brand.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Brand name cannot be empty");
        }
        if (brand.getStatus() != null && brand.getStatus() != Status.ACTIVE && brand.getStatus() != Status.INACTIVE) {
            throw new IllegalArgumentException("Invalid status for brand: " + brand.getStatus() + ". Only ACTIVE or INACTIVE are allowed.");
        }
    }

    private void validateBrandForUpdate(Brand brand) {
        if (brand.getName() == null || brand.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Brand name cannot be empty");
        }
        if (brand.getStatus() == null) {
            throw new IllegalArgumentException("Brand status cannot be null for update");
        }
        if (brand.getStatus() != Status.ACTIVE && brand.getStatus() != Status.INACTIVE) {
            throw new IllegalArgumentException("Invalid status for brand: " + brand.getStatus() + ". Only ACTIVE or INACTIVE are allowed.");
        }
    }

    @Override
    public List<Brand> findBrandsByCountry(String country) {
        return brandDAO.findBrandsByCountry(country);
    }

    @Override
    public List<Product> getProductsByBrandId(int brandId) {
        return brandDAO.getProductsByBrandId(brandId);
    }
}
