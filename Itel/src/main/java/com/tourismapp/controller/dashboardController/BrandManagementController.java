package com.tourismapp.controller.dashboardController;

import com.tourismapp.common.Status;
import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;
import com.tourismapp.model.Brand;
import com.tourismapp.model.Product;
import com.tourismapp.service.brand.BrandService;
import com.tourismapp.service.brand.IBrandService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping(MainControllerServlet.BRAND_MANAGEMENT_SERVLET)
public class BrandManagementController {

    private final IBrandService brandService = new BrandService();

    @GetMapping
    public String handleGet(@RequestParam(value = "action", required = false, defaultValue = "") String action,
                            @RequestParam(value = "country", required = false) String country,
                            @RequestParam(value = "searchName", required = false) String searchName,
                            @RequestParam(value = "brandId", required = false) Integer brandId,
                            HttpServletRequest request) {

        switch (action) {
            case MainControllerServlet.ACTION_MANAGE_BRAND:
                List<Brand> brandList;
                if (country != null && !country.isEmpty()) {
                    brandList = brandService.findBrandsByCountry(country);
                } else {
                    brandList = brandService.getAllBrands();
                }
                request.setAttribute("brands", brandList);
                return ProjectPaths.JSP_BRANDMANAGEMENT_PATH;

            case MainControllerServlet.ACTION_FIND_BRAND:
                if (searchName == null || searchName.trim().isEmpty() || searchName.trim().length() < 2 || searchName.trim().length() > 50) {
                    request.setAttribute("error", "Tên tìm kiếm không hợp lệ (2-50 ký tự)");
                    request.setAttribute("brands", brandService.getAllBrands());
                    return ProjectPaths.JSP_BRANDMANAGEMENT_PATH;
                }
                List<Brand> brands = brandService.findBrandsByName(searchName.trim());
                request.setAttribute("brands", brands);
                request.setAttribute("searchTerm", searchName.trim());
                if (brands.isEmpty()) {
                    request.setAttribute("info", "Không tìm thấy thương hiệu '" + searchName.trim() + "'");
                }
                return ProjectPaths.JSP_BRANDMANAGEMENT_PATH;

            case MainControllerServlet.ACTION_NAVIGATE_TO_CREATE_BRAND:
                return ProjectPaths.JSP_CREATEBRAND_PATH;

            case MainControllerServlet.ACTION_NAVIGATE_TO_UPDATE_BRAND:
                if (brandId == null || brandId <= 0) {
                    request.setAttribute("error", "Brand ID không hợp lệ");
                    return ProjectPaths.JSP_BRANDMANAGEMENT_PATH;
                }
                Brand brand = brandService.getBrandById(brandId);
                if (brand == null) {
                    request.setAttribute("error", "Không tìm thấy thương hiệu id " + brandId);
                    return ProjectPaths.JSP_BRANDMANAGEMENT_PATH;
                }
                request.setAttribute("brand", brand);
                return ProjectPaths.JSP_UPDATEBRAND_PATH;

            default:
                List<Brand> allBrands = brandService.getAllBrands();
                for (Brand b : allBrands) {
                    b.setProductList(brandService.getProductsByBrandId(b.getBrandId()));
                }
                request.setAttribute("brands", allBrands);
                return ProjectPaths.JSP_MANAGEBRAND_PATH;
        }
    }

    @PostMapping
    public String handlePost(@RequestParam(value = "action", required = false, defaultValue = "") String action,
                             @RequestParam(value = "brandId", required = false) Integer brandId,
                             @RequestParam(value = "name", required = false) String name,
                             @RequestParam(value = "country", required = false) String country,
                             @RequestParam(value = "description", required = false) String description,
                             @RequestParam(value = "imageUrl", required = false) String imageUrl,
                             @RequestParam(value = "status", required = false) String statusParam,
                             HttpServletRequest request) {

        try {
            switch (action) {
                case MainControllerServlet.ACTION_CREATE_BRAND:
                    return handleCreate(name, country, description, imageUrl, statusParam, request);
                case MainControllerServlet.ACTION_EDIT_BRAND:
                    return handleUpdate(brandId, name, country, description, imageUrl, statusParam, request);
                case MainControllerServlet.ACTION_DELETE_BRAND:
                    return handleDelete(brandId, request);
                default:
                    return "redirect:" + ProjectPaths.HREF_TO_BRANDMANAGEMENT.substring(ProjectPaths.PREFIX_WEB_PATH.length());
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            return ProjectPaths.JSP_BRANDMANAGEMENT_PATH;
        }
    }

    private String handleCreate(String name, String country, String description, String imageUrl, String statusParam, HttpServletRequest request) {
        if (name == null || name.trim().isEmpty() || country == null || country.trim().isEmpty() ||
            description == null || description.trim().isEmpty() || imageUrl == null || imageUrl.trim().isEmpty() || statusParam == null || statusParam.trim().isEmpty()) {
            request.setAttribute("error", "Tất cả các trường đều bắt buộc");
            return ProjectPaths.JSP_CREATEBRAND_PATH;
        }
        try {
            Status status = Status.valueOf(statusParam.trim());
            Brand brand = new Brand(0, name.trim(), country.trim(), description.trim(), imageUrl.trim(), status);
            brandService.createBrand(brand);
            request.setAttribute("successMessage", "Tạo thương hiệu thành công!");
            return "redirect:/main?action=" + MainControllerServlet.BRAND_MANAGEMENT_REDIRECT;
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi tạo thương hiệu: " + e.getMessage());
            return ProjectPaths.JSP_CREATEBRAND_PATH;
        }
    }

    private String handleUpdate(Integer brandId, String name, String country, String description, String imageUrl, String statusParam, HttpServletRequest request) {
        if (brandId == null || name == null || name.trim().isEmpty() || country == null || country.trim().isEmpty() ||
            description == null || description.trim().isEmpty() || imageUrl == null || imageUrl.trim().isEmpty() || statusParam == null || statusParam.trim().isEmpty()) {
            request.setAttribute("error", "Tất cả các trường đều bắt buộc");
            if (brandId != null) request.setAttribute("brand", brandService.getBrandById(brandId));
            return ProjectPaths.JSP_UPDATEBRAND_PATH;
        }
        try {
            Status status = Status.valueOf(statusParam.trim());
            Brand brand = new Brand(brandId, name.trim(), country.trim(), description.trim(), imageUrl.trim(), status);
            brandService.updateBrand(brand);
            request.setAttribute("successMessage", "Cập nhật thương hiệu thành công!");
            return "redirect:/main?action=" + MainControllerServlet.BRAND_MANAGEMENT_REDIRECT;
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi cập nhật: " + e.getMessage());
            request.setAttribute("brand", brandService.getBrandById(brandId));
            return ProjectPaths.JSP_UPDATEBRAND_PATH;
        }
    }

    private String handleDelete(Integer brandId, HttpServletRequest request) {
        if (brandId == null) {
            request.setAttribute("error", "Brand ID bắt buộc");
            return ProjectPaths.JSP_BRANDMANAGEMENT_PATH;
        }
        Brand existingBrand = brandService.getBrandById(brandId);
        if (existingBrand == null) {
            request.setAttribute("error", "Không tìm thấy thương hiệu");
            return ProjectPaths.JSP_BRANDMANAGEMENT_PATH;
        }
        List<Product> products = brandService.getProductsByBrandId(brandId);
        if (!products.isEmpty()) {
            request.setAttribute("error", "Không thể xóa thương hiệu này vì đang có " + products.size() + " sản phẩm.");
            return ProjectPaths.JSP_BRANDMANAGEMENT_PATH;
        }
        brandService.deleteBrand(brandId);
        request.setAttribute("successMessage", "Xóa thương hiệu thành công!");
        return "redirect:/main?action=" + MainControllerServlet.BRAND_MANAGEMENT_REDIRECT;
    }
}
