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
import com.tourismapp.model.Category;
import com.tourismapp.service.category.CategoryService;
import com.tourismapp.service.category.ICategoryService;
import com.tourismapp.utils.ErrDialog;
import java.util.List;
import java.util.Optional;

/**
 *
 * @author LENOVO
 */
@WebServlet(name = "CategoryManagementServlet", urlPatterns = {MainControllerServlet.CATEGORY_MANAGEMENT_SERVLET})
public class CategoryManagementServlet extends HttpServlet {

    private final ICategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }
        switch (action) {
            case MainControllerServlet.ACTION_CREATE_CATEGORY_FORM ->
                createCategoryForm(request, response);
            case MainControllerServlet.ACTION_UPDATE_CATEGORY_FORM ->
                updateCategoryForm(request, response);
            case MainControllerServlet.ACTION_SEARCH_CATEGORY ->
                searchCategory(request, response);
            default ->
                showAllCategories(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }
        switch (action) {
            case MainControllerServlet.ACTION_CREATE_CATEGORY ->
                createCategory(request, response);
            case MainControllerServlet.ACTION_EDIT_CATEGORY ->
                editCategory(request, response);
            case MainControllerServlet.ACTION_DELETE_CATEGORY ->
                deleteCategory(request, response);
            default ->
                showAllCategories(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc=" functional ... ">
    private void showAllCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = categoryService.getAllCategories();
        request.getSession().setAttribute("categories", categories);
        request.getRequestDispatcher(ProjectPaths.JSP_CATEGORYMANAGEMENT_PATH).forward(request, response);
    }

    private void searchCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String q = request.getParameter("qCategory");
        List<Category> categories = categoryService.searchCategoriesByName(q);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher(ProjectPaths.JSP_CATEGORYMANAGEMENT_PATH).forward(request, response);
    }

    private void createCategoryForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(ProjectPaths.JSP_PATH_DASHBOARD + "/categoryManagement/createCategory.jsp").forward(request, response);
    }

    private void updateCategoryForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số ID category");
            return;
        }
        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID không hợp lệ");
            return;
        }
        Optional<Category> category = categoryService.findCategoryById(id);

        if (category.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy category");
            return;
        }
        request.setAttribute("category", category.get());
        request.getRequestDispatcher(ProjectPaths.JSP_PATH_DASHBOARD + "/categoryManagement/updateCategory.jsp").forward(request, response);
    }

    private void createCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String imageUrl = request.getParameter("imageUrl");

        if (name != null && !name.isEmpty()) {
            Category category;
            category = new Category(
                    name,
                    description,
                    imageUrl,
                    request.getParameter("status") != null ? Status.valueOf(request.getParameter("status")) : null
            );
            categoryService.createCategory(category);
            showAllCategories(request, response);
        } else {
            request.setAttribute("errorMessage", "Các trường thông tin không thể bỏ trống");
            request.getRequestDispatcher(ProjectPaths.JSP_PATH_DASHBOARD + "/categoryManagement/createCategory.jsp").forward(request, response);
        }
    }

    private void editCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("categoryId");
        ErrDialog.showError("idpara: " + idParam);
        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số ID category");
            return;
        }
        int categoryId;
        try {
            categoryId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID không hợp lệ");
            return;
        }

        Optional<Category> findCategory = categoryService.findCategoryById(categoryId);

        findCategory.get().setName(request.getParameter("name"));
        findCategory.get().setDescription(request.getParameter("description"));
        findCategory.get().setImageUrl(request.getParameter("imageUrl"));
        findCategory.get().setStatus(Status.valueOf(request.getParameter("status").toUpperCase()));

        boolean isUpdated = categoryService.editCategory(findCategory.get());
        if (isUpdated) {
            response.sendRedirect(ProjectPaths.HREF_TO_CATEGORYMANAGEMENT);
        } else {
            request.setAttribute("errorMessage", "Failed to update the category.");
            request.getRequestDispatcher(ProjectPaths.JSP_PATH_DASHBOARD + "/categoryManagement/manageCategory.jsp").forward(request, response);
        }
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String categoryIdStr = request.getParameter("categoryId");

        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            try {
                int categoryId = Integer.parseInt(categoryIdStr);
                boolean success = categoryService.deleteCategory(categoryId);
                if (success) {
                    showAllCategories(request, response);
                } else {
                    request.setAttribute("errorMessage", "Xóa danh mục không thành công.");
                    showAllCategories(request, response);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "ID danh mục không hợp lệ.");
                showAllCategories(request, response);
            }
        }
    }
    // </editor-fold>
}
