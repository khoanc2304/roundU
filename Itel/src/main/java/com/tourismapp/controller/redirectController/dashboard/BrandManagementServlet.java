package com.tourismapp.controller.redirectController.dashboard;

import com.tourismapp.common.Status;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;
import com.tourismapp.model.Brand;
import com.tourismapp.service.brand.BrandService;
import com.tourismapp.service.brand.IBrandService;
import com.tourismapp.utils.ErrDialog;
import java.util.List;
import com.tourismapp.model.Product;

/**
 *
 * @author LENOVO
 */
@WebServlet(name = "BrandManagementServlet", urlPatterns = {MainControllerServlet.BRAND_MANAGEMENT_SERVLET})
public class BrandManagementServlet extends HttpServlet {

    private IBrandService brandService;

    @Override
    public void init() throws ServletException {
        brandService = new BrandService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
//        ErrDialog.showError("brand management action: " + action);
        switch (action) {
//            case MainControllerServlet.BRAND_MANAGEMENT_REDIRECT:
//                handleManageBrand(request, response);
//                break;
            case MainControllerServlet.ACTION_MANAGE_BRAND:
                handleManageBrand(request, response);
                break;
            case MainControllerServlet.ACTION_FIND_BRAND:
                handleFindBrand(request, response);
                break;
            case MainControllerServlet.ACTION_NAVIGATE_TO_CREATE_BRAND:
                handleNavigateToCreateBrand(request, response);
                break;
            case MainControllerServlet.ACTION_NAVIGATE_TO_UPDATE_BRAND:
                handleNavigateToUpdateBrand(request, response);
                break;
            default:
                handleManageBrandAction(request, response);
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action") != null ? request.getParameter("action").trim() : "";
//        ErrDialog.showError("brand management action error: " + action);
        switch (action) {
            case MainControllerServlet.ACTION_CREATE_BRAND:
                handleCreateBrand(request, response);
                break;
            case MainControllerServlet.ACTION_EDIT_BRAND:
                handleEditBrand(request, response);
                break;
            case MainControllerServlet.ACTION_DELETE_BRAND:
                handleDeleteBrand(request, response);
                break;
            default:
                handleManageBrand(request, response);
        }

    }

    // <editor-fold defaultstate="collapsed" desc=" functional ... ">
    // doGet methods
    private void handleManageBrandAction(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        ErrDialog.showError("Entering handleManageBrandAction");
        List<Brand> brandList = brandService.getAllBrands();
        for (Brand brand : brandList) {
            brand.setProductList(brandService.getProductsByBrandId(brand.getBrandId()));
        }
        request.setAttribute("brands", brandList);
        request.getRequestDispatcher(ProjectPaths.JSP_MANAGEBRAND_PATH).forward(request, response);
    }

    private void handleManageBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String country = request.getParameter("country");
        List<Brand> brandList;
        if (country != null && !country.isEmpty()) {
            brandList = brandService.findBrandsByCountry(country);
        } else {
            brandList = brandService.getAllBrands();
        }
//        ErrDialog.showError("size brand list: " + brandList.size());
        request.setAttribute("brands", brandList);
        request.getRequestDispatcher(ProjectPaths.JSP_BRANDMANAGEMENT_PATH).forward(request, response);
    }

    private void handleFindBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String searchName = request.getParameter("searchName");
            
            // Validation
            if (searchName == null || searchName.trim().isEmpty()) {
                request.setAttribute("error", "Search name cannot be empty");
                // Load all brands when search is empty
                List<Brand> allBrands = brandService.getAllBrands();
                request.setAttribute("brands", allBrands);
                request.getRequestDispatcher(ProjectPaths.JSP_BRANDMANAGEMENT_PATH).forward(request, response);
                return;
            }
            
            if (searchName.trim().length() < 2) {
                request.setAttribute("error", "Search name must be at least 2 characters");
                List<Brand> allBrands = brandService.getAllBrands();
                request.setAttribute("brands", allBrands);
                request.getRequestDispatcher(ProjectPaths.JSP_BRANDMANAGEMENT_PATH).forward(request, response);
                return;
            }
            
            if (searchName.trim().length() > 50) {
                request.setAttribute("error", "Search name cannot exceed 50 characters");
                List<Brand> allBrands = brandService.getAllBrands();
                request.setAttribute("brands", allBrands);
                request.getRequestDispatcher(ProjectPaths.JSP_BRANDMANAGEMENT_PATH).forward(request, response);
                return;
            }
            
            List<Brand> brands = brandService.findBrandsByName(searchName.trim());
            request.setAttribute("brands", brands);
            request.setAttribute("searchTerm", searchName.trim());
            
            if (brands.isEmpty()) {
                request.setAttribute("info", "No brands found matching '" + searchName.trim() + "'");
            }
            
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            List<Brand> allBrands = brandService.getAllBrands();
            request.setAttribute("brands", allBrands);
        } catch (Exception e) {
            request.setAttribute("error", "Error searching brands: " + e.getMessage());
            List<Brand> allBrands = brandService.getAllBrands();
            request.setAttribute("brands", allBrands);
        }
        
        request.getRequestDispatcher(ProjectPaths.JSP_BRANDMANAGEMENT_PATH).forward(request, response);
    }

    // doPost methods
    private void handleCreateBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Validate input parameters
            String name = request.getParameter("name");
            String country = request.getParameter("country");
            String description = request.getParameter("description");
            String imageUrl = request.getParameter("imageUrl");
            String statusParam = request.getParameter("status");
            
            // Validation for required fields - ALL FIELDS ARE REQUIRED
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("error", "Brand name is required");
                request.getRequestDispatcher(ProjectPaths.JSP_CREATEBRAND_PATH).forward(request, response);
                return;
            }
            
            if (name.trim().length() > 100) {
                request.setAttribute("error", "Brand name cannot exceed 100 characters");
                request.getRequestDispatcher(ProjectPaths.JSP_CREATEBRAND_PATH).forward(request, response);
                return;
            }
            
            // Country is required
            if (country == null || country.trim().isEmpty()) {
                request.setAttribute("error", "Country is required");
                request.getRequestDispatcher(ProjectPaths.JSP_CREATEBRAND_PATH).forward(request, response);
                return;
            }
            
            if (country.trim().length() > 50) {
                request.setAttribute("error", "Country name cannot exceed 50 characters");
                request.getRequestDispatcher(ProjectPaths.JSP_CREATEBRAND_PATH).forward(request, response);
                return;
            }
            
            // Description is required
            if (description == null || description.trim().isEmpty()) {
                request.setAttribute("error", "Description is required");
                request.getRequestDispatcher(ProjectPaths.JSP_CREATEBRAND_PATH).forward(request, response);
                return;
            }
            
            if (description.trim().length() > 500) {
                request.setAttribute("error", "Description cannot exceed 500 characters");
                request.getRequestDispatcher(ProjectPaths.JSP_CREATEBRAND_PATH).forward(request, response);
                return;
            }
            
            // Image URL is required
            if (imageUrl == null || imageUrl.trim().isEmpty()) {
                request.setAttribute("error", "Image URL is required");
                request.getRequestDispatcher(ProjectPaths.JSP_CREATEBRAND_PATH).forward(request, response);
                return;
            }
            
            if (!isValidUrl(imageUrl.trim())) {
                request.setAttribute("error", "Please enter a valid image URL");
                request.getRequestDispatcher(ProjectPaths.JSP_CREATEBRAND_PATH).forward(request, response);
                return;
            }
            
            // Validate status is required
            if (statusParam == null || statusParam.trim().isEmpty()) {
                request.setAttribute("error", "Status is required");
                request.getRequestDispatcher(ProjectPaths.JSP_CREATEBRAND_PATH).forward(request, response);
                return;
            }
            
            // Validate status value
            Status status;
            try {
                status = Status.valueOf(statusParam.trim());
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", "Invalid status value. Please select ACTIVE or INACTIVE");
                request.getRequestDispatcher(ProjectPaths.JSP_CREATEBRAND_PATH).forward(request, response);
                return;
            }
            
            Brand brand = new Brand(
                0,
                name.trim(),
                country.trim(),
                description.trim(),
                imageUrl.trim(),
                status
            );
            
            brandService.createBrand(brand);
            request.setAttribute("successMessage", "Brand created successfully!");
            response.sendRedirect(request.getContextPath() + "/main?action=" + MainControllerServlet.BRAND_MANAGEMENT_REDIRECT);
            
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher(ProjectPaths.JSP_CREATEBRAND_PATH).forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error creating brand: " + e.getMessage());
            request.getRequestDispatcher(ProjectPaths.JSP_CREATEBRAND_PATH).forward(request, response);
        }
    }
    
    // Helper method to validate URL format
    private boolean isValidUrl(String url) {
        try {
            new java.net.URL(url);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    private void handleEditBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Validate brandId
            String brandIdParam = request.getParameter("brandId");
            if (brandIdParam == null || brandIdParam.trim().isEmpty()) {
                request.setAttribute("error", "Brand ID is required");
                request.getRequestDispatcher(ProjectPaths.JSP_BRANDMANAGEMENT_PATH).forward(request, response);
                return;
            }
            
            int brandId;
            try {
                brandId = Integer.parseInt(brandIdParam);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid brand ID format");
                request.getRequestDispatcher(ProjectPaths.JSP_BRANDMANAGEMENT_PATH).forward(request, response);
                return;
            }
            
            // Validate input parameters
            String name = request.getParameter("name");
            String country = request.getParameter("country");
            String description = request.getParameter("description");
            String imageUrl = request.getParameter("imageUrl");
            String statusParam = request.getParameter("status");
            
            // Validation - ALL FIELDS ARE REQUIRED
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("error", "Brand name is required");
                // Get brand data to repopulate form
                Brand brand = brandService.getBrandById(brandId);
                if (brand != null) {
                    request.setAttribute("brand", brand);
                }
                request.getRequestDispatcher(ProjectPaths.JSP_UPDATEBRAND_PATH).forward(request, response);
                return;
            }
            
            if (name.trim().length() > 100) {
                request.setAttribute("error", "Brand name cannot exceed 100 characters");
                Brand brand = brandService.getBrandById(brandId);
                if (brand != null) {
                    request.setAttribute("brand", brand);
                }
                request.getRequestDispatcher(ProjectPaths.JSP_UPDATEBRAND_PATH).forward(request, response);
                return;
            }
            
            // Country is required
            if (country == null || country.trim().isEmpty()) {
                request.setAttribute("error", "Country is required");
                Brand brand = brandService.getBrandById(brandId);
                if (brand != null) {
                    request.setAttribute("brand", brand);
                }
                request.getRequestDispatcher(ProjectPaths.JSP_UPDATEBRAND_PATH).forward(request, response);
                return;
            }
            
            if (country.trim().length() > 50) {
                request.setAttribute("error", "Country name cannot exceed 50 characters");
                Brand brand = brandService.getBrandById(brandId);
                if (brand != null) {
                    request.setAttribute("brand", brand);
                }
                request.getRequestDispatcher(ProjectPaths.JSP_UPDATEBRAND_PATH).forward(request, response);
                return;
            }
            
            // Description is required
            if (description == null || description.trim().isEmpty()) {
                request.setAttribute("error", "Description is required");
                Brand brand = brandService.getBrandById(brandId);
                if (brand != null) {
                    request.setAttribute("brand", brand);
                }
                request.getRequestDispatcher(ProjectPaths.JSP_UPDATEBRAND_PATH).forward(request, response);
                return;
            }
            
            if (description.trim().length() > 500) {
                request.setAttribute("error", "Description cannot exceed 500 characters");
                Brand brand = brandService.getBrandById(brandId);
                if (brand != null) {
                    request.setAttribute("brand", brand);
                }
                request.getRequestDispatcher(ProjectPaths.JSP_UPDATEBRAND_PATH).forward(request, response);
                return;
            }
            
            // Image URL is required
            if (imageUrl == null || imageUrl.trim().isEmpty()) {
                request.setAttribute("error", "Image URL is required");
                Brand brand = brandService.getBrandById(brandId);
                if (brand != null) {
                    request.setAttribute("brand", brand);
                }
                request.getRequestDispatcher(ProjectPaths.JSP_UPDATEBRAND_PATH).forward(request, response);
                return;
            }
            
            if (!isValidUrl(imageUrl.trim())) {
                request.setAttribute("error", "Please enter a valid image URL");
                Brand brand = brandService.getBrandById(brandId);
                if (brand != null) {
                    request.setAttribute("brand", brand);
                }
                request.getRequestDispatcher(ProjectPaths.JSP_UPDATEBRAND_PATH).forward(request, response);
                return;
            }
            
            // Validate status is required
            if (statusParam == null || statusParam.isEmpty()) {
                request.setAttribute("error", "Status is required");
                Brand brand = brandService.getBrandById(brandId);
                if (brand != null) {
                    request.setAttribute("brand", brand);
                }
                request.getRequestDispatcher(ProjectPaths.JSP_UPDATEBRAND_PATH).forward(request, response);
                return;
            }
            
            // Validate status value
            Status status;
            try {
                status = Status.valueOf(statusParam);
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", "Invalid status value");
                Brand brand = brandService.getBrandById(brandId);
                if (brand != null) {
                    request.setAttribute("brand", brand);
                }
                request.getRequestDispatcher(ProjectPaths.JSP_UPDATEBRAND_PATH).forward(request, response);
                return;
            }
            
            Brand brandUpdate = new Brand(
                brandId,
                name.trim(),
                country.trim(),
                description.trim(),
                imageUrl.trim(),
                status
            );
            
            brandService.updateBrand(brandUpdate);
            request.setAttribute("successMessage", "Brand updated successfully!");
            response.sendRedirect(request.getContextPath() + "/main?action=" + MainControllerServlet.BRAND_MANAGEMENT_REDIRECT);
            
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher(ProjectPaths.JSP_BRANDMANAGEMENT_PATH).forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error updating brand: " + e.getMessage());
            request.getRequestDispatcher(ProjectPaths.JSP_BRANDMANAGEMENT_PATH).forward(request, response);
        }
    }

    private void handleDeleteBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String brandIdParam = request.getParameter("brandId");
            if (brandIdParam == null || brandIdParam.trim().isEmpty()) {
                request.setAttribute("error", "Brand ID is required");
                request.getRequestDispatcher(ProjectPaths.JSP_BRANDMANAGEMENT_PATH).forward(request, response);
                return;
            }
            
            int brandId;
            try {
                brandId = Integer.parseInt(brandIdParam);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid brand ID format");
                request.getRequestDispatcher(ProjectPaths.JSP_BRANDMANAGEMENT_PATH).forward(request, response);
                return;
            }
            
            // Check if brand exists
            Brand existingBrand = brandService.getBrandById(brandId);
            if (existingBrand == null) {
                request.setAttribute("error", "Brand not found");
                request.getRequestDispatcher(ProjectPaths.JSP_BRANDMANAGEMENT_PATH).forward(request, response);
                return;
            }
            
            // Check if brand has associated products
            List<Product> products = brandService.getProductsByBrandId(brandId);
            if (!products.isEmpty()) {
                request.setAttribute("error", "Cannot delete brand. It has " + products.size() + " associated product(s)");
                request.getRequestDispatcher(ProjectPaths.JSP_BRANDMANAGEMENT_PATH).forward(request, response);
                return;
            }
            
            brandService.deleteBrand(brandId);
            request.setAttribute("successMessage", "Brand deleted successfully!");
            response.sendRedirect(request.getContextPath() + "/main?action=" + MainControllerServlet.BRAND_MANAGEMENT_REDIRECT);
            
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher(ProjectPaths.JSP_BRANDMANAGEMENT_PATH).forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error deleting brand: " + e.getMessage());
            request.getRequestDispatcher(ProjectPaths.JSP_BRANDMANAGEMENT_PATH).forward(request, response);
        }
    }

    private void handleNavigateToCreateBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        ErrDialog.showError("Navigating to create brand with action: " + request.getParameter("action"));
        request.getRequestDispatcher(ProjectPaths.JSP_CREATEBRAND_PATH).forward(request, response);
    }

    private void handleNavigateToUpdateBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String brandIdParam = request.getParameter("brandId");
            if (brandIdParam == null || brandIdParam.trim().isEmpty()) {
                request.setAttribute("error", "Brand ID is required");
                request.getRequestDispatcher(ProjectPaths.JSP_BRANDMANAGEMENT_PATH).forward(request, response);
                return;
            }
            
            int brandId;
            try {
                brandId = Integer.parseInt(brandIdParam);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid brand ID format");
                request.getRequestDispatcher(ProjectPaths.JSP_BRANDMANAGEMENT_PATH).forward(request, response);
                return;
            }
            
            if (brandId <= 0) {
                request.setAttribute("error", "Invalid brand ID");
                request.getRequestDispatcher(ProjectPaths.JSP_BRANDMANAGEMENT_PATH).forward(request, response);
                return;
            }
            
            Brand brand = brandService.getBrandById(brandId);
            if (brand == null) {
                request.setAttribute("error", "Brand not found with ID: " + brandId);
                request.getRequestDispatcher(ProjectPaths.JSP_BRANDMANAGEMENT_PATH).forward(request, response);
                return;
            }
            
            request.setAttribute("brand", brand);
            request.getRequestDispatcher(ProjectPaths.JSP_UPDATEBRAND_PATH).forward(request, response);
            
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher(ProjectPaths.JSP_BRANDMANAGEMENT_PATH).forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error retrieving brand: " + e.getMessage());
            request.getRequestDispatcher(ProjectPaths.JSP_BRANDMANAGEMENT_PATH).forward(request, response);
        }
    }

    // </editor-fold>
}
