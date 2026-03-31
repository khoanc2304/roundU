package com.tourismapp.controller.dashboardController;

import com.tourismapp.common.Status;
import com.tourismapp.config.ProjectPaths;
import com.tourismapp.entity.Brand;
import org.springframework.beans.factory.annotation.Autowired;
import com.tourismapp.entity.Category;
import com.tourismapp.entity.Product;
import com.tourismapp.service.brand.IBrandService;
import com.tourismapp.service.category.ICategoryService;
import com.tourismapp.service.product.IProductService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import com.tourismapp.annotation.RequiresRole;
import com.tourismapp.common.UserRole;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@RequiresRole({UserRole.ADMIN, UserRole.STAFF})
@Controller
@RequestMapping("/admin/products")
public class ProductManagementController {

    @Autowired
    private IProductService productService;

    @Autowired
    private IBrandService brandService;

    @Autowired
    private ICategoryService categoryService;

    @GetMapping
    public String listProducts(@RequestParam(value = "qProduct", required = false) String qProduct,
                               HttpServletRequest request, HttpSession session) {
        
        if (qProduct != null && !qProduct.trim().isEmpty()) {
            List<Product> products = productService.searchProductsByName(qProduct);
            request.setAttribute("products", products);
        } else {
            session.setAttribute("products", productService.getAllProducts());
        }
        return ProjectPaths.JSP_PRODUCTMANAGEMENT_PATH;
    }

    @GetMapping("/create")
    public String createProductForm() {
        return ProjectPaths.JSP_PATH_DASHBOARD + "productManagement/createProduct.jsp";
    }

    @GetMapping("/{id}/edit")
    public String editProductForm(@PathVariable("id") Integer id, HttpServletRequest request, HttpSession session) {
        if (id == null) {
            session.setAttribute("errorMessage", "Thiếu tham số Id sản phẩm!");
            return "redirect:/admin/products";
        }
        Optional<Product> product = productService.findProductById(id);
        if (product.isEmpty()) {
            session.setAttribute("errorMessage", "Không tìm thấy sản phẩm!");
            return "redirect:/admin/products";
        }
        Optional<Brand> brand = brandService.findBrandById(product.get().getBrand().getBrandId());
        Optional<Category> category = categoryService.findCategoryById(product.get().getCategory().getCategoryId());

        request.setAttribute("brandName", brand.isPresent() ? brand.get().getName() : "");
        request.setAttribute("categoryName", category.isPresent() ? category.get().getName() : "");
        request.setAttribute("product", product.get());
        return ProjectPaths.JSP_PATH_DASHBOARD + "productManagement/manageProduct.jsp";
    }

    @PostMapping("/create")
    public String createProduct(@RequestParam(value = "name", required = false) String name,
                                @RequestParam(value = "description", required = false) String description,
                                @RequestParam(value = "price", required = false) String priceStr,
                                @RequestParam(value = "stockQuantity", required = false) String stockQuantityStr,
                                @RequestParam(value = "categoryId", required = false) String categoryIdStr,
                                @RequestParam(value = "brandId", required = false) String brandIdStr,
                                @RequestParam(value = "imageUrl", required = false) String imageUrl,
                                HttpServletRequest request, HttpSession session) {
        
        if (name != null && !name.trim().isEmpty() && priceStr != null && !priceStr.trim().isEmpty()) {
            try {
                Product product = new Product(name, description, new BigDecimal(priceStr),
                        Integer.parseInt(stockQuantityStr),
                        new Category(Integer.parseInt(categoryIdStr)), new Brand(Integer.parseInt(brandIdStr)),
                        imageUrl);
                boolean success = productService.createProduct(product);
                if (success) {
                    session.setAttribute("successMessage", "Thêm sản phẩm thành công.");
                    return "redirect:/admin/products";
                } else {
                    session.setAttribute("errorMessage", "Thêm sản phẩm không thành công!");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Dữ liệu nhập vào không hợp lệ!");
            }
        } else {
            session.setAttribute("errorMessage", "Các trường thông tin không thể bỏ trống!");
        }
        return ProjectPaths.JSP_PATH_DASHBOARD + "productManagement/createProduct.jsp";
    }

    @PostMapping("/{id}/edit")
    public String editProduct(@PathVariable("id") Integer productId,
                              @RequestParam(value = "name", required = false) String name,
                              @RequestParam(value = "description", required = false) String description,
                              @RequestParam(value = "price", required = false) String priceStr,
                              @RequestParam(value = "stockQuantity", required = false) String stockQuantityStr,
                              @RequestParam(value = "categoryId", required = false) String categoryIdStr,
                              @RequestParam(value = "brandId", required = false) String brandIdStr,
                              @RequestParam(value = "imageUrl", required = false) String imageUrl,
                              @RequestParam(value = "status", required = false) String statusStr,
                              HttpServletRequest request, HttpSession session) {
        
        Optional<Product> findProduct = productService.findProductById(productId);
        if (findProduct.isPresent()) {
            Product p = findProduct.get();
            p.setName(name);
            p.setDescription(description);
            p.setPrice(new BigDecimal(priceStr));
            p.setStockQuantity(Integer.parseInt(stockQuantityStr));
            p.setBrand(new Brand(Integer.parseInt(brandIdStr)));
            p.setCategory(new Category(Integer.parseInt(categoryIdStr)));
            if (statusStr != null) {
                p.setStatus(Status.valueOf(statusStr.toUpperCase()));
            }
            p.setImageUrl(imageUrl);

            if (productService.editProduct(p)) {
                session.setAttribute("successMessage", "Cập nhập sản phẩm thành công.");
                return "redirect:/admin/products/" + productId + "/edit";
            } else {
                session.setAttribute("errorMessage", "Cập nhập sản phẩm thất bại!");
                request.setAttribute("product", p);
                return ProjectPaths.JSP_PATH_DASHBOARD + "productManagement/manageProduct.jsp";
            }
        }
        return "redirect:/admin/products";
    }

    @PostMapping("/{id}/delete")
    public String deleteProduct(@PathVariable("id") Integer productId, HttpSession session) {
        if (productId != null) {
            if (productService.deleteProduct(productId)) {
                session.setAttribute("successMessage", "Xóa sản phẩm thành công.");
            } else {
                session.setAttribute("errorMessage", "Xóa sản phẩm không thành công!");
            }
        }
        return "redirect:/admin/products";
    }
}
