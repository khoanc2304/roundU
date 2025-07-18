package com.tourismapp.controller.chatController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import com.fasterxml.jackson.databind.ObjectMapper;

@WebServlet("/ChatHistoryServlet")
public class ChatHistoryServlet extends HttpServlet {
    private static final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("userId");
        List<ChatHistory> history = new ArrayList<>();

        try (Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;databaseName=Itel_Shop;user=sa;password=123456")) {
            String sql = "SELECT sender, message, timestamp FROM Chat_History WHERE (sender = ? OR receiver = ?) AND receiver = 'admin'";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, userId);
            stmt.setString(2, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String sender = rs.getString("sender");
                String message = rs.getString("message");
                Timestamp timestamp = rs.getTimestamp("timestamp");
                String timestampStr = (timestamp != null) ? timestamp.toLocalDateTime().toString() : ""; // Định dạng timestamp
                history.add(new ChatHistory(sender, message, timestampStr));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
            return;
        }

        response.setContentType("application/json");
        objectMapper.writeValue(response.getWriter(), history);
    }

    private static class ChatHistory {
        private String sender;
        private String message;
        private String timestamp;

        ChatHistory(String sender, String message, String timestamp) {
            this.sender = sender;
            this.message = message;
            this.timestamp = timestamp;
        }

        public String getSender() { return sender; }
        public String getMessage() { return message; }
        public String getTimestamp() { return timestamp; }
    }
}