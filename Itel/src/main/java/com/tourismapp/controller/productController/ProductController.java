package com.tourismapp.controller;

import com.google.gson.Gson;
import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;
import com.tourismapp.dto.BrandCategoryDTO;
import com.tourismapp.model.Product;
import com.tourismapp.model.ProductImage;
import com.tourismapp.model.Review;
import com.tourismapp.model.StatisticReview;
import com.tourismapp.model.Users;
import com.tourismapp.service.product.IProductService;
import com.tourismapp.service.product.ProductService;
import com.tourismapp.service.relation.BrandCategoryService;
import com.tourismapp.service.relation.IBrandCategoryService;
import com.tourismapp.service.review.IReviewService;
import com.tourismapp.service.review.ReviewService;
import com.tourismapp.service.user.IUserService;
import com.tourismapp.service.user.UserService;
import com.tourismapp.utils.ErrDialog;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.*;

@Controller
@RequestMapping(MainControllerServlet.PRODUCTPAGE_SERVLET)
public class ProductController {

    private final IProductService productService = new ProductService();
    private final IBrandCategoryService brandCategoryService = new BrandCategoryService();
    private final IReviewService reviewService = new ReviewService();
    private final IUserService userService = new UserService();

    @GetMapping
    public String doGet(@RequestParam(value = "action", defaultValue = "") String action,
                        @RequestParam(value = "c", required = false) String category,
                        HttpServletRequest request, HttpServletResponse response) throws IOException {
        
        if (MainControllerServlet.ACTION_FILTER_BY_CRITERIA.equals(action)) {
            filterProducts(request, response);
            return null;
        }

        if (category != null) {
            return showProductsByCategory(category, request);
        } else {
            return showActiveProductDetail(request, response);
        }
    }

    @PostMapping
    public String doPost(@RequestParam(value = "action", defaultValue = "") String action,
                         HttpServletRequest request, HttpServletResponse response) {
                         
        switch (action) {
            case MainControllerServlet.ACTION_CREATE_REVIEW:
                return createReview(request, response);
            case MainControllerServlet.ACTION_EDIT_REVIEW:
                return editReview(request, response);
            case MainControllerServlet.ACTION_DELETE_REVIEW:
                return deleteReview(request, response);
            default:
                return ProjectPaths.JSP_HOMEPAGE_PATH;
        }
    }

    private String createReview(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");
        } catch (Exception ignored) {}

        String userIdStr = request.getParameter("userId");
        String productIdStr = request.getParameter("productId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");
        String parentReviewIdStr = request.getParameter("parent_review_id");

        try {
            int userId = Integer.parseInt(userIdStr);
            int productId = Integer.parseInt(productIdStr);
            int rating = Integer.parseInt(ratingStr);
            Integer parent_review_id = (parentReviewIdStr != null && !parentReviewIdStr.isEmpty() && !"null".equals(parentReviewIdStr))
                    ? Integer.parseInt(parentReviewIdStr)
                    : null;

            Review review = new Review(new Product(productId), new Users(userId), rating, comment, parent_review_id);
            boolean success = reviewService.addReview(review);

            if (success) {
                request.getSession().setAttribute("successMessage", "Review sản phẩm thành công.");
            } else {
                request.getSession().setAttribute("errorMessage", "Review sản phẩm không thành công!");
            }
            return "redirect:" + ProjectPaths.HREF_TO_PRODUCTPAGE + "&id=" + productId;
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Dữ liệu truyền vào không hợp lệ!");
            ErrDialog.showError("createReview(): " + e.getMessage());
            return "redirect:" + ProjectPaths.HREF_TO_HOMEPAGE;
        }
    }

    private String editReview(HttpServletRequest request, HttpServletResponse response) {
        try { request.setCharacterEncoding("UTF-8"); } catch (Exception ignored) {}
        HttpSession session = request.getSession(true);
        int rating = Integer.parseInt(request.getParameter("rating"));
        int reviewId = Integer.parseInt(request.getParameter("reviewId"));
        String comment = request.getParameter("comment");
        int productId = Integer.parseInt(request.getParameter("productId"));
        boolean success = reviewService.updateReview(new Review(reviewId, rating, comment));

        if (success) {
            session.setAttribute("successMessage", "Cập nhập review sản phẩm thành công.");
        } else {
            session.setAttribute("errorMessage", "Cập nhập review sản phẩm không thành công!");
        }
        return "redirect:" + ProjectPaths.HREF_TO_PRODUCTPAGE + "&id=" + productId;
    }

    private String deleteReview(HttpServletRequest request, HttpServletResponse response) {
        try { request.setCharacterEncoding("UTF-8"); } catch (Exception ignored) {}
        HttpSession session = request.getSession(true);
        int reviewId = Integer.parseInt(request.getParameter("reviewId"));
        int productId = Integer.parseInt(request.getParameter("productId"));
        boolean success = reviewService.deleteReview(reviewId);
        if (success) {
            session.setAttribute("successMessage", "Xoá review sản phẩm thành công.");
        } else {
            session.setAttribute("errorMessage", "Xoá review sản phẩm không thành công!");
        }
        return "redirect:" + ProjectPaths.HREF_TO_PRODUCTPAGE + "&id=" + productId;
    }

    private String showActiveProductDetail(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số ID product");
            return null;
        }
        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID không hợp lệ");
            return null;
        }

        Cookie[] cookies = request.getCookies();
        String viewed = null;
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("viewedProducts".equals(cookie.getName())) {
                    viewed = cookie.getValue();
                    break;
                }
            }
        }
        String newViewed = String.valueOf(id);
        if (viewed != null && !viewed.isEmpty()) {
            Set<String> set = new LinkedHashSet<>();
            for (String s : viewed.split("-")) {
                if (!s.equals(newViewed)) {
                    set.add(s);
                }
            }
            set.add(newViewed);
            while (set.size() > 10) {
                set.remove(set.iterator().next());
            }
            newViewed = String.join("-", set);
        }
        Cookie cookie = new Cookie("viewedProducts", newViewed);
        cookie.setPath("/");
        cookie.setMaxAge(60 * 60 * 24 * 7);
        response.addCookie(cookie);

        Optional<Product> product = productService.findProductById(id);
        if(product.isEmpty()) {
             response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product Not Found");
             return null;
        }

        Optional<List<ProductImage>> productImages = productService.getProductImagesById(id);
        Map<String, String> infoProduct = productService.getInforProductById(id);

        StatisticReview statisticReview = reviewService.getRatingCountByProductId(id);
        List<Review> reviewProductId = reviewService.getReviewsByProductId(id);
        int totalComments = reviewService.getTotalCommentsByProductId(id);
        Collections.reverse(reviewProductId);

        String ratingParam = request.getParameter("rating");
        int ratingFilter = (ratingParam != null && !ratingParam.isEmpty()) ? Integer.parseInt(ratingParam) : 0;
        List<Review> reviewProduct = (ratingFilter > 0) 
            ? reviewService.getReviewsByProductIdAndRating(id, ratingFilter)
            : reviewService.getReviewsByProductId(id);
        Collections.reverse(reviewProduct);

        HttpSession session = request.getSession();
        Users loggedUser = (Users) session.getAttribute("loggedUser");
        boolean canComment = false;
        if (loggedUser != null) {
            canComment = reviewService.hasUserPurchasedProduct(loggedUser.getUserId(), id);
        }
        request.setAttribute("canComment", canComment);

        Map<Integer, Boolean> userPurchaseStatus = new HashMap<>();
        if (loggedUser != null) {
            boolean currentUserPurchased = reviewService.hasUserPurchasedProduct(loggedUser.getUserId(), id);
            userPurchaseStatus.put(loggedUser.getUserId(), currentUserPurchased);
        }
        for (Review review : reviewProductId) {
            if (!userPurchaseStatus.containsKey(review.getUser().getUserId())) {
                boolean hasPurchased = reviewService.hasUserPurchasedProduct(review.getUser().getUserId(), id);
                userPurchaseStatus.put(review.getUser().getUserId(), hasPurchased);
            }
        }
        request.setAttribute("userPurchaseStatus", userPurchaseStatus);

        List<Product> sameCategoryProducts = productService.getProductsByCategory(product.get().getCategory().getCategoryId());
        sameCategoryProducts.removeIf(p -> p.getProductId() == product.get().getProductId());
        
        Map<Product, List<String>> productSuggestionMap = new LinkedHashMap<>();
        for (Product p : sameCategoryProducts) {
            List<String> topAttributes = productService.getProductDetailByIdTop5(p.getProductId());
            productSuggestionMap.put(p, topAttributes);
        }

        Map<String, String> currentAttributes = productService.getInforProductById(product.get().getProductId());
        List<String> attributeNames = new ArrayList<>(currentAttributes.keySet());
        if(attributeNames.size() > 5) attributeNames = attributeNames.subList(0, 5);

        request.setAttribute("suggestionMap", productSuggestionMap);
        request.setAttribute("attributeNames", attributeNames);
        request.setAttribute("statisticReview", statisticReview);
        request.setAttribute("reviewProductId", reviewProductId);
        request.setAttribute("totalComments", totalComments);
        request.setAttribute("product", product.get());
        request.setAttribute("productImages", productImages.orElse(new ArrayList<>()));
        request.setAttribute("infoProduct", infoProduct);

        return ProjectPaths.JSP_PRODUCTDETAILPAGE_PATH;
    }

    private String showProductsByCategory(String category, HttpServletRequest request) {
        int id = productService.mapCategoryId(category);
        List<Product> categoryProducts = productService.getProductsByCategory(id);
        List<BrandCategoryDTO> brandCategoryDTOs = brandCategoryService.getBrandsByCategoryId(id);

        Map<Product, List<String>> mapProduct_Detail = new LinkedHashMap<>();
        for (Product categoryProduct : categoryProducts) {
            List<String> productDetail = productService.getProductDetailByIdTop5(categoryProduct.getProductId());
            mapProduct_Detail.put(categoryProduct, productDetail);
        }

        request.getSession().setAttribute("mapProduct_Detail", mapProduct_Detail);
        request.getSession().setAttribute("categoryId", id);
        request.getSession().setAttribute("brandCategoryDTOs", brandCategoryDTOs);
        
        return ProjectPaths.JSP_PRODUCTPAGE_PATH;
    }

    private void filterProducts(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String category = request.getParameter("c");
        String brands = request.getParameter("brands");
        String cpus = request.getParameter("cpus");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");

        int minPrice = minPriceStr != null && !minPriceStr.isEmpty() ? Integer.parseInt(minPriceStr) : 0;
        int maxPrice = maxPriceStr != null && !maxPriceStr.isEmpty() ? Integer.parseInt(maxPriceStr) : Integer.MAX_VALUE;

        int categoryId = productService.mapCategoryId(category);
        List<Product> filteredProducts = productService.filterProductsByCriteria(categoryId, brands, cpus, minPrice, maxPrice);

        Map<Product, List<String>> mapProduct_Detail = new LinkedHashMap<>();
        for (Product product : filteredProducts) {
            List<String> productDetail = productService.getProductDetailByIdTop5(product.getProductId());
            mapProduct_Detail.put(product, productDetail);
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> jsonResponse = new LinkedHashMap<>();
        mapProduct_Detail.forEach((product, details) -> {
            jsonResponse.put(String.valueOf(product.getProductId()), new Object[]{product, details});
        });
        String json = new Gson().toJson(jsonResponse);
        response.getWriter().write(json);
    }
}
