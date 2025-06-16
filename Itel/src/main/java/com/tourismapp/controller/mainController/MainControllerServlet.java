package com.tourismapp.controller.mainController;

import com.tourismapp.utils.ErrDialog;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author LENOVO
 */
@WebServlet(name = "MainControllerServlet", urlPatterns = {"/main"})
public class MainControllerServlet extends HttpServlet {

    // display servlet list
    //dashboard
    public static final String DASHBOARDPAGE_REDIRECT = "dashboardPage";
    public static final String USER_MANAGEMENT_REDIRECT = "userManagement";
    public static final String BRAND_MANAGEMENT_REDIRECT = "brandManagement";
    public static final String CATEGORY_MANAGEMENT_REDIRECT = "categoryManagement";
    public static final String PRODUCT_MANAGEMENT_REDIRECT = "productManagement";
    public static final String ORDER_MANAGEMENT_REDIRECT = "orderManagement";

    //user view
    public static final String LOGINPAGE_REDIRECT = "loginPage";
    public static final String LOGOUTPAGE_REDIRECT = "logoutPage";
    public static final String PROFILEPAGE_REDIRECT = "profilePage";
    public static final String PRODUCTPAGE_REDIRECT = "productPage";
    public static final String HOMEPAGE_REDIRECT = "homePage";
    public static final String CHECKOUTPAGE_REDIRECT = "checkoutPage";
    public static final String CARTPAGE_REDIRECT = "cartPage";

    // redirect to each servlets
    //dashboard
    public static final String DASHBOARDPAGE_SERVLET = "/" + DASHBOARDPAGE_REDIRECT;
    public static final String USER_MANAGEMENT_SERVLET = "/" + USER_MANAGEMENT_REDIRECT;
    public static final String BRAND_MANAGEMENT_SERVLET = "/" + BRAND_MANAGEMENT_REDIRECT;
    public static final String CATEGORY_MANAGEMENT_SERVLET = "/" + CATEGORY_MANAGEMENT_REDIRECT;
    public static final String PRODUCT_MANAGEMENT_SERVLET = "/" + PRODUCT_MANAGEMENT_REDIRECT;
    public static final String ORDER_MANAGEMENT_SERVLET = "/" + ORDER_MANAGEMENT_REDIRECT;

    //user view
    public static final String LOGINPAGE_SERVLET = "/" + LOGINPAGE_REDIRECT;
    public static final String LOGOUTPAGE_SERVLET = "/" + LOGOUTPAGE_REDIRECT;
    public static final String PROFILEPAGE_SERVLET = "/" + PROFILEPAGE_REDIRECT;
    public static final String PRODUCTPAGE_SERVLET = "/" + PRODUCTPAGE_REDIRECT;
    public static final String HOMEPAGE_SERVLET = "/" + HOMEPAGE_REDIRECT;
    public static final String CHECKOUTPAGE_SERVLET = "/" + CHECKOUTPAGE_REDIRECT;
    public static final String CARTPAGE_SERVLET = "/" + CARTPAGE_REDIRECT;

    // main?action=
    // doPost (Action)
    public static final String ACTION_LOGIN = "login";
    public static final String ACTION_LOGOUT = "logout";

    // HUY
    public static final String ACTION_CREATE_USER = "createUser";
    public static final String ACTION_EDIT_USER = "editUser";
    public static final String ACTION_DELETE_USER = "deleteUser";
    public static final String ACTION_LIST_USER = "listUser";

    //NAM
    public static final String ACTION_CREATE_BRAND = "createBrand";
    public static final String ACTION_EDIT_BRAND = "editBrand";
    public static final String ACTION_DELETE_BRAND = "deleteBrand";
    public static final String ACTION_NAVIGATE_TO_CREATE_BRAND = "navigateToCreateBrand";
    public static final String ACTION_NAVIGATE_TO_UPDATE_BRAND = "navigateToUpdateBrand";

    // KHOA
    public static final String ACTION_CREATE_PRODUCT = "createProduct";
    public static final String ACTION_EDIT_PRODUCT = "editProduct";
    public static final String ACTION_DELETE_PRODUCT = "deleteProduct";

    // VINH
    public static final String ACTION_CREATE_CATEGORY = "createCategory";
    public static final String ACTION_EDIT_CATEGORY = "editCategory";
    public static final String ACTION_DELETE_CATEGORY = "deleteCategory";

    // HIEU
    public static final String ACTION_CREATE_REVIEW = "createReview"; // làm sau, product, homepage xong ...
    public static final String ACTION_EDIT_REVIEW = "editReview"; // làm sau, product, homepage xong ...
    public static final String ACTION_DELETE_REVIEW = "deleteReview"; // làm sau, product, homepage xong ...
    // cart 
    public static final String ACTION_ADD_ITEMS = "add-items"; // cart
    public static final String ACTION_INCREASE_QUANTITY = "increase-quantity"; // cart
    public static final String ACTION_DECREASE_QUANTITY = "decrease-quantity"; // cart   
    public static final String ACTION_CHECKOUT = "confirm-checkout"; // checkOut

    // doGet (Action)
    // Khoa browser
    public static final String ACTION_FILTER_BY_CATEGORY = "filterByCategory";
    public static final String ACTION_FILTER_BY_BRAND = "filterByBrand";
    public static final String ACTION_SEARCH_ACTIVE_PRODUCT = "searchActiveProduct";
    public static final String ACTION_BROWSE_PRODUCT = "browseProduct";
    
    // KHOA dashboard
    public static final String ACTION_CREATE_PRODUCT_FORM = "createProductForm";
    public static final String ACTION_EDIT_PRODUCT_FORM = "editProductForm";
    public static final String ACTION_SEARCH_PRODUCT = "searchProduct";
    public static final String ACTION_VIEW_PRODUCT = "viewProduct";
    public static final String ACTION_FIND_PRODUCT = "findProduct";
    public static final String ACTION_MANAGE_PRODUCT = "manageProduct";

    // NAM dashboard
    public static final String ACTION_MANAGE_BRAND = "manageBrand";
    public static final String ACTION_FIND_BRAND = "findBrand";

    // HUY dashboard
    public static final String ACTION_MANAGE_USER = "manageUser";  // thay đổi trạng thái role, xoá user active -> inactive
    public static final String ACTION_SEARCH_USER = "searchUser";

    //...
    public static final String ACTION_VIEW_PROFILE = "viewProfile";  // view info user detail (edit)
    public static final String ACTION_EDIT_PROFILE = "editProfile";  // (edit) profile

    // HIEU    
    public static final String ACTION_VIEW_COMMENT = "viewComment";

    // VINH dashboard
    public static final String ACTION_UPDATE_CATEGORY_FORM = "updateCategoryForm";
    public static final String ACTION_CREATE_CATEGORY_FORM = "createCategoryForm";
    public static final String ACTION_SEARCH_CATEGORY = "searchCategory";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // xu li du lieu dau vao
        String action = request.getParameter("action").trim();
//        ErrDialog.showError("MainControllerServlet + action doPost: " + action);
        switch (action) {
            case ACTION_LOGIN ->
                request.getRequestDispatcher(LOGINPAGE_REDIRECT).forward(request, response);
            case ACTION_CREATE_PRODUCT, ACTION_EDIT_PRODUCT, ACTION_DELETE_PRODUCT ->
                request.getRequestDispatcher(PRODUCT_MANAGEMENT_REDIRECT).forward(request, response);
            //USER HUY
            case ACTION_CREATE_USER, ACTION_EDIT_USER, ACTION_DELETE_USER ->
                request.getRequestDispatcher(USER_MANAGEMENT_SERVLET).forward(request, response);
            //BRAND NAM
            case ACTION_CREATE_BRAND, ACTION_EDIT_BRAND, ACTION_DELETE_BRAND ->
                request.getRequestDispatcher(BRAND_MANAGEMENT_REDIRECT).forward(request, response);
            //CATEGORY VINH
            case ACTION_CREATE_CATEGORY, ACTION_EDIT_CATEGORY, ACTION_DELETE_CATEGORY -> 
                request.getRequestDispatcher(CATEGORY_MANAGEMENT_REDIRECT).forward(request, response);
            default ->
                response.sendRedirect("errorAtMainController.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // chuyen huong / tac vu don gian
        String action = request.getParameter("action");
//        ErrDialog.showError("MainControllerServlet + action doGet: " + action);

        switch (action) {
            case //DIRECT TO BROWSER
                    LOGINPAGE_REDIRECT, 
                    LOGOUTPAGE_REDIRECT, 
                    PROFILEPAGE_REDIRECT, 
                    PRODUCTPAGE_REDIRECT, 
                    HOMEPAGE_REDIRECT, 
                    CARTPAGE_REDIRECT, 
                //DIRECT TO DASHBOARD
                    DASHBOARDPAGE_REDIRECT, 
                    USER_MANAGEMENT_REDIRECT, 
                    BRAND_MANAGEMENT_REDIRECT, 
                    CATEGORY_MANAGEMENT_REDIRECT, 
                    PRODUCT_MANAGEMENT_REDIRECT, 
                    ORDER_MANAGEMENT_REDIRECT ->
                request.getRequestDispatcher(action).forward(request, response);
            // VIEW PRODUCT FOR USER 
            case ACTION_BROWSE_PRODUCT ->
                request.getRequestDispatcher(PRODUCTPAGE_REDIRECT).forward(request, response);
            case ACTION_SEARCH_ACTIVE_PRODUCT ->
                request.getRequestDispatcher(HOMEPAGE_REDIRECT).forward(request, response);
            // PRODUCT MANAGEMENT 
            case ACTION_CREATE_PRODUCT_FORM, ACTION_MANAGE_PRODUCT, ACTION_SEARCH_PRODUCT ->
                request.getRequestDispatcher(PRODUCT_MANAGEMENT_REDIRECT).forward(request, response);
            //USER MANAGEMENT HUY
            case "createForm" ->
                request.getRequestDispatcher(USER_MANAGEMENT_REDIRECT).forward(request, response);
            // BRAND MANAGEMENT NAM
            case ACTION_MANAGE_BRAND, ACTION_FIND_BRAND, ACTION_NAVIGATE_TO_CREATE_BRAND, ACTION_NAVIGATE_TO_UPDATE_BRAND -> 
                request.getRequestDispatcher(BRAND_MANAGEMENT_REDIRECT).forward(request, response);
            // CATEGORY MANAGEMENT VINH
            case ACTION_CREATE_CATEGORY_FORM, ACTION_SEARCH_CATEGORY, ACTION_UPDATE_CATEGORY_FORM -> //(fix) -> bỏ action vào đây để nó direct tới trang servlet
                 request.getRequestDispatcher(CATEGORY_MANAGEMENT_REDIRECT).forward(request, response);
            default ->
                response.sendRedirect("errorAtMainController.jsp");
        }
    }

}
