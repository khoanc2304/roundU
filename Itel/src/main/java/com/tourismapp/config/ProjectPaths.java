package com.tourismapp.config;

/**
 * Central registry of all application URL constants and JSP view paths.
 * HREF_TO_* constants point directly to Spring MVC controller mappings.
 */
public class ProjectPaths {

    public static final String PREFIX_WEB_PATH = "/Itel";

    // HREF constants — Dashboard (Admin/Staff)
    public static final String HREF_TO_DASHBOARDPAGE = PREFIX_WEB_PATH + "/dashboardPage";
    public static final String HREF_TO_USERMANAGEMENT = PREFIX_WEB_PATH + "/admin/users";
    public static final String HREF_TO_BRANDMANAGEMENT = PREFIX_WEB_PATH + "/admin/brands";
    public static final String HREF_TO_CATEGORYMANAGEMENT = PREFIX_WEB_PATH + "/admin/categories";
    public static final String HREF_TO_PRODUCTMANAGEMENT = PREFIX_WEB_PATH + "/admin/products";
    public static final String HREF_TO_ORDERMANAGEMENT = PREFIX_WEB_PATH + "/admin/orders";

    // HREF constants — User-Facing Pages
    public static final String HREF_TO_HOMEPAGE = PREFIX_WEB_PATH + "/homePage";
    public static final String HREF_TO_LOGINPAGE = PREFIX_WEB_PATH + "/loginPage";
    public static final String HREF_TO_LOGOUTPAGE = PREFIX_WEB_PATH + "/logoutPage";
    public static final String HREF_TO_PROFILEPAGE = PREFIX_WEB_PATH + "/profilePage";
    public static final String HREF_TO_PRODUCTPAGE = PREFIX_WEB_PATH + "/productPage";
    public static final String HREF_TO_CARTPAGE = PREFIX_WEB_PATH + "/cartPage";
    public static final String HREF_TO_CHECKOUTPAGE = PREFIX_WEB_PATH + "/checkoutPage";
    public static final String HREF_TO_ORDERHISTORY = PREFIX_WEB_PATH + "/orderHistory";
    public static final String HREF_TO_COMPARE = PREFIX_WEB_PATH + "/compare";
    public static final String HREF_TO_REGISTERPAGE = PREFIX_WEB_PATH + "/registerPage";
    public static final String HREF_TO_FORGOTPASSWORD = PREFIX_WEB_PATH + "/forgot-password";
    public static final String HREF_TO_CHANGEPASSWORD = PREFIX_WEB_PATH + "/changePassword";

    // JSP view paths (Internal — used by controllers to return view names)
    public static final String JSP_PATH_VIEW = "/WEB-INF/view/pages/";
    public static final String JSP_PATH_DASHBOARD = "/WEB-INF/view/dashboard/";

    // Dashboard
    public static final String JSP_DASHBOARDPAGE_PATH = JSP_PATH_DASHBOARD + "dashboard.jsp";
    public static final String JSP_USERMANAGEMENT_PATH = JSP_PATH_DASHBOARD + "userManagement/userManagement.jsp";
    public static final String JSP_PRODUCTMANAGEMENT_PATH = JSP_PATH_DASHBOARD
            + "productManagement/productManagement.jsp";
    public static final String JSP_ORDERMANAGEMENT_PATH = JSP_PATH_DASHBOARD + "orderManagement/orderManagement.jsp";
    public static final String JSP_VIEWSTAT_PATH = JSP_PATH_DASHBOARD + "statictis/viewStatictis.jsp";
    public static final String JSP_BRANDMANAGEMENT_PATH = JSP_PATH_DASHBOARD + "brandManagement/brandManagement.jsp";
    public static final String JSP_MANAGEBRAND_PATH = JSP_PATH_DASHBOARD + "brandManagement/manageBrand.jsp";
    public static final String JSP_CREATEBRAND_PATH = JSP_PATH_DASHBOARD + "brandManagement/createBrand.jsp";
    public static final String JSP_UPDATEBRAND_PATH = JSP_PATH_DASHBOARD + "brandManagement/updateBrand.jsp";
    public static final String JSP_CATEGORYMANAGEMENT_PATH = JSP_PATH_DASHBOARD + "categoryManagement/categoryManagement.jsp";
    public static final String JSP_CREATE_CATEGORY_PATH = JSP_PATH_DASHBOARD + "categoryManagement/createCategory.jsp";
    public static final String JSP_EDIT_CATEGORY_PATH = JSP_PATH_DASHBOARD + "categoryManagement/editCategory.jsp";
    public static final String JSP_MANAGE_CATEGORY_PATH = JSP_PATH_DASHBOARD + "categoryManagement/manageCategory.jsp";

    // User-facing pages
    public static final String JSP_LOGINPAGE_PATH = JSP_PATH_VIEW + "loginPage/loginPage.jsp";
    public static final String JSP_PROFILEPAGE_PATH = JSP_PATH_VIEW + "profilePage/profilePage.jsp";
    public static final String JSP_EDIT_PROFILEPAGE_PATH = JSP_PATH_VIEW + "profilePage/editProfilePage.jsp";
    public static final String JSP_CHANGE_PASSWORD_PATH = JSP_PATH_VIEW + "profilePage/changePasswordPage.jsp";
    public static final String JSP_HOMEPAGE_PATH = JSP_PATH_VIEW + "homePage/homePage.jsp";
    public static final String JSP_PRODUCTPAGE_PATH = JSP_PATH_VIEW + "productPage/productPage.jsp";
    public static final String JSP_PRODUCTDETAILPAGE_PATH = JSP_PATH_VIEW + "productPage/productDetail.jsp";
    public static final String JSP_CARTPAGE_PATH = JSP_PATH_VIEW + "cartPage/cartPage.jsp";
    public static final String JSP_CHECKOUTPAGE_PATH = JSP_PATH_VIEW + "checkoutPage/checkoutPage.jsp";
    public static final String JSP_ORDERHISTORY_PATH = JSP_PATH_VIEW + "orderHistoryPage/orderHistory.jsp";
    public static final String JSP_COMPARE_PATH = JSP_PATH_VIEW + "productPage/compareProduct.jsp";
    public static final String JSP_REGISTER_PAGE_PATH = JSP_PATH_VIEW + "registerPage/registerPage.jsp";
    public static final String JSP_REGISTER_THANKYOU_PATH = JSP_PATH_VIEW + "registerPage/thankYouPage.jsp";
    public static final String JSP_FORGOTPASSWORD_PAGE_PATH = JSP_PATH_VIEW + "forgotPasswordPage/forgotPasswordPage.jsp";
}
