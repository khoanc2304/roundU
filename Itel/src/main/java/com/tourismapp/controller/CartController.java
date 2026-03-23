package com.tourismapp.controller;

import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;
import com.tourismapp.model.Cart;
import com.tourismapp.model.Users;
import com.tourismapp.service.user.IUserService;
import com.tourismapp.service.user.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping(MainControllerServlet.CARTPAGE_SERVLET)
public class CartController {

    private final IUserService userService = new UserService();

    @RequestMapping(method = {RequestMethod.GET, RequestMethod.POST})
    public String handleCart(HttpServletRequest request, HttpSession session) {
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        Users user = (Users) session.getAttribute("user");
        if (user != null) {
            Users updatedUser = userService.getUserById(user.getUserId());
            if (updatedUser != null) {
                session.setAttribute("user", updatedUser);
            }
        }

        request.setAttribute("cart", cart);
        return ProjectPaths.JSP_CARTPAGE_PATH;
    }
}
