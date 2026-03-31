package com.tourismapp.controller.dashboardController;

import com.tourismapp.config.ProjectPaths;
import com.tourismapp.entity.Brand;
import com.tourismapp.service.brand.IBrandService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import com.tourismapp.annotation.RequiresRole;
import com.tourismapp.common.UserRole;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Optional;

@RequiresRole({UserRole.ADMIN, UserRole.STAFF})
@Controller
@RequestMapping("/admin/brands")
public class BrandManagementController {

    @Autowired
    private IBrandService brandService;

    @GetMapping
    public String listBrands(@RequestParam(value = "qBrand", required = false) String qBrand,
                             HttpServletRequest request, HttpSession session) {
        if (qBrand != null && !qBrand.trim().isEmpty()) {
            request.setAttribute("brands", brandService.findBrandsByName(qBrand));
            return ProjectPaths.JSP_BRANDMANAGEMENT_PATH;
        }
        request.setAttribute("brands", brandService.getAllBrands());
        return ProjectPaths.JSP_BRANDMANAGEMENT_PATH;
    }

    @GetMapping("/create")
    public String createBrandForm(HttpServletRequest request) {
        return ProjectPaths.JSP_PATH_DASHBOARD + "brandManagement/createBrand.jsp";
    }

    @GetMapping("/{id}/edit")
    public String editBrandForm(@PathVariable("id") Integer id, HttpServletRequest request, HttpSession session) {
        if (id == null) {
            session.setAttribute("toastMessage", "ID thương hiệu không hợp lệ.");
            return "redirect:/admin/brands";
        }
        Optional<Brand> brand = brandService.findBrandById(id);
        if (brand.isPresent()) {
            request.setAttribute("brand", brand.get());
            request.setAttribute("updateBrand", "active");
            return ProjectPaths.JSP_PATH_DASHBOARD + "brandManagement/updateBrand.jsp";
        } else {
            session.setAttribute("toastMessage", "Không tìm thấy thương hiệu.");
            return "redirect:/admin/brands";
        }
    }

    @PostMapping("/create")
    public String createBrand(@RequestParam("name") String name,
                              @RequestParam("imageUrl") String imageUrl,
                              HttpServletRequest request, HttpSession session) {
        try {
            if (name == null || name.trim().isEmpty() || imageUrl == null || imageUrl.trim().isEmpty()) {
                session.setAttribute("toastMessage", "Tên và hình ảnh thương hiệu không được để trống.");
                request.setAttribute("name", name);
                request.setAttribute("imageUrl", imageUrl);
                return ProjectPaths.JSP_PATH_DASHBOARD + "brandManagement/createBrand.jsp";
            }
            if (name.length() > 255 || imageUrl.length() > 255) {
                session.setAttribute("toastMessage", "Dữ liệu nhập vào quá dài, vui lòng kiểm tra lại.");
                request.setAttribute("name", name);
                request.setAttribute("imageUrl", imageUrl);
                return ProjectPaths.JSP_PATH_DASHBOARD + "brandManagement/createBrand.jsp";
            }
            Brand brand = new Brand();
            brand.setName(name);
            brand.setImageUrl(imageUrl);
            try {
                brandService.createBrand(brand);
                session.setAttribute("toastMessage", "Thêm thương hiệu thành công.");
                return "redirect:/admin/brands";
            } catch (Exception ex) {
                session.setAttribute("toastMessage", "Thêm thương hiệu thất bại.");
                request.setAttribute("name", name);
                request.setAttribute("imageUrl", imageUrl);
                return ProjectPaths.JSP_PATH_DASHBOARD + "brandManagement/createBrand.jsp";
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("toastMessage", "Có lỗi xảy ra: " + e.getMessage());
            return "redirect:/admin/brands";
        }
    }

    @PostMapping("/{id}/edit")
    public String updateBrand(@PathVariable("id") Integer id,
                              @RequestParam("name") String name,
                              @RequestParam("imageUrl") String imageUrl,
                              HttpServletRequest request, HttpSession session) {
        try {
            if (id == null || name == null || name.trim().isEmpty() || imageUrl == null || imageUrl.trim().isEmpty()) {
                session.setAttribute("toastMessage", "Thông tin cập nhật không được để trống.");
                return "redirect:/admin/brands/" + id + "/edit";
            }
            if (name.length() > 255 || imageUrl.length() > 255) {
                session.setAttribute("toastMessage", "Dữ liệu cập nhật quá dài.");
                return "redirect:/admin/brands/" + id + "/edit";
            }
            Optional<Brand> existing = brandService.findBrandById(id);
            if (!existing.isPresent()) {
                session.setAttribute("toastMessage", "Thương hiệu không tồn tại.");
                return "redirect:/admin/brands";
            }

            try {
                Brand brandToUpdate = existing.get();
                brandToUpdate.setName(name);
                brandToUpdate.setImageUrl(imageUrl);
                brandService.updateBrand(brandToUpdate);
                session.setAttribute("toastMessage", "Cập nhật thương hiệu thành công.");
                return "redirect:/admin/brands";
            } catch (Exception ex) {
                session.setAttribute("toastMessage", "Cập nhật thương hiệu thất bại.");
                return "redirect:/admin/brands/" + id + "/edit";
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("toastMessage", "Lỗi trong quá trình cập nhật: " + e.getMessage());
            return "redirect:/admin/brands";
        }
    }

    @PostMapping("/{id}/delete")
    public String deleteBrand(@PathVariable("id") Integer id, HttpSession session) {
        if (id == null) {
            session.setAttribute("toastMessage", "Bắt buộc chọn thương hiệu để xóa.");
            return "redirect:/admin/brands";
        }
        try {
            brandService.deleteBrand(id);
            session.setAttribute("toastMessage", "Xóa thương hiệu thành công.");
        } catch (Exception ex) {
            session.setAttribute("toastMessage", "Xóa thương hiệu thất bại.");
        }
        return "redirect:/admin/brands";
    }
}
