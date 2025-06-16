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
import com.tourismapp.model.Category;
import com.tourismapp.model.Product;
import com.tourismapp.service.brand.BrandService;
import com.tourismapp.service.brand.IBrandService;
import com.tourismapp.service.category.CategoryService;
import com.tourismapp.service.category.ICategoryService;
import com.tourismapp.service.product.IProductService;
import com.tourismapp.service.product.ProductService;
import com.tourismapp.utils.ErrDialog;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

/**
 *
 * @author LENOVO
 */
@WebServlet(name = "ProductManagementServlet", urlPatterns = {MainControllerServlet.PRODUCT_MANAGEMENT_SERVLET})
public class ProductManagementServlet extends HttpServlet {

    private final IProductService productService = new ProductService();
    private final IBrandService brandService = new BrandService();
    private final ICategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
//        ErrDialog.showError("P MNG Ser get:action " + action);
        if (action == null) {
            action = "";
        }

//        ErrDialog.showError("doGet P MNG Ser: " + action);
        switch (action) {
            case MainControllerServlet.ACTION_CREATE_PRODUCT_FORM -> // form create
                createProductForm(request, response);
            case MainControllerServlet.ACTION_MANAGE_PRODUCT -> // xem detail
                manageProductForm(request, response);
            case MainControllerServlet.ACTION_SEARCH_PRODUCT ->
                searchProduct(request, response);
            default ->
                showAllProducts(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

//        ErrDialog.showError("Servlet P MNG: action " + action);
        if (action == null) {
            action = "";
        }
        switch (action) {
            case MainControllerServlet.ACTION_CREATE_PRODUCT ->
                createProduct(request, response);
            case MainControllerServlet.ACTION_EDIT_PRODUCT ->
                editProduct(request, response);
            case MainControllerServlet.ACTION_DELETE_PRODUCT ->
                deleteProduct(request, response);
            default ->
                showAllProducts(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc=" functional ... ">
    private void showAllProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> products = productService.getAllProducts(); // luôn gọi để cập nhập dữ liệu sau khi dtb modifie
        request.getSession().setAttribute("products", products);
        request.getRequestDispatcher(ProjectPaths.JSP_PRODUCTMANAGEMENT_PATH).forward(request, response);

    }

    private void searchProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String q = request.getParameter("qProduct");
        List<Product> products;
//        if (q == null || q.isEmpty()) {
//            products = productService.getAllProducts();
//        } else
        products = productService.searchProductsByName(q);
        request.setAttribute("products", products);
        request.getRequestDispatcher(ProjectPaths.JSP_PRODUCTMANAGEMENT_PATH).forward(request, response);
    }

    private void createProductForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(ProjectPaths.JSP_PATH_DASHBOARD + "/productManagement/createProduct.jsp").forward(request, response);
    }

    private void manageProductForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số Id sản phẩm!");
            return;
        }
        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Id sản phẩm không hợp lệ!");
            return;
        }
        Optional<Product> product = productService.findProductById(id);
        Optional<Brand> brand = brandService.findBrandById(product.get().getBrand().getBrandId());
        Optional<Category> category = categoryService.findCategoryById(product.get().getCategory().getCategoryId());
        if (product == null || brand == null || category == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sản phẩm || thương hiệu || danh mục!");
            return;
        }

        request.setAttribute("brandName", brand.get().getName());
        request.setAttribute("categoryName", category.get().getName());
        request.setAttribute("product", product.get());
//        request.getSession().setAttribute("successMessage", "Cập nhập sản phẩm thành công!");

        request.getRequestDispatcher(ProjectPaths.JSP_PATH_DASHBOARD + "/productManagement/manageProduct.jsp").forward(request, response);
    }

    private void createProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String stockQuantityStr = request.getParameter("stockQuantity");
        String categoryIdStr = request.getParameter("categoryId");
        String brandIdStr = request.getParameter("brandId");
        String imageUrl = request.getParameter("imageUrl");

        if (name != null && !name.isEmpty() && priceStr != null && !priceStr.isEmpty()) {
            try {
                double price = Double.parseDouble(priceStr);
                int stockQuantity = Integer.parseInt(stockQuantityStr);
                int categoryId = Integer.parseInt(categoryIdStr);
                int brandId = Integer.parseInt(brandIdStr);

                Product product = new Product(name, description, new BigDecimal(price), stockQuantity, new Category(categoryId), new Brand(brandId), imageUrl);
                boolean success = productService.createProduct(product);

                if (success) {
                    request.getSession().setAttribute("successMessage", "Thêm sản phẩm thành công.");
                    showAllProducts(request, response);
                } else {
                    request.getSession().setAttribute("errorMessage", "Thêm sản phẩm không thành công!");
                    request.getRequestDispatcher(ProjectPaths.JSP_PATH_DASHBOARD + "/productManagement/createProduct.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "Dữ liệu nhập vào không hợp lệ!");
                request.getRequestDispatcher(ProjectPaths.JSP_PATH_DASHBOARD + "/productManagement/createProduct.jsp").forward(request, response);
            }
        } else {
            request.getSession().setAttribute("errorMessage", "Các trường thông tin không thể bỏ trống!");
            request.getRequestDispatcher(ProjectPaths.JSP_PATH_DASHBOARD + "/productManagement/createProduct.jsp").forward(request, response);
        }
    }

    private void editProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("productId");
        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số Id sản phẩm!");
            return;
        }
        int productId;
        try {
            productId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Id sản phẩm không hợp lệ!");
            return;
        }

        Optional<Product> findProduct = productService.findProductById(productId);

        findProduct.get().setName(request.getParameter("name"));
        findProduct.get().setDescription(request.getParameter("description"));
        findProduct.get().setPrice(new BigDecimal(request.getParameter("price")));
        findProduct.get().setStockQuantity(Integer.parseInt(request.getParameter("stockQuantity")));
        findProduct.get().setBrand(new Brand(Integer.parseInt(request.getParameter("brandId"))));
        findProduct.get().setCategory(new Category(Integer.parseInt(request.getParameter("categoryId"))));
        findProduct.get().setStatus(Status.valueOf(request.getParameter("status").toUpperCase()));
//        findProduct.get().setImageUrl(imageUrl);

        boolean isUpdated = productService.editProduct(findProduct.get());
        if (isUpdated) {
            request.getSession().setAttribute("successMessage", "Cập nhập sản phẩm thành công.");
            response.sendRedirect(ProjectPaths.HREF_TO_MAINCONTROLLER + MainControllerServlet.ACTION_MANAGE_PRODUCT + "&id=" + productId);
        } else {
            request.getSession().setAttribute("errorMessage", "Cập nhập sản phẩm thất bại!");
            request.getRequestDispatcher(ProjectPaths.JSP_PATH_DASHBOARD + "/productManagement/manageProduct.jsp").forward(request, response);
        }
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String productIdStr = request.getParameter("productId");

        if (productIdStr != null && !productIdStr.isEmpty()) {
            try {
                int productId = Integer.parseInt(productIdStr);
                boolean success = productService.deleteProduct(productId);
                if (success) {
                    request.getSession().setAttribute("successMessage", "Xóa sản phẩm thành công.");
                    showAllProducts(request, response);
                } else {
                    request.getSession().setAttribute("errorMessage", "Xóa sản phẩm không thành công!");
                    showAllProducts(request, response);
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "Id sản phẩm không hợp lệ!");
                showAllProducts(request, response);
            }
        }
    }

// </editor-fold>
}
