package com.tourismapp.controller.dashboardController;

import com.tourismapp.common.Status;
import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;
import com.tourismapp.model.Category;
import com.tourismapp.service.category.ICategoryService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;

@Controller
@RequestMapping(MainControllerServlet.CATEGORY_MANAGEMENT_SERVLET)
public class CategoryManagementController {

    @Autowired
    private ICategoryService categoryService;

    @GetMapping
    public String handleGet(@RequestParam(value = "action", required = false, defaultValue = "") String action,
            @RequestParam(value = "qCategory", required = false) String qCategory,
            @RequestParam(value = "id", required = false) Integer id,
            HttpServletRequest request) {

        switch (action) {
            case MainControllerServlet.ACTION_CREATE_CATEGORY_FORM:
                return ProjectPaths.JSP_PATH_DASHBOARD + "/categoryManagement/createCategory.jsp";

            case MainControllerServlet.ACTION_UPDATE_CATEGORY_FORM:
                if (id == null) {
                    request.setAttribute("errorMessage", "Thiếu tham số ID category");
                    return showAllCategories(request);
                }
                Optional<Category> category = categoryService.findCategoryById(id);
                if (category.isEmpty()) {
                    request.setAttribute("errorMessage", "Không tìm thấy category");
                    return showAllCategories(request);
                }
                request.setAttribute("category", category.get());
                return ProjectPaths.JSP_PATH_DASHBOARD + "/categoryManagement/updateCategory.jsp";

            case MainControllerServlet.ACTION_SEARCH_CATEGORY:
                List<Category> categories = categoryService.searchCategoriesByName(qCategory);
                request.setAttribute("categories", categories);
                return ProjectPaths.JSP_CATEGORYMANAGEMENT_PATH;

            default:
                return showAllCategories(request);
        }
    }

    @PostMapping
    public String handlePost(@RequestParam(value = "action", required = false, defaultValue = "") String action,
            @RequestParam(value = "categoryId", required = false) Integer categoryId,
            @RequestParam(value = "name", required = false) String name,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam(value = "imageUrl", required = false) String imageUrl,
            @RequestParam(value = "status", required = false) String statusParam,
            HttpServletRequest request) {

        switch (action) {
            case MainControllerServlet.ACTION_CREATE_CATEGORY:
                if (name != null && !name.isEmpty()) {
                    Category newCategory = new Category(name, description, imageUrl,
                            statusParam != null ? Status.valueOf(statusParam) : null);
                    categoryService.createCategory(newCategory);
                    return showAllCategories(request);
                } else {
                    request.setAttribute("errorMessage", "Các trường thông tin không thể bỏ trống");
                    return ProjectPaths.JSP_PATH_DASHBOARD + "/categoryManagement/createCategory.jsp";
                }

            case MainControllerServlet.ACTION_EDIT_CATEGORY:
                if (categoryId == null) {
                    request.setAttribute("errorMessage", "Thiếu tham số ID category");
                    return showAllCategories(request);
                }
                Optional<Category> findCategory = categoryService.findCategoryById(categoryId);
                if (findCategory.isPresent()) {
                    Category cat = findCategory.get();
                    cat.setName(name);
                    cat.setDescription(description);
                    cat.setImageUrl(imageUrl);
                    if (statusParam != null)
                        cat.setStatus(Status.valueOf(statusParam.toUpperCase()));

                    if (categoryService.editCategory(cat)) {
                        return "redirect:" + ProjectPaths.HREF_TO_CATEGORYMANAGEMENT
                                .substring(ProjectPaths.PREFIX_WEB_PATH.length());
                    } else {
                        request.setAttribute("errorMessage", "Failed to update the category.");
                        request.setAttribute("category", cat);
                        return ProjectPaths.JSP_PATH_DASHBOARD + "/categoryManagement/updateCategory.jsp";
                    }
                }
                return showAllCategories(request);

            case MainControllerServlet.ACTION_DELETE_CATEGORY:
                if (categoryId != null) {
                    boolean success = categoryService.deleteCategory(categoryId);
                    if (!success) {
                        request.setAttribute("errorMessage", "Xóa danh mục không thành công.");
                    }
                }
                return showAllCategories(request);

            default:
                return showAllCategories(request);
        }
    }

    private String showAllCategories(HttpServletRequest request) {
        request.getSession().setAttribute("categories", categoryService.getAllCategories());
        return ProjectPaths.JSP_CATEGORYMANAGEMENT_PATH;
    }
}
