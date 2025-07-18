//package com.tourismapp.controller.paymentController;
//
//import com.tourismapp.utils.MailUtil;
//import jakarta.mail.MessagingException;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//import java.io.IOException;
//
//@WebServlet(name = "BankTransferNotifyServlet", urlPatterns = {"/bankTransferNotify"})
//public class BankTransferNotifyServlet extends HttpServlet {
//    // Thay đổi email admin tại đây
//    private static final String ADMIN_EMAIL = "admin@gmail.com";
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        String orderId = request.getParameter("orderId");
//        HttpSession session = request.getSession();
//        String userEmail = (String) session.getAttribute("userEmail"); // hoặc lấy từ loggedUser
//        try {
//            String subject = "[Itel Shop] User đã chuyển khoản cho đơn hàng #" + orderId;
//            String content = "Khách hàng vừa báo đã chuyển khoản cho đơn hàng #" + orderId + ".<br>" +
//                    "Vui lòng kiểm tra tài khoản ngân hàng và xác nhận đơn hàng trên hệ thống.";
//            try {
//                MailUtil.sendMail(ADMIN_EMAIL, subject, content);
//            } catch (MessagingException | java.io.UnsupportedEncodingException e) {
//                System.err.println("Gửi email thông báo admin thất bại: " + e.getMessage());
//            }
//        } catch (Exception e) {
//            System.err.println("Lỗi xử lý thông báo chuyển khoản: " + e.getMessage());
//        }
//        response.sendRedirect(request.getContextPath() + "/main?action=orderHistory");
//    }
//} 