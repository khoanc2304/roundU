package com.tourismapp.exception;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;
import jakarta.servlet.http.HttpServletRequest;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(org.springframework.dao.DataAccessException.class)
    public ModelAndView handleDatabaseExceptions(org.springframework.dao.DataAccessException ex, HttpServletRequest request) {
        ex.printStackTrace();
        ModelAndView mav = new ModelAndView();
        mav.addObject("exception", ex);
        mav.addObject("url", request.getRequestURL());
        mav.addObject("errorMessage", "Lỗi máy chủ cơ sở dữ liệu. Vui lòng thử lại sau.");
        mav.setViewName("/WEB-INF/view/pages/errorPage/error.jsp");
        return mav;
    }

    @ExceptionHandler(Exception.class)
    public ModelAndView handleAllExceptions(Exception ex, HttpServletRequest request) {
        ex.printStackTrace();
        ModelAndView mav = new ModelAndView();
        mav.addObject("exception", ex);
        mav.addObject("url", request.getRequestURL());
        mav.addObject("errorMessage", "Hệ thống đang gặp sự cố: " + ex.getMessage());
        mav.setViewName("/WEB-INF/view/pages/errorPage/error.jsp");
        return mav;
    }
}
