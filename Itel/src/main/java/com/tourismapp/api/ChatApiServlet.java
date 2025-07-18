package com.tourismapp.api;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import org.json.JSONObject;
import org.apache.http.client.fluent.Request;
import org.apache.http.entity.ContentType;

@WebServlet(name = "ChatApiServlet", urlPatterns = {"/Itel/api/chat"})
public class ChatApiServlet extends HttpServlet {
    private static final String GEMINI_API_KEY = "GEMINI_API_KEY";
    private static final String GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=" + GEMINI_API_KEY;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        String userInput = new JSONObject(sb.toString()).optString("question", "");
        String answer = callGeminiApi(userInput);
        JSONObject json = new JSONObject();
        json.put("answer", answer);
        response.getWriter().write(json.toString());
    }

    private String callGeminiApi(String userInput) {
        try {
            JSONObject payload = new JSONObject();
            payload.put("contents", new org.json.JSONArray()
                .put(new JSONObject().put("parts", new org.json.JSONArray()
                    .put(new JSONObject().put("text", userInput))
                )));
            String resp = Request.Post(GEMINI_API_URL)
                .bodyString(payload.toString(), ContentType.APPLICATION_JSON)
                .connectTimeout(10000)
                .socketTimeout(20000)
                .execute()
                .returnContent()
                .asString();
            JSONObject respJson = new JSONObject(resp);
            if (respJson.has("candidates")) {
                JSONObject candidate = respJson.getJSONArray("candidates").getJSONObject(0);
                JSONObject content = candidate.getJSONObject("content");
                if (content.has("parts")) {
                    return content.getJSONArray("parts").getJSONObject(0).optString("text", "Xin lỗi, tôi không thể trả lời.");
                }
            }
            return "Xin lỗi, tôi không thể trả lời.";
        } catch (Exception e) {
            e.printStackTrace(); // Log lỗi chi tiết ra console
            return "Xin lỗi, đã có lỗi kỹ thuật: " + e.getMessage();
        }
    }
} 