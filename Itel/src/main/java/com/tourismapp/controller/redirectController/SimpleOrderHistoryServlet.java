package com.tourismapp.controller.redirectController;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import com.tourismapp.model.Orders;
import com.tourismapp.model.Users;
import com.tourismapp.service.order.OrderService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Simple Order History Servlet for debugging
 * @author Admin
 */
@WebServlet(name = "SimpleOrderHistoryServlet", urlPatterns = {"/simpleOrderHistory"})
public class SimpleOrderHistoryServlet extends HttpServlet {
    
    private final OrderService orderService = new OrderService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            out.println("<!DOCTYPE html>");
            out.println("<html><head><title>Simple Order History Test</title></head><body>");
            out.println("<h2>Simple Order History Debug</h2>");
            
            HttpSession session = request.getSession();
            Users user = (Users) session.getAttribute("loggedUser");
            
            out.println("<p><strong>User from session:</strong> " + (user != null ? user.getFullName() + " (ID: " + user.getUserId() + ")" : "NULL") + "</p>");
            
            if (user == null) {
                out.println("<p style='color:red'>No user in session!</p>");
                out.println("<a href='/Itel/main?action=loginPage'>Login</a>");
            } else {
                out.println("<p>Calling OrderService...</p>");
                
                List<Orders> orders = orderService.getOrdersByUserId(user.getUserId());
                
                out.println("<p><strong>Orders found:</strong> " + (orders != null ? orders.size() : "NULL") + "</p>");
                
                if (orders != null && !orders.isEmpty()) {
                    out.println("<table border='1'>");
                    out.println("<tr><th>Order ID</th><th>Status</th><th>Amount</th><th>Date</th><th>Details</th></tr>");
                    
                    for (Orders order : orders) {
                        out.println("<tr>");
                        out.println("<td>" + order.getOrderId() + "</td>");
                        out.println("<td>" + order.getStatus() + "</td>");
                        out.println("<td>" + order.getTotalAmount() + "</td>");
                        out.println("<td>" + order.getOrderDate() + "</td>");
                        out.println("<td>" + (order.getOrderDetails() != null ? order.getOrderDetails().size() : "NULL") + "</td>");
                        out.println("</tr>");
                    }
                    
                    out.println("</table>");
                } else {
                    out.println("<p style='color:orange'>No orders found for user " + user.getUserId() + "</p>");
                }
            }
            
            out.println("<hr>");
            out.println("<a href='/Itel/main?action=orderHistory'>Try Original OrderHistory</a><br>");
            out.println("<a href='/Itel/orderHistory'>Try Direct OrderHistory</a><br>");
            out.println("<a href='/Itel/main?action=homePage'>Home</a>");
            out.println("</body></html>");
            
        } catch (Exception e) {
            out.println("<p style='color:red'>ERROR: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        } finally {
            out.close();
        }
    }
}
