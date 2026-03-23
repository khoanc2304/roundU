package com.tourismapp.controller.chatController;

import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import org.json.JSONObject;

@ServerEndpoint("/chat")
public class ChatServlet {
    private static Set<Session> customers = Collections.synchronizedSet(new HashSet<>());
    private static Set<Session> staff = Collections.synchronizedSet(new HashSet<>());
    private static Set<String> customerIds = Collections.synchronizedSet(new HashSet<>());

    @OnOpen
    public void onOpen(Session session) throws IOException {
        String role = session.getRequestParameterMap().get("role").get(0);
        String userId = session.getRequestParameterMap().get("userId").get(0);
        if ("customer".equals(role)) {
            customers.add(session);
            customerIds.add(userId);
            broadcastCustomerList();
        } else if ("staff".equals(role)) {
            staff.add(session);
            session.getBasicRemote().sendText("{\"type\":\"customerList\",\"customers\":" + new java.util.ArrayList<>(customerIds) + "}");
        }
    }

    @OnMessage
    public void onMessage(String message, Session session) throws IOException {
        JSONObject json = new JSONObject(message);
        String type = json.getString("type");
        String timestamp = json.has("timestamp") ? json.getString("timestamp") : LocalDateTime.now().toString();

        if ("message".equals(type)) {
            String role = json.getString("role");
            String userId = json.getString("userId");
            String msg = json.getString("message");
            String target = json.has("target") ? json.getString("target") : "admin";

            saveMessageToDatabase(userId, target, msg, timestamp);

            if ("customer".equals(role)) {
                for (Session staffSession : staff) {
                    if (staffSession.isOpen()) {
                        staffSession.getBasicRemote().sendText("{\"type\":\"message\",\"sender\":\"" + userId + "\",\"message\":\"" + msg + "\",\"timestamp\":\"" + timestamp + "\"}");
                    }
                }
            } else if ("staff".equals(role)) {
                for (Session customerSession : customers) {
                    if (customerSession.isOpen() && customerSession.getRequestParameterMap().get("userId").get(0).equals(target)) {
                        customerSession.getBasicRemote().sendText("{\"type\":\"message\",\"sender\":\"Admin\",\"message\":\"" + msg + "\",\"timestamp\":\"" + timestamp + "\"}");
                    }
                }
            }
        }
    }

    @OnClose
    public void onClose(Session session) throws IOException {
        String role = session.getRequestParameterMap().get("role").get(0);
        String userId = session.getRequestParameterMap().get("userId").get(0);
        if ("customer".equals(role)) {
            customers.remove(session);
            customerIds.remove(userId);
            broadcastCustomerList();
        } else if ("staff".equals(role)) {
            staff.remove(session);
        }
    }

    private void broadcastCustomerList() throws IOException {
        for (Session staffSession : staff) {
            if (staffSession.isOpen()) {
                staffSession.getBasicRemote().sendText("{\"type\":\"customerList\",\"customers\":" + new java.util.ArrayList<>(customerIds) + "}");
            }
        }
    }

    private void saveMessageToDatabase(String sender, String receiver, String message, String timestamp) {
        try (Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;databaseName=Itel_Shop;user=sa;password=1234567")) {
            String sql = "INSERT INTO Chat_History (sender, receiver, message, timestamp) VALUES (?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, sender);
            stmt.setString(2, receiver);
            stmt.setString(3, message);
            stmt.setTimestamp(4, java.sql.Timestamp.valueOf(LocalDateTime.parse(timestamp, java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"))));
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}