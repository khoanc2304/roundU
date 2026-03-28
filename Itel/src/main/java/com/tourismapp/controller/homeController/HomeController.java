package com.tourismapp.controller.homeController;

import com.tourismapp.config.ProjectPaths;
import com.tourismapp.entity.Brand;
import org.springframework.beans.factory.annotation.Autowired;
import com.tourismapp.entity.Category;
import com.tourismapp.entity.Product;
import com.tourismapp.service.brand.IBrandService;
import com.tourismapp.service.category.ICategoryService;
import com.tourismapp.service.product.IProductService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/homePage")
public class HomeController {

    @Autowired
    private IProductService productService;
    @Autowired
    private ICategoryService categoryService;
    @Autowired
    private IBrandService brandService;

    @GetMapping
    public String doGet(@RequestParam(value = "action", defaultValue = "") String action,
            HttpServletRequest request, HttpSession session) {
        if ("searchActiveProduct".equals(action)) {
            return searchActiveProduct(request, session);
        } else {
            return showActiveProducts(request, session);
        }
    }

    @PostMapping
    public String doPost(HttpServletRequest request) {
        return ProjectPaths.JSP_HOMEPAGE_PATH;
    }

    private String showActiveProducts(HttpServletRequest request, HttpSession session) {
        List<Product> activeProducts = productService.getActiveProducts();
        List<Category> categories = categoryService.getAllCategories();
        List<Brand> activeBrands = brandService.getActiveBrands();

        for (Category c : categories) {
            session.setAttribute(c.getName() + "ImageUrl", c.getImageUrl());
        }

        Cookie[] cookies = request.getCookies();
        List<Product> viewedProducts = new ArrayList<>();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("viewedProducts".equals(cookie.getName())) {
                    String value = cookie.getValue();
                    if (value != null && !value.isEmpty()) {
                        String[] ids = value.split("-");
                        for (String idStr : ids) {
                            try {
                                int pid = Integer.parseInt(idStr);
                                productService.findProductById(pid).ifPresent(viewedProducts::add);
                            } catch (NumberFormatException ignored) {
                            }
                        }
                    }
                    break;
                }
            }
        }
        request.setAttribute("viewedProducts", viewedProducts);

        session.setAttribute("categories", categories);
        session.setAttribute("activeProducts", activeProducts);
        session.setAttribute("activeBrands", activeBrands);

        return ProjectPaths.JSP_HOMEPAGE_PATH;
    }

    private String searchActiveProduct(HttpServletRequest request, HttpSession session) {
        String q = request.getParameter("qProduct");
        List<Product> products;
        if (q == null || q.isEmpty()) {
            products = productService.getActiveProducts();
        } else {
            products = productService.searchActiveProductsByName(q);
        }
        session.setAttribute("activeProducts", products);
        return ProjectPaths.JSP_HOMEPAGE_PATH;
    }
}
