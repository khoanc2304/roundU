package com.tourismapp.controller.chatController;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/ChatHistoryServlet")
public class ChatHistoryController {

    @GetMapping
    public List<ChatHistory> getChatHistory(@RequestParam(value = "userId", required = false) String userId) {
        List<ChatHistory> history = new ArrayList<>();

        if (userId == null) {
            return history;
        }

        try (Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;databaseName=Itel_Shop;user=sa;password=123456")) {
            String sql = "SELECT sender, message, timestamp FROM Chat_History WHERE (sender = ? OR receiver = ?) AND receiver = 'admin'";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, userId);
                stmt.setString(2, userId);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        String sender = rs.getString("sender");
                        String message = rs.getString("message");
                        Timestamp timestamp = rs.getTimestamp("timestamp");
                        String timestampStr = (timestamp != null) ? timestamp.toLocalDateTime().toString() : "";
                        history.add(new ChatHistory(sender, message, timestampStr));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error: " + e.getMessage());
        }

        return history;
    }

    private static class ChatHistory {
        private String sender;
        private String message;
        private String timestamp;

        public ChatHistory(String sender, String message, String timestamp) {
            this.sender = sender;
            this.message = message;
            this.timestamp = timestamp;
        }

        public String getSender() { return sender; }
        public String getMessage() { return message; }
        public String getTimestamp() { return timestamp; }
    }
}
