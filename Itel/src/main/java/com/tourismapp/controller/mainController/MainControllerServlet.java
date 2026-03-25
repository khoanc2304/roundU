package com.tourismapp.controller.mainController;

import com.tourismapp.entity.Users;
import com.tourismapp.utils.ErrDialog;
import com.tourismapp.config.ProjectPaths;
import com.tourismapp.service.user.IUserService;
import com.tourismapp.service.user.UserService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

@WebServlet(name = "MainControllerServlet", urlPatterns = { "/main" })
public class MainControllerServlet extends HttpServlet {

    private <T> T getBean(Class<T> clazz) {
        WebApplicationContext context = WebApplicationContextUtils.getRequiredWebApplicationContext(getServletContext());
        return context.getBean(clazz);
    }

    // display servlet list
    // dashboard
    public static final String DASHBOARDPAGE_REDIRECT = "dashboardPage";
    public static final String USER_MANAGEMENT_REDIRECT = "userManagement";
    public static final String BRAND_MANAGEMENT_REDIRECT = "brandManagement";
    public static final String CATEGORY_MANAGEMENT_REDIRECT = "categoryManagement";
    public static final String PRODUCT_MANAGEMENT_REDIRECT = "productManagement";
    public static final String ORDER_MANAGEMENT_REDIRECT = "orderManagement";
    public static final String STATISTIC_REDIRECT = "statisticShow";

    // user view
    public static final String LOGINPAGE_REDIRECT = "loginPage";
    public static final String LOGOUTPAGE_REDIRECT = "logoutPage";
    public static final String PROFILEPAGE_REDIRECT = "profilePage";
    public static final String PRODUCTPAGE_REDIRECT = "productPage";
    public static final String HOMEPAGE_REDIRECT = "homePage";
    public static final String CHECKOUTPAGE_REDIRECT = "checkoutPage";
    public static final String CARTPAGE_REDIRECT = "cartPage";
    public static final String ORDERHISTORY_REDIRECT = "orderHistory";
    public static final String COMPARE_REDIRECT = "compare";
    public static final String REGISTERPAGE_REDIRECT = "registerPage";
    public static final String CHANGEPASSWORDPAGE_REDIRECT = "changePassword";

    // redirect to each servlets
    // dashboard
    public static final String DASHBOARDPAGE_SERVLET = "/" + DASHBOARDPAGE_REDIRECT;
    public static final String USER_MANAGEMENT_SERVLET = "/" + USER_MANAGEMENT_REDIRECT;
    public static final String BRAND_MANAGEMENT_SERVLET = "/" + BRAND_MANAGEMENT_REDIRECT;
    public static final String CATEGORY_MANAGEMENT_SERVLET = "/" + CATEGORY_MANAGEMENT_REDIRECT;
    public static final String PRODUCT_MANAGEMENT_SERVLET = "/" + PRODUCT_MANAGEMENT_REDIRECT;
    public static final String ORDER_MANAGEMENT_SERVLET = "/" + ORDER_MANAGEMENT_REDIRECT;
    public static final String STATISTIC_SERVLET = "/" + STATISTIC_REDIRECT;

    // user view
    public static final String LOGINPAGE_SERVLET = "/" + LOGINPAGE_REDIRECT;
    public static final String LOGOUTPAGE_SERVLET = "/" + LOGOUTPAGE_REDIRECT;
    public static final String PROFILEPAGE_SERVLET = "/" + PROFILEPAGE_REDIRECT;
    public static final String PRODUCTPAGE_SERVLET = "/" + PRODUCTPAGE_REDIRECT;
    public static final String HOMEPAGE_SERVLET = "/" + HOMEPAGE_REDIRECT;
    public static final String CHECKOUTPAGE_SERVLET = "/" + CHECKOUTPAGE_REDIRECT;
    public static final String CARTPAGE_SERVLET = "/" + CARTPAGE_REDIRECT;
    public static final String ORDERHISTORY_SERVLET = "/" + ORDERHISTORY_REDIRECT;
    public static final String COMPARE_SERVLET = "/" + COMPARE_REDIRECT;
    public static final String CHANGEPASSWORD_SERVLET = "/" + CHANGEPASSWORDPAGE_REDIRECT;

    // main?action=
    // doPost (Action)
    public static final String ACTION_LOGIN = "login";
    public static final String ACTION_LOGOUT = "logout";
    public static final String ACTION_UPDATE_PROFILE = "updateProfile";

    public static final String ACTION_CREATE_USER = "createUser";
    public static final String ACTION_EDIT_USER = "editUser";
    public static final String ACTION_DELETE_USER = "deleteUser";
    public static final String ACTION_LIST_USER = "listUser";

    public static final String ACTION_CREATE_BRAND = "createBrand";
    public static final String ACTION_EDIT_BRAND = "editBrand";
    public static final String ACTION_DELETE_BRAND = "deleteBrand";
    public static final String ACTION_NAVIGATE_TO_CREATE_BRAND = "navigateToCreateBrand";
    public static final String ACTION_NAVIGATE_TO_UPDATE_BRAND = "navigateToUpdateBrand";

    public static final String ACTION_CREATE_PRODUCT = "createProduct";
    public static final String ACTION_EDIT_PRODUCT = "editProduct";
    public static final String ACTION_DELETE_PRODUCT = "deleteProduct";

    public static final String ACTION_CREATE_CATEGORY = "createCategory";
    public static final String ACTION_EDIT_CATEGORY = "editCategory";
    public static final String ACTION_DELETE_CATEGORY = "deleteCategory";

    public static final String ACTION_CREATE_REVIEW = "createReview";
    public static final String ACTION_EDIT_REVIEW = "editReview";
    public static final String ACTION_DELETE_REVIEW = "deleteReview";

    public static final String ACTION_REMOVE_FROM_CART = "removeFromCart";
    public static final String ACTION_GET_CART_COUNT = "getCartCount";
    public static final String ACTION_GET_CART_ITEMS = "getCartItems";

    public static final String ACTION_ADD_ITEMS = "add-items"; // cart
    public static final String ACTION_INCREASE_QUANTITY = "increase-quantity"; // cart
    public static final String ACTION_DECREASE_QUANTITY = "decrease-quantity"; // cart
    public static final String ACTION_CHECKOUT = "confirm-checkout"; // checkOut
    // PAYMENT PAGES
    public static final String PAYMENT_SUCCESS_REDIRECT = "paymentSuccess";
    public static final String PAYMENT_FAILED_REDIRECT = "paymentFailed";
    public static final String PAYMENT_PROCESSING_REDIRECT = "paymentProcessing";

    public static final String ACTION_INITIATE_PAYMENT = "initiatePayment";
    public static final String ACTION_PAYMENT_SUCCESS = "paymentSuccess";
    public static final String ACTION_PAYMENT_FAILED = "paymentFailed";
    public static final String ACTION_PAYMENT_PROCESSING = "paymentProcessing";

    // doGet (Action)
    public static final String ACTION_FILTER_BY_CATEGORY = "filterByCategory";
    public static final String ACTION_FILTER_BY_BRAND = "filterByBrand";
    public static final String ACTION_FILTER_BY_CRITERIA = "filter";
    public static final String ACTION_SEARCH_ACTIVE_PRODUCT = "searchActiveProduct";
    public static final String ACTION_BROWSE_PRODUCT = "browseProduct";

    public static final String ACTION_CREATE_PRODUCT_FORM = "createProductForm";
    public static final String ACTION_EDIT_PRODUCT_FORM = "editProductForm";
    public static final String ACTION_SEARCH_PRODUCT = "searchProduct";
    public static final String ACTION_VIEW_PRODUCT = "viewProduct";
    public static final String ACTION_FIND_PRODUCT = "findProduct";
    public static final String ACTION_MANAGE_PRODUCT = "manageProduct";

    public static final String ACTION_MANAGE_BRAND = "manageBrand";
    public static final String ACTION_FIND_BRAND = "findBrand";
    public static final String ACTION_FIND_ORDERS = "manageOrder";
    public static final String ACTION_EDIT_ORDER_STATUS = "manageOrder";

    public static final String ACTION_MANAGE_USER = "manageUser";
    public static final String ACTION_SEARCH_USER = "searchUser";

    public static final String ACTION_NAVIGATE_REGISTER_PAGE = "navigateToRegisterPage";
    public static final String FORGOTPASSWORD_REDIRECT = "forgot-password"; // Đặt tên cho URL của servlet
    public static final String CHANGEPASSWORD_REDIRECT = "changePassword";
    public static final String ACTION_FORGOT_PASSWORD = "forgotPassword";
    public static final String FORGOTPASSWORD_SERVLET = "/" + FORGOTPASSWORD_REDIRECT; // Trỏ đến servlet xử lý quên mật
                                                                                       // khẩu

    // Profile actions
    public static final String ACTION_VIEW_PROFILE = "viewProfile";
    public static final String ACTION_EDIT_PROFILE = "editProfile";
    public static final String ACTION_CHANGE_PASSWORD = "changePassword";

    public static final String ACTION_VIEW_COMMENT = "viewComment";

    public static final String ACTION_VIEW_STATISTIC = "viewStatistic";

    public static final String ACTION_UPDATE_CATEGORY_FORM = "updateCategoryForm";
    public static final String ACTION_CREATE_CATEGORY_FORM = "createCategoryForm";
    public static final String ACTION_SEARCH_CATEGORY = "searchCategory";

    private void refreshUserInfo(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        Users loggedUser = (Users) session.getAttribute("loggedUser");

        if (user != null || loggedUser != null) {
            IUserService userService = getBean(IUserService.class);
            int userId = user != null ? user.getUserId() : loggedUser.getUserId();

            Users updatedUser = userService.getUserById(userId);
            if (updatedUser != null) {
                if (user != null) {
                    session.setAttribute("user", updatedUser);
                }
                if (loggedUser != null) {
                    session.setAttribute("loggedUser", updatedUser);
                }
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action") != null ? request.getParameter("action").trim() : "";
        // ErrDialog.showError("MainPOST: " + action);
        switch (action) {
            case ACTION_LOGIN ->
                request.getRequestDispatcher(LOGINPAGE_REDIRECT).forward(request, response);
            case ACTION_CREATE_PRODUCT, ACTION_EDIT_PRODUCT, ACTION_DELETE_PRODUCT ->
                request.getRequestDispatcher(PRODUCT_MANAGEMENT_REDIRECT).forward(request, response);
            case ACTION_CREATE_REVIEW, ACTION_EDIT_REVIEW, ACTION_DELETE_REVIEW ->
                request.getRequestDispatcher(PRODUCTPAGE_REDIRECT).forward(request, response);
            case ACTION_CREATE_USER, ACTION_EDIT_USER, ACTION_DELETE_USER ->
                request.getRequestDispatcher(USER_MANAGEMENT_SERVLET).forward(request, response);
            case ACTION_CREATE_BRAND, ACTION_EDIT_BRAND, ACTION_DELETE_BRAND ->
                request.getRequestDispatcher(BRAND_MANAGEMENT_REDIRECT).forward(request, response);
            case ACTION_CREATE_CATEGORY, ACTION_EDIT_CATEGORY, ACTION_DELETE_CATEGORY ->
                request.getRequestDispatcher(CATEGORY_MANAGEMENT_REDIRECT).forward(request, response);
            case ACTION_ADD_ITEMS, ACTION_INCREASE_QUANTITY, ACTION_DECREASE_QUANTITY, ACTION_CHECKOUT ->
                request.getRequestDispatcher(CARTPAGE_SERVLET).forward(request, response);
            case ACTION_UPDATE_PROFILE ->
                request.getRequestDispatcher(PROFILEPAGE_SERVLET).forward(request, response);
            case ACTION_NAVIGATE_REGISTER_PAGE ->
                request.getRequestDispatcher(REGISTERPAGE_REDIRECT).forward(request, response);
            case ACTION_FORGOT_PASSWORD ->
                request.getRequestDispatcher(FORGOTPASSWORD_REDIRECT).forward(request, response);
            case "verifyOtp" ->
                request.getRequestDispatcher(FORGOTPASSWORD_REDIRECT).forward(request, response);
            case "resetPassword" ->
                request.getRequestDispatcher(FORGOTPASSWORD_REDIRECT).forward(request, response);
            case ACTION_EDIT_ORDER_STATUS ->
                request.getRequestDispatcher(ORDER_MANAGEMENT_SERVLET).forward(request, response);
            case "updateOrderStatus" -> {
                try {
                    int orderId = Integer.parseInt(request.getParameter("orderId"));
                    String status = request.getParameter("status");
                    com.tourismapp.service.order.IOrderService orderService = getBean(com.tourismapp.service.order.IOrderService.class);
                    boolean updated = orderService.updateOrderStatus(orderId, status);
                    if (updated) {
                        request.setAttribute("successMessage", "Cập nhật trạng thái thành công!");
                        // --- Thông báo cho user (application scope) ---
                        java.util.Optional<com.tourismapp.entity.Orders> orderOpt = orderService.findOrderById(orderId);
                        if (orderOpt.isPresent() && orderOpt.get().getUser() != null) {
                            com.tourismapp.entity.Orders order = orderOpt.get();
                            ServletContext app = getServletContext();
                            synchronized (app) {
                                java.util.Map<Integer, String> notifyMap = (java.util.Map<Integer, String>) app
                                        .getAttribute("userNotifyMap");
                                if (notifyMap == null) {
                                    notifyMap = new java.util.HashMap<>();
                                }
                                String notifyMsg = "Đơn hàng #" + orderId + " của bạn đã được cập nhật trạng thái: "
                                        + status;
                                notifyMap.put(order.getUser().getUserId(), notifyMsg);
                                app.setAttribute("userNotifyMap", notifyMap);
                            }
                        }
                        // --- END thông báo ---
                    } else {
                        request.setAttribute("errorMessage", "Cập nhật trạng thái thất bại!");
                    }
                } catch (Exception e) {
                    request.setAttribute("errorMessage", "Lỗi cập nhật trạng thái: " + e.getMessage());
                }
                String from = request.getParameter("from");
                if ("user".equals(from)) {
                    request.getRequestDispatcher(ORDERHISTORY_REDIRECT).forward(request, response);
                } else {
                    request.getRequestDispatcher(ORDER_MANAGEMENT_REDIRECT).forward(request, response);
                }
            }
            default ->
                response.sendRedirect("errorAtMainController.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        // ErrDialog.showError("MainGET: " + action);
        if ("homePage".equals(action) || "cartPage".equals(action) || "checkoutPage".equals(action)
                || "profilePage".equals(action) || "orderHistory".equals(action)) {
            refreshUserInfo(request);
        }

        switch (action) {
            case // DIRECT TO BROWSER
                    LOGINPAGE_REDIRECT, LOGOUTPAGE_REDIRECT, PROFILEPAGE_REDIRECT, PRODUCTPAGE_REDIRECT,
                    HOMEPAGE_REDIRECT, CARTPAGE_REDIRECT, CHECKOUTPAGE_REDIRECT, ORDERHISTORY_REDIRECT, // DIRECT TO
                                                                                                        // DASHBOARD
                    DASHBOARDPAGE_REDIRECT, USER_MANAGEMENT_REDIRECT, BRAND_MANAGEMENT_REDIRECT,
                    CATEGORY_MANAGEMENT_REDIRECT, PRODUCT_MANAGEMENT_REDIRECT, ORDER_MANAGEMENT_REDIRECT,
                    COMPARE_REDIRECT ->
                request.getRequestDispatcher(action).forward(request, response);
            // VIEW PRODUCT FOR USER
            case ACTION_BROWSE_PRODUCT, ACTION_FILTER_BY_CRITERIA ->
                request.getRequestDispatcher(PRODUCTPAGE_REDIRECT).forward(request, response);
            case ACTION_SEARCH_ACTIVE_PRODUCT ->
                request.getRequestDispatcher(HOMEPAGE_REDIRECT).forward(request, response);
            // PRODUCT MANAGEMENT
            case ACTION_CREATE_PRODUCT_FORM, ACTION_MANAGE_PRODUCT, ACTION_SEARCH_PRODUCT ->
                request.getRequestDispatcher(PRODUCT_MANAGEMENT_REDIRECT).forward(request, response);
            case "createForm" ->
                request.getRequestDispatcher(USER_MANAGEMENT_REDIRECT).forward(request, response);
            // BRAND MANAGEMENT NAME
            case ACTION_MANAGE_BRAND, ACTION_FIND_BRAND, ACTION_NAVIGATE_TO_CREATE_BRAND,
                    ACTION_NAVIGATE_TO_UPDATE_BRAND ->
                request.getRequestDispatcher(BRAND_MANAGEMENT_REDIRECT).forward(request, response);
            // ORDER STAT
            case ACTION_VIEW_STATISTIC ->
                request.getRequestDispatcher(DASHBOARDPAGE_SERVLET).forward(request, response);
            // CATEGORY MANAGEMENT
            case ACTION_CREATE_CATEGORY_FORM, ACTION_SEARCH_CATEGORY, ACTION_UPDATE_CATEGORY_FORM -> // (fix) -> bỏ
                                                                                                     // action vào đây
                                                                                                     // để nó direct tới
                                                                                                     // trang servlet
                request.getRequestDispatcher(CATEGORY_MANAGEMENT_REDIRECT).forward(request, response);
            // ORDER-CART HIEU
            case ACTION_PAYMENT_SUCCESS -> {
                String message = (String) request.getSession().getAttribute("paymentMessage");
                request.setAttribute("successMessage", message != null ? message : "Payment completed successfully!");
                request.getSession().removeAttribute("paymentMessage");
                request.getRequestDispatcher("paymentSuccess.jsp").forward(request, response);
            }
            case ACTION_PAYMENT_FAILED -> {
                String message = (String) request.getSession().getAttribute("paymentMessage");
                request.setAttribute("errorMessage", message != null ? message : "Payment failed. Please try again.");
                request.getSession().removeAttribute("paymentMessage");
                request.getRequestDispatcher("paymentFailed.jsp").forward(request, response);
            }
            case ACTION_PAYMENT_PROCESSING -> {
                request.getRequestDispatcher("paymentProcessing.jsp").forward(request, response);
            }
            // CHANGE PASSWORD
            case CHANGEPASSWORDPAGE_REDIRECT ->
                request.getRequestDispatcher(ProjectPaths.JSP_CHANGE_PASSWORD_PATH).forward(request, response);
            case ACTION_VIEW_PROFILE, ACTION_EDIT_PROFILE ->
                request.getRequestDispatcher(PROFILEPAGE_SERVLET).forward(request, response);
            // REGISTER
            case REGISTERPAGE_REDIRECT ->
                request.getRequestDispatcher(ProjectPaths.JSP_REGISTER_PAGE_PATH).forward(request, response);

            case FORGOTPASSWORD_REDIRECT ->
                request.getRequestDispatcher(FORGOTPASSWORD_REDIRECT).forward(request, response);
            case ACTION_FIND_ORDERS -> {
                request.getRequestDispatcher(ORDER_MANAGEMENT_REDIRECT).forward(request, response);
            }
            case "recentlyViewed" -> {
                request.getRequestDispatcher("/WEB-INF/view/pages/recentlyViewed.jsp").forward(request, response);
            }
            case "viewOrderDetail" ->
                request.getRequestDispatcher(ORDER_MANAGEMENT_SERVLET).forward(request, response);
            default ->
                response.sendRedirect("errorAtMainController.jsp");
        }
    }
}
