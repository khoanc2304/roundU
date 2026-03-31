package com.tourismapp.controller.dashboardController;

import com.tourismapp.config.ProjectPaths;
import com.tourismapp.entity.Category;
import com.tourismapp.service.category.ICategoryService;
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
@RequestMapping("/admin/categories")
public class CategoryManagementController {

    @Autowired
    private ICategoryService categoryService;

    @GetMapping
    public String listCategories(@RequestParam(value = "qCategory", required = false) String qCategory,
                                 HttpServletRequest request, HttpSession session) {
        if (qCategory != null && !qCategory.trim().isEmpty()) {
            request.setAttribute("categories", categoryService.searchCategoriesByName(qCategory));
            return ProjectPaths.JSP_CATEGORYMANAGEMENT_PATH;
        }
        request.setAttribute("categories", categoryService.getAllCategories());
        return ProjectPaths.JSP_CATEGORYMANAGEMENT_PATH;
    }

    @GetMapping("/create")
    public String createCategoryForm(HttpServletRequest request) {
        return ProjectPaths.JSP_PATH_DASHBOARD + "categoryManagement/createCategory.jsp";
    }

    @GetMapping("/{id}/edit")
    public String editCategoryForm(@PathVariable("id") Integer id, HttpServletRequest request, HttpSession session) {
        if (id == null) {
            session.setAttribute("errorMessage", "Tham số Id danh mục không hợp lệ.");
            return "redirect:/admin/categories";
        }
        Optional<Category> category = categoryService.findCategoryById(id);
        if (category.isPresent()) {
            request.setAttribute("category", category.get());
            request.setAttribute("updateCategory", "active");
            return ProjectPaths.JSP_PATH_DASHBOARD + "categoryManagement/updateCategory.jsp";
        } else {
            session.setAttribute("toastMessage", "Danh mục không tồn tại.");
            return "redirect:/admin/categories";
        }
    }

    @PostMapping("/create")
    public String createCategory(@RequestParam("name") String name,
                                 @RequestParam("imageUrl") String imageUrl,
                                 HttpServletRequest request, HttpSession session) {
        try {
            if (name == null || name.trim().isEmpty() || imageUrl == null || imageUrl.trim().isEmpty()) {
                session.setAttribute("toastMessage", "Vui lòng nhập đầy đủ tên và đường dẫn ảnh.");
                request.setAttribute("name", name);
                request.setAttribute("imageUrl", imageUrl);
                return ProjectPaths.JSP_PATH_DASHBOARD + "categoryManagement/createCategory.jsp";
            }
            if (name.length() > 255 || imageUrl.length() > 255) {
                session.setAttribute("toastMessage", "Tên hoặc đường dẫn ảnh không được vượt quá 255 ký tự.");
                request.setAttribute("name", name);
                request.setAttribute("imageUrl", imageUrl);
                return ProjectPaths.JSP_PATH_DASHBOARD + "categoryManagement/createCategory.jsp";
            }
            Category category = new Category();
            category.setName(name);
            category.setImageUrl(imageUrl);
            try {
                categoryService.createCategory(category);
                session.setAttribute("toastMessage", "Thêm mới danh mục thành công.");
                return "redirect:/admin/categories";
            } catch (Exception ex) {
                session.setAttribute("toastMessage", "Đã xảy ra lỗi hệ thống, không thể thêm danh mục.");
                request.setAttribute("name", name);
                request.setAttribute("imageUrl", imageUrl);
                return ProjectPaths.JSP_PATH_DASHBOARD + "categoryManagement/createCategory.jsp";
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("toastMessage", "Cập nhật thất bại. Lỗi: " + e.getMessage());
            return "redirect:/admin/categories";
        }
    }

    @PostMapping("/{id}/edit")
    public String updateCategory(@PathVariable("id") Integer id,
                                 @RequestParam("name") String name,
                                 @RequestParam("imageUrl") String imageUrl,
                                 HttpServletRequest request, HttpSession session) {
        try {
            if (id == null || name == null || name.trim().isEmpty() || imageUrl == null || imageUrl.trim().isEmpty()) {
                session.setAttribute("toastMessage", "Dữ liệu cập nhật không hợp lệ.");
                return "redirect:/admin/categories/" + id + "/edit";
            }
            if (name.length() > 255 || imageUrl.length() > 255) {
                session.setAttribute("toastMessage", "Tên hoặc đường dẫn ảnh không được vượt quá 255 ký tự.");
                return "redirect:/admin/categories/" + id + "/edit";
            }
            Optional<Category> existing = categoryService.findCategoryById(id);
            if (!existing.isPresent()) {
                session.setAttribute("toastMessage", "Danh mục không tồn tại.");
                return "redirect:/admin/categories";
            }
            Category categoryToUpdate = existing.get();
            categoryToUpdate.setName(name);
            categoryToUpdate.setImageUrl(imageUrl);
            if (categoryService.editCategory(categoryToUpdate)) {
                session.setAttribute("toastMessage", "Sửa danh mục thành công.");
                return "redirect:/admin/categories";
            } else {
                session.setAttribute("toastMessage", "Sửa danh mục thất bại. Đã có lỗi xảy ra.");
                return "redirect:/admin/categories/" + id + "/edit";
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("toastMessage", "Lỗi trong quá trình cập nhật: " + e.getMessage());
            return "redirect:/admin/categories";
        }
    }

    @PostMapping("/{id}/delete")
    public String deleteCategory(@PathVariable("id") Integer id, HttpSession session) {
        if (id == null) {
            session.setAttribute("toastMessage", "ID danh mục không hợp lệ.");
            return "redirect:/admin/categories";
        }
        if (categoryService.deleteCategory(id)) {
            session.setAttribute("toastMessage", "Xóa danh mục thành công.");
        } else {
            session.setAttribute("toastMessage", "Không thể xóa danh mục. Có lỗi xảy ra trong database.");
        }
        return "redirect:/admin/categories";
    }
}
