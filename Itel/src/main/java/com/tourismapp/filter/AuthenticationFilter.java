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

@WebFilter("/mainMMM")
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo nếu cần thiết
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String action = req.getParameter("action");
        if (action != null && action.equals(MainControllerServlet.ACTION_LOGIN)) {
            chain.doFilter(request, response); // Cho phép request đi qua
            return;
        }
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect(MainControllerServlet.LOGINPAGE_REDIRECT);
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Dọn dẹp nếu cần thiết
    }
}