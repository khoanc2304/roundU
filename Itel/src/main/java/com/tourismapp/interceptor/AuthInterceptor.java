package com.tourismapp.interceptor;

import com.tourismapp.annotation.RequiresRole;
import com.tourismapp.common.UserRole;
import com.tourismapp.config.ProjectPaths;
import com.tourismapp.entity.Users;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;

public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        if (handler instanceof HandlerMethod handlerMethod) {
            RequiresRole requiresRoleInfo = handlerMethod.getMethodAnnotation(RequiresRole.class);
            if (requiresRoleInfo == null) {
                requiresRoleInfo = handlerMethod.getBeanType().getAnnotation(RequiresRole.class);
            }

            if (requiresRoleInfo != null) {
                HttpSession session = request.getSession(false);
                if (session == null || session.getAttribute("loggedUser") == null) {
                    response.sendRedirect(request.getContextPath() + ProjectPaths.HREF_TO_LOGINPAGE.substring(ProjectPaths.PREFIX_WEB_PATH.length()));
                    return false;
                }

                Users user = (Users) session.getAttribute("loggedUser");
                UserRole[] allowedRoles = requiresRoleInfo.value();
                
                boolean hasRole = false;
                for (UserRole role : allowedRoles) {
                    if (user.getRole() == role) {
                        hasRole = true;
                        break;
                    }
                }

                if (!hasRole) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Forbidden: You do not have the required role to access this resource.");
                    return false;
                }
            }
        }
        return true;
    }
}
