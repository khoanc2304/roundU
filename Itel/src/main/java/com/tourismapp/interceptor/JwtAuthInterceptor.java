package com.tourismapp.interceptor;

import com.tourismapp.annotation.RequiresRole;
import com.tourismapp.common.UserRole;
import com.tourismapp.config.ProjectPaths;
import com.tourismapp.entity.Users;
import com.tourismapp.service.user.IUserService;
import com.tourismapp.utils.JwtTokenProvider;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;

public class JwtAuthInterceptor implements HandlerInterceptor {

    @Autowired
    private JwtTokenProvider jwtTokenProvider;

    @Autowired
    private IUserService userService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        String jwt = null;
        if (request.getCookies() != null) {
            for (Cookie cookie : request.getCookies()) {
                if ("JWT_TOKEN".equals(cookie.getName())) {
                    jwt = cookie.getValue();
                    break;
                }
            }
        }

        if (jwt != null && jwtTokenProvider.validateToken(jwt)) {
            Integer userId = jwtTokenProvider.getUserIdFromJWT(jwt);
            Users user = userService.getUserById(userId);
            if (user != null) {
                request.setAttribute("loggedUser", user);
                request.setAttribute("user", user);
            }
        }

        if (handler instanceof HandlerMethod handlerMethod) {
            RequiresRole requiresRoleInfo = handlerMethod.getMethodAnnotation(RequiresRole.class);
            if (requiresRoleInfo == null) {
                requiresRoleInfo = handlerMethod.getBeanType().getAnnotation(RequiresRole.class);
            }

            if (requiresRoleInfo != null) {
                Users loggedUser = (Users) request.getAttribute("loggedUser");
                if (loggedUser == null) {
                    // Not auth, redirect to Login
                    response.sendRedirect(request.getContextPath()
                            + ProjectPaths.HREF_TO_LOGINPAGE.substring(ProjectPaths.PREFIX_WEB_PATH.length()));
                    return false;
                }

                UserRole[] allowedRoles = requiresRoleInfo.value();
                boolean hasRole = false;
                for (UserRole role : allowedRoles) {
                    if (loggedUser.getRole() == role) {
                        hasRole = true;
                        break;
                    }
                }

                if (!hasRole) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN,
                            "Forbidden: You do not have the required role to access this resource.");
                    return false;
                }
            }
        }

        return true;
    }
}
