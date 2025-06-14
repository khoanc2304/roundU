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
import com.tourismapp.service.brand.BrandService;
import com.tourismapp.service.brand.IBrandService;
import com.tourismapp.utils.ErrDialog;
import java.util.List;

/**
 *
 * @author LENOVO
 */
@WebServlet(name = "BrandManagementServlet", urlPatterns = {MainControllerServlet.BRAND_MANAGEMENT_SERVLET})
public class BrandManagementServlet extends HttpServlet {

    private IBrandService brandService;

    @Override
    public void init() throws ServletException {
        brandService = new BrandService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
//        ErrDialog.showError("brand management action: " + action);
        switch (action) {
//            case MainControllerServlet.BRAND_MANAGEMENT_REDIRECT:
//                handleManageBrand(request, response);
//                break;
            case MainControllerServlet.ACTION_MANAGE_BRAND:
                handleManageBrand(request, response);
                break;
            case MainControllerServlet.ACTION_FIND_BRAND:
                handleFindBrand(request, response);
                break;
            case MainControllerServlet.ACTION_NAVIGATE_TO_CREATE_BRAND:
                handleNavigateToCreateBrand(request, response);
                break;
            case MainControllerServlet.ACTION_NAVIGATE_TO_UPDATE_BRAND:
                handleNavigateToUpdateBrand(request, response);
                break;
            default:
                handleManageBrandAction(request, response);
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action") != null ? request.getParameter("action").trim() : "";
        ErrDialog.showError("brand management action error: " + action);
        switch (action) {
            case MainControllerServlet.ACTION_CREATE_BRAND:
                handleCreateBrand(request, response);
                break;
            case MainControllerServlet.ACTION_EDIT_BRAND:
                handleEditBrand(request, response);
                break;
            case MainControllerServlet.ACTION_DELETE_BRAND:
                handleDeleteBrand(request, response);
                break;
            default:
                handleManageBrand(request, response);
        }

    }

    // <editor-fold defaultstate="collapsed" desc=" functional ... ">
    // doGet methods
    private void handleManageBrandAction(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        ErrDialog.showError("Entering handleManageBrandAction");
        List<Brand> brandList = brandService.getAllBrands();
        for (Brand brand : brandList) {
            brand.setProductList(brandService.getProductsByBrandId(brand.getBrandId()));
        }
        request.setAttribute("brands", brandList);
        request.getRequestDispatcher(ProjectPaths.JSP_MANAGEBRAND_PATH).forward(request, response);
    }

    private void handleManageBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String country = request.getParameter("country");
        List<Brand> brandList;
        if (country != null && !country.isEmpty()) {
            brandList = brandService.findBrandsByCountry(country);
        } else {
            brandList = brandService.getAllBrands();
        }
//        ErrDialog.showError("size brand list: " + brandList.size());
        request.setAttribute("brands", brandList);
        request.getRequestDispatcher(ProjectPaths.JSP_BRANDMANAGEMENT_PATH).forward(request, response);
    }

    private void handleFindBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchName = request.getParameter("searchName");
        if (searchName != null && !searchName.trim().isEmpty()) {
            List<Brand> brands = brandService.findBrandsByName(searchName);
            request.setAttribute("brands", brands);
        } else {
            request.setAttribute("error", "Search name cannot be empty");
        }
        request.getRequestDispatcher(ProjectPaths.JSP_BRANDMANAGEMENT_PATH).forward(request, response);
    }

    // doPost methods
    private void handleCreateBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Brand brand = new Brand(
                0,
                request.getParameter("name"),
                request.getParameter("country"),
                request.getParameter("description"),
                request.getParameter("imageUrl"),
                request.getParameter("status") != null && !request.getParameter("status").isEmpty()
                ? Status.valueOf(request.getParameter("status")) : null
        );
        brandService.createBrand(brand);
        response.sendRedirect(request.getContextPath() + "/main?action=" + MainControllerServlet.BRAND_MANAGEMENT_REDIRECT);
    }

    private void handleEditBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Brand brandUpdate = new Brand(
                Integer.parseInt(request.getParameter("brandId")),
                request.getParameter("name"),
                request.getParameter("country"),
                request.getParameter("description"),
                request.getParameter("imageUrl"),
                Status.valueOf(request.getParameter("status"))
        );
        brandService.updateBrand(brandUpdate);
        response.sendRedirect(request.getContextPath() + "/main?action=" + MainControllerServlet.BRAND_MANAGEMENT_REDIRECT);
    }

    private void handleDeleteBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int brandId = Integer.parseInt(request.getParameter("brandId"));
        brandService.deleteBrand(brandId);
        response.sendRedirect(request.getContextPath() + "/main?action=" + MainControllerServlet.BRAND_MANAGEMENT_REDIRECT);
    }

    private void handleNavigateToCreateBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        ErrDialog.showError("Navigating to create brand with action: " + request.getParameter("action"));
        request.getRequestDispatcher(ProjectPaths.JSP_CREATEBRAND_PATH).forward(request, response);
    }

    private void handleNavigateToUpdateBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        ErrDialog.showError("Navigating to create brand with action: " + request.getParameter("action"));
        int brandId = Integer.parseInt(request.getParameter("brandId"));
        Brand brand = brandService.getBrandById(brandId);
        if (brand == null) {
            request.setAttribute("error", "Brand not found");
            request.getRequestDispatcher(ProjectPaths.JSP_BRANDMANAGEMENT_PATH).forward(request, response);
        } else {
            request.setAttribute("brand", brand);
            request.getRequestDispatcher(ProjectPaths.JSP_UPDATEBRAND_PATH).forward(request, response);
        }
    }

    // </editor-fold>
}
