package com.tourismapp.filter;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.tourismapp.controller.mainController.MainControllerServlet;
import com.tourismapp.utils.ErrDialog;

@WebFilter({"/main", "/userManagement", "/orderManagement", "/brandManagement", "/categoryManagement"})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String action = req.getParameter("action");
//        ErrDialog.showError("Filter action: " + action);
        if (action != null
                && (action.equals(MainControllerServlet.ACTION_LOGIN)
                || action.equals(MainControllerServlet.HOMEPAGE_REDIRECT)
                || action.equals(MainControllerServlet.PRODUCTPAGE_REDIRECT)
                || action.equals(MainControllerServlet.CARTPAGE_REDIRECT)
                || action.equals(MainControllerServlet.FORGOTPASSWORD_REDIRECT)
                || action.equals(MainControllerServlet.REGISTERPAGE_REDIRECT)
                || action.equals(MainControllerServlet.ACTION_FORGOT_PASSWORD)
                || action.equals(MainControllerServlet.ACTION_SEARCH_ACTIVE_PRODUCT)
                || action.equalsIgnoreCase("verifyOtp"))) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            res.sendRedirect(MainControllerServlet.LOGINPAGE_REDIRECT);
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
