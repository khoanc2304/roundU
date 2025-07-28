package com.tourismapp.controller.redirectController;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;
import com.tourismapp.model.Cart;
import com.tourismapp.model.Users;
import com.tourismapp.service.user.IUserService;
import com.tourismapp.service.user.UserService;

/**
 *
 * @author LENOVO
 */
@WebServlet(name = "CartPageServlet", urlPatterns = {MainControllerServlet.CARTPAGE_SERVLET})
public class CartPageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get cart from session
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }
        
        // Get user from session
        Users user = (Users) session.getAttribute("user");
        
        // If user is logged in, reload the latest user info from the database
        if (user != null) {
            IUserService userService = new UserService();
            Users updatedUser = userService.getUserById(user.getUserId());
            if (updatedUser != null) {
                session.setAttribute("user", updatedUser);
                user = updatedUser;
            }
        }
        
        // Set cart as request attribute for JSP
        request.setAttribute("cart", cart);
        
        request.getRequestDispatcher(ProjectPaths.JSP_CARTPAGE_PATH).forward(request, response);
    }

    // <editor-fold defaultstate="collapsed" desc=" functional ... ">
    
    // </editor-fold>
}
