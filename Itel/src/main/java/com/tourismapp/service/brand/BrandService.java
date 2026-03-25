package com.tourismapp.service.brand;

import com.tourismapp.common.Status;
import com.tourismapp.repository.brand.BrandRepository;
import com.tourismapp.entity.Brand;
import com.tourismapp.entity.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class BrandService implements IBrandService {

    @Autowired
    private BrandRepository BrandRepository;

    @Override
    public List<Brand> getAllBrands() {
        return BrandRepository.getAllBrands();
    }

    @Override
    public Optional<Brand> findBrandById(int id) {
        return BrandRepository.findBrandById(id);
    }
    
    @Override
    public List<Brand> getActiveBrands() {
        return BrandRepository.getActiveBrands();
    }
    
    @Override
    public void createBrand(Brand brand) {
        validateBrandForCreate(brand);
        if (brand.getStatus() == null) {
            brand.setStatus(Status.ACTIVE);
        }
        BrandRepository.createBrand(brand);
    }

    @Override
    public Brand getBrandById(int brandId) {
        if (brandId <= 0) {
            throw new IllegalArgumentException("Invalid brand ID");
        }
        return BrandRepository.getBrandById(brandId);
    }

    @Override
    public List<Brand> findBrandsByName(String name) {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Search name cannot be empty");
        }
        return BrandRepository.findBrandsByName(name);
    }

    @Override
    public void updateBrand(Brand brand) {
        validateBrandForUpdate(brand);
        if (brand.getBrandId() <= 0) {
            throw new IllegalArgumentException("Invalid brand ID");
        }
        BrandRepository.updateBrand(brand);
    }

    @Override
    public void deleteBrand(int brandId) {
        if (brandId <= 0) {
            throw new IllegalArgumentException("Invalid brand ID");
        }
        BrandRepository.deleteBrand(brandId);
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
        return BrandRepository.findBrandsByCountry(country);
    }

    @Override
    public List<Product> getProductsByBrandId(int brandId) {
        return BrandRepository.getProductsByBrandId(brandId);
    }
}
