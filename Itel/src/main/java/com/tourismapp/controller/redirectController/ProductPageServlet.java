package com.tourismapp.controller.redirectController;

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
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@WebServlet(name = "ProductPageServlet", urlPatterns = {MainControllerServlet.PRODUCTPAGE_SERVLET})
public class ProductPageServlet extends HttpServlet {

    private final IProductService productService = new ProductService();
    private final IBrandCategoryService brandCategoryService = new BrandCategoryService();
    private final IReviewService reviewService = new ReviewService();
    private final IUserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
//        ErrDialog.showError("ProductSer: " + action);
        if (action == null) {
            action = "";
        }

        if (MainControllerServlet.ACTION_FILTER_BY_CRITERIA.equals(action)) {
            filterProducts(request, response);
            return;
        }

        String category = request.getParameter("c");
        String brand = request.getParameter("brand");
        if (category != null) {
            showProductsByCategory(request, response);
        } //        else if (brand != null) {
        //            showProductsByBrand(request, response);
        //        } 
        else {
            showActiveProductDetail(request, response);
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

//        ErrDialog.showError("Servlet P : action " + action);
        if (action == null) {
            action = "";
        }
        switch (action) {
            case MainControllerServlet.ACTION_CREATE_REVIEW ->
                createReview(request, response);
            case MainControllerServlet.ACTION_EDIT_REVIEW ->
                editReview(request, response);
            case MainControllerServlet.ACTION_DELETE_REVIEW ->
                deleteReview(request, response);
            default ->
                request.getRequestDispatcher(ProjectPaths.JSP_HOMEPAGE_PATH).forward(request, response);

        }
    }

// <editor-fold defaultstate="collapsed" desc=" functional ... ">
    private void createReview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

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
            response.sendRedirect(ProjectPaths.HREF_TO_PRODUCTPAGE + "&id=" + productId);
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Dữ liệu truyền vào không hợp lệ!");
            ErrDialog.showError("createReview(): " + e.getMessage());
            response.sendRedirect(ProjectPaths.HREF_TO_HOMEPAGE);
        }
    }

    private void editReview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(true);
        String action = request.getParameter("action");
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
        response.sendRedirect(ProjectPaths.HREF_TO_PRODUCTPAGE + "&id=" + productId);
    }

    private void deleteReview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(true);
        int reviewId = Integer.parseInt(request.getParameter("reviewId"));
        int productId = Integer.parseInt(request.getParameter("productId"));
        boolean success = reviewService.deleteReview(reviewId);
        if (success) {
            session.setAttribute("successMessage", "Xoá review sản phẩm thành công.");
        } else {
            session.setAttribute("errorMessage", "Xoá review sản phẩm không thành công!");
        }
        response.sendRedirect(ProjectPaths.HREF_TO_PRODUCTPAGE + "&id=" + productId);
    }

    private void showActiveProductDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
//        ErrDialog.showError("id para: " +idParam);
        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số ID product");
            return;
        }
        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID không hợp lệ");
            return;
        }

        //VINH
        // Ghi ID sản phẩm vào cookie 'viewedProducts'
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
            java.util.LinkedHashSet<String> set = new java.util.LinkedHashSet<>();
            for (String s : viewed.split("-")) {
                if (!s.equals(newViewed)) {
                    set.add(s);
                }
            }
            set.add(newViewed); // Đảm bảo không trùng lặp, thêm mới nhất cuối cùng
            // Giới hạn số lượng sản phẩm đã xem (ví dụ 10)
            while (set.size() > 10) {
                set.remove(set.iterator().next());
            }
            newViewed = String.join("-", set);
        }
        Cookie cookie = new Cookie("viewedProducts", newViewed);
        cookie.setPath("/");
        cookie.setMaxAge(60 * 60 * 24 * 7); // 7 ngày
        response.addCookie(cookie);

        //KHOA
        // if product actived -> product no hidden
        Optional<Product> product = productService.findProductById(id);
        Optional<List<ProductImage>> productImages = productService.getProductImagesById(id);
        Map<String, String> infoProduct = productService.getInforProductById(id);

        StatisticReview statisticReview = reviewService.getRatingCountByProductId(id);
        List<Review> reviewProductId = reviewService.getReviewsByProductId(id);
        int totalComments = reviewService.getTotalCommentsByProductId(id);
        Collections.reverse(reviewProductId);

        //Lọc review theo rating
        String ratingParam = request.getParameter("rating");
//        ErrDialog.showError("ratingParam received: " + ratingParam); // Debug
        int ratingFilter = (ratingParam != null && !ratingParam.isEmpty()) ? Integer.parseInt(ratingParam) : 0; // 0 nghĩa là lấy tất cả
        List<Review> reviewProduct = (ratingFilter > 0) 
            ? reviewService.getReviewsByProductIdAndRating(id, ratingFilter)
            : reviewService.getReviewsByProductId(id);
//        ErrDialog.showError("Filtered reviews count: " + reviewProduct.size()); // Debug
        Collections.reverse(reviewProduct); // Sắp xếp mới nhất lên trên
        
        // Kiểm tra người đã mua hàng cho từng review
        HttpSession session = request.getSession();
        Users loggedUser = (Users) session.getAttribute("loggedUser");
        boolean canComment = false;
        if (loggedUser != null) {
            canComment = reviewService.hasUserPurchasedProduct(loggedUser.getUserId(), id);
        }
        request.setAttribute("canComment", canComment); // Truyền trạng thái có thể bình luận
        
        // Tạo map để lưu trạng thái đã mua hàng cho từng user
        Map<Integer, Boolean> userPurchaseStatus = new java.util.HashMap<>();

        if (loggedUser != null) {
            // Kiểm tra xem user hiện tại đã mua sản phẩm này chưa
            boolean currentUserPurchased = reviewService.hasUserPurchasedProduct(loggedUser.getUserId(), id);
            userPurchaseStatus.put(loggedUser.getUserId(), currentUserPurchased);
        }

        // Kiểm tra cho tất cả user trong review list
        for (Review review : reviewProductId) {
            if (!userPurchaseStatus.containsKey(review.getUser().getUserId())) {
                boolean hasPurchased = reviewService.hasUserPurchasedProduct(review.getUser().getUserId(), id);
                userPurchaseStatus.put(review.getUser().getUserId(), hasPurchased);
            }
        }

        // Gửi thông tin trạng thái mua hàng đến JSP
        request.setAttribute("userPurchaseStatus", userPurchaseStatus);

        //HUY
        List<Product> sameCategoryProducts = productService.getProductsByCategory(product.get().getCategory().getCategoryId());

// Loại bỏ sản phẩm hiện tại
        sameCategoryProducts.removeIf(p -> p.getProductId() == product.get().getProductId());

// ✅ Lấy toàn bộ sản phẩm liên quan (không giới hạn)
        List<Product> top5Suggestions = sameCategoryProducts;

// Lấy danh sách tên thuộc tính từ sản phẩm chính
        Map<String, String> currentAttributes = productService.getInforProductById(product.get().getProductId());
        List<String> attributeNames = new ArrayList<>(currentAttributes.keySet()).subList(0, Math.min(5, currentAttributes.size()));

// Dữ liệu gợi ý
        Map<Product, List<String>> productSuggestionMap = new LinkedHashMap<>();
        for (Product p : top5Suggestions) {
            List<String> topAttributes = productService.getProductDetailByIdTop5(p.getProductId());
            productSuggestionMap.put(p, topAttributes);
        }

// Gửi sang JSP
        // Gửi danh sách sản phẩm và thuộc tính
        request.setAttribute("suggestionMap", productSuggestionMap);
        request.setAttribute("attributeNames", attributeNames);

        //-----------------------KHOA-------------------------------------------------
        request.setAttribute("statisticReview", statisticReview);
        request.setAttribute("reviewProductId", reviewProductId);
        request.setAttribute("totalComments", totalComments);
        request.setAttribute("product", product.get());
        request.setAttribute("productImages", productImages.get());
        request.setAttribute("infoProduct", infoProduct);

        request.getRequestDispatcher(ProjectPaths.JSP_PRODUCTDETAILPAGE_PATH).forward(request, response);
    }

    private void showProductsByCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String category = request.getParameter("c");
        int id = productService.mapCategoryId(category);
        List<Product> categoryProducts = productService.getProductsByCategory(id);// lấy List<Product> cùng category từ category_id
        List<BrandCategoryDTO> brandCategoryDTOs = brandCategoryService.getBrandsByCategoryId(id);

        Map<Product, List<String>> mapProduct_Detail = new LinkedHashMap<>();
        for (Product categoryProduct : categoryProducts) {
            List<String> productDetail = productService.getProductDetailByIdTop5(categoryProduct.getProductId());
            mapProduct_Detail.put(categoryProduct, productDetail);
        }

        request.getSession().setAttribute("mapProduct_Detail", mapProduct_Detail);
        request.getSession().setAttribute("categoryId", id);
//        request.setAttribute("categoryProducts", categoryProducts);
        request.getSession().setAttribute("brandCategoryDTOs", brandCategoryDTOs);
        request.getRequestDispatcher(ProjectPaths.JSP_PRODUCTPAGE_PATH).forward(request, response);
    }

    private void filterProducts(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String category = request.getParameter("c");
        String brands = request.getParameter("brands");
        String cpus = request.getParameter("cpus");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");

        int minPrice = minPriceStr != null ? Integer.parseInt(minPriceStr) : 0;
        int maxPrice = maxPriceStr != null ? Integer.parseInt(maxPriceStr) : Integer.MAX_VALUE;

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
    // </editor-fold>
}
