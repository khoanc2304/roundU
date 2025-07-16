package com.tourismapp.config;

import com.tourismapp.controller.mainController.MainControllerServlet;

/**
 *
 * @author LENOVO
 */
public class ProjectPaths {

    // JPS pages -> main controllerServlet
    public static final String PREFIX_WEB_PATH = "/Itel";
    public static final String HREF_TO_MAINCONTROLLER = PREFIX_WEB_PATH + "/main?action=";
    // dashboard
    public static final String HREF_TO_DASHBOARDPAGE = HREF_TO_MAINCONTROLLER + MainControllerServlet.DASHBOARDPAGE_REDIRECT;
    public static final String HREF_TO_USERMANAGEMENT = HREF_TO_MAINCONTROLLER + MainControllerServlet.USER_MANAGEMENT_REDIRECT;
    public static final String HREF_TO_BRANDMANAGEMENT = HREF_TO_MAINCONTROLLER + MainControllerServlet.BRAND_MANAGEMENT_REDIRECT;
    public static final String HREF_TO_CATEGORYMANAGEMENT = HREF_TO_MAINCONTROLLER + MainControllerServlet.CATEGORY_MANAGEMENT_REDIRECT;
    public static final String HREF_TO_PRODUCTMANAGEMENT = HREF_TO_MAINCONTROLLER + MainControllerServlet.PRODUCT_MANAGEMENT_REDIRECT;
    public static final String HREF_TO_ORDERMANAGEMENT = HREF_TO_MAINCONTROLLER + MainControllerServlet.ORDER_MANAGEMENT_REDIRECT;

    // user view
    public static final String HREF_TO_LOGINPAGE = HREF_TO_MAINCONTROLLER + MainControllerServlet.LOGINPAGE_REDIRECT;
    public static final String HREF_TO_LOGOUTPAGE = HREF_TO_MAINCONTROLLER + MainControllerServlet.LOGOUTPAGE_REDIRECT;
    public static final String HREF_TO_PROFILEPAGE = HREF_TO_MAINCONTROLLER + MainControllerServlet.PROFILEPAGE_REDIRECT;
    public static final String HREF_TO_PRODUCTPAGE = HREF_TO_MAINCONTROLLER + MainControllerServlet.PRODUCTPAGE_REDIRECT;
    public static final String HREF_TO_HOMEPAGE = HREF_TO_MAINCONTROLLER + MainControllerServlet.HOMEPAGE_REDIRECT;
    public static final String HREF_TO_CARTPAGE = HREF_TO_MAINCONTROLLER + MainControllerServlet.CARTPAGE_REDIRECT;
    public static final String HREF_TO_CHECKOUTPAGE = HREF_TO_MAINCONTROLLER + MainControllerServlet.CHECKOUTPAGE_REDIRECT;
    public static final String HREF_TO_ORDERHISTORY = HREF_TO_MAINCONTROLLER + MainControllerServlet.ORDERHISTORY_REDIRECT;
    public static final String HREF_TO_COMPARE = HREF_TO_MAINCONTROLLER + MainControllerServlet.COMPARE_REDIRECT;

    // RedirectServlets -> JSP pages
    public static final String JSP_PATH_VIEW = "/WEB-INF/view/pages/";
    public static final String JSP_PATH_DASHBOARD = "/WEB-INF/view/dashboard/";
//    public static final String JSP_DASHBOARDPAGE_PATH = "/WEB-INF/view/dashboard/dashboard.jsp";
    public static final String JSP_DASHBOARDPAGE_PATH = JSP_PATH_DASHBOARD + "dashboard.jsp";

    //user view
    public static final String JSP_LOGINPAGE_PATH = JSP_PATH_VIEW + "loginPage/loginPage.jsp";
    public static final String JSP_PROFILEPAGE_PATH = JSP_PATH_VIEW + "profilePage/profilePage.jsp";
    public static final String JSP_HOMEPAGE_PATH = JSP_PATH_VIEW + "homePage/homePage.jsp";
    public static final String JSP_PRODUCTPAGE_PATH = JSP_PATH_VIEW + "productPage/productPage.jsp";
    public static final String JSP_PRODUCTDETAILPAGE_PATH = JSP_PATH_VIEW + "productPage/productDetail.jsp";
    public static final String JSP_CARTPAGE_PATH = JSP_PATH_VIEW + "cartPage/cartPage.jsp";
    public static final String JSP_CHECKOUTPAGE_PATH = JSP_PATH_VIEW + "checkoutPage/checkoutPage.jsp";
    public static final String JSP_ORDERHISTORY_PATH = JSP_PATH_VIEW + "orderHistoryPage/orderHistory.jsp";
    public static final String JSP_COMPARE_PATH = JSP_PATH_VIEW + "productPage/compareProduct.jsp";

    // KHOA
    public static final String JSP_PRODUCTMANAGEMENT_PATH = JSP_PATH_DASHBOARD + "productManagement/productManagement.jsp";

    
    // NAM
    public static final String JSP_ORDERMANAGEMENT_PATH = JSP_PATH_DASHBOARD + "orderManagement/orderManagement.jsp";
    public static final String JSP_VIEWSTAT_PATH = JSP_PATH_DASHBOARD + "statictis/viewStatictis.jsp";
    
    // HUY
    public static final String JSP_USERMANAGEMENT_PATH = JSP_PATH_DASHBOARD + "userManagement/userManagement.jsp";

    public static final String JSP_EDIT_PROFILEPAGE_PATH = "/WEB-INF/view/pages/profilePage/editProfilePage.jsp";
    
    // NAM
    public static final String JSP_BRANDMANAGEMENT_PATH = JSP_PATH_DASHBOARD + "brandManagement/brandManagement.jsp";
    public static final String JSP_MANAGEBRAND_PATH = JSP_PATH_DASHBOARD + "brandManagement/manageBrand.jsp";
    public static final String JSP_CREATEBRAND_PATH = JSP_PATH_DASHBOARD + "brandManagement/createBrand.jsp";
    public static final String JSP_UPDATEBRAND_PATH = JSP_PATH_DASHBOARD + "brandManagement/updateBrand.jsp";

    
    // VINH
    public static final String JSP_CATEGORYMANAGEMENT_PATH = JSP_PATH_DASHBOARD + "categoryManagement/categoryManagement.jsp";
    public static final String JSP_CREATE_CATEGORY_PATH = JSP_PATH_DASHBOARD + "categoryManagement/createCategory.jsp";  // For creating a new category
    public static final String JSP_EDIT_CATEGORY_PATH = JSP_PATH_DASHBOARD + "categoryManagement/editCategory.jsp";      // For editing an existing category
    public static final String JSP_MANAGE_CATEGORY_PATH = JSP_PATH_DASHBOARD + "categoryManagement/manageCategory.jsp"; // For managing categories
    
}
