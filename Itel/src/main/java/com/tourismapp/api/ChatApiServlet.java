package com.tourismapp.api;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import org.json.JSONObject;
import org.json.JSONArray;
import org.apache.http.client.fluent.Request;
import org.apache.http.entity.ContentType;

// @WebServlet(name = "ChatApiServlet", urlPatterns = {"/Itel/api/chat"})
public class ChatApiServlet extends HttpServlet {
    private static final String GEMINI_API_KEY = "GEMINI_API_KEY";
    private static final String GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=" + GEMINI_API_KEY;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");
        
        JSONObject json = new JSONObject();
        json.put("status", "success");
        json.put("message", "Chat API is working!");
        json.put("timestamp", System.currentTimeMillis());
        
        response.getWriter().write(json.toString());
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("=== CHAT API CALLED ===");
        
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        
        // Xử lý CORS preflight request
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            response.setStatus(HttpServletResponse.SC_OK);
            return;
        }
        
        try {
            StringBuilder sb = new StringBuilder();
            try (BufferedReader reader = request.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
            }
            
            String requestBody = sb.toString();
            System.out.println("Request Body: " + requestBody);
            
            if (requestBody.isEmpty()) {
                sendErrorResponse(response, "Không có dữ liệu đầu vào");
                return;
            }
            
            JSONObject requestJson = new JSONObject(requestBody);
            String userInput = requestJson.optString("question", "").trim();
            
            System.out.println("User Input: " + userInput);
            
            if (userInput.isEmpty()) {
                sendErrorResponse(response, "Câu hỏi không được để trống");
                return;
            }
            
            if (userInput.length() > 1000) {
                sendErrorResponse(response, "Câu hỏi quá dài (tối đa 1000 ký tự)");
                return;
            }
            
            String answer = callGeminiApi(userInput);
            System.out.println("AI Answer: " + answer);
            sendSuccessResponse(response, answer);
            
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error in doPost: " + e.getMessage());
            sendErrorResponse(response, "Có lỗi xảy ra: " + e.getMessage());
        }
    }
    
    private void sendSuccessResponse(HttpServletResponse response, String answer) throws IOException {
        JSONObject json = new JSONObject();
        json.put("success", true);
        json.put("answer", answer);
        response.getWriter().write(json.toString());
    }
    
    private void sendErrorResponse(HttpServletResponse response, String errorMessage) throws IOException {
        JSONObject json = new JSONObject();
        json.put("success", false);
        json.put("error", errorMessage);
        response.getWriter().write(json.toString());
    }

    private String callGeminiApi(String userInput) {
        try {
            // Tạo payload đơn giản nhất có thể
            JSONObject payload = new JSONObject();
            JSONArray contents = new JSONArray();
            
            JSONObject content = new JSONObject();
            JSONArray parts = new JSONArray();
            
            JSONObject textPart = new JSONObject();
            textPart.put("text", userInput);
            parts.put(textPart);
            
            content.put("parts", parts);
            contents.put(content);
            payload.put("contents", contents);
            
            System.out.println("=== DEBUG INFO ===");
            System.out.println("API URL: " + GEMINI_API_URL);
            System.out.println("User Input: " + userInput);
            System.out.println("Payload: " + payload.toString());
            
            String resp = Request.Post(GEMINI_API_URL)
                .bodyString(payload.toString(), ContentType.APPLICATION_JSON)
                .connectTimeout(30000)
                .socketTimeout(30000)
                .execute()
                .returnContent()
                .asString();
                
            System.out.println("API Response: " + resp);
            System.out.println("=== END DEBUG ===");
            
            JSONObject respJson = new JSONObject(resp);
            
            // Kiểm tra lỗi từ API
            if (respJson.has("error")) {
                JSONObject error = respJson.getJSONObject("error");
                String errorMessage = error.optString("message", "Lỗi không xác định");
                System.err.println("Gemini API Error: " + errorMessage);
                return "Lỗi API: " + errorMessage;
            }
            
            if (respJson.has("candidates") && respJson.getJSONArray("candidates").length() > 0) {
                JSONObject candidate = respJson.getJSONArray("candidates").getJSONObject(0);
                JSONObject contentObj = candidate.getJSONObject("content");
                
                if (contentObj.has("parts") && contentObj.getJSONArray("parts").length() > 0) {
                    String answer = contentObj.getJSONArray("parts").getJSONObject(0).optString("text", "");
                    if (!answer.isEmpty()) {
                        return answer.trim();
                    }
                }
            }
            
            return "Không nhận được phản hồi từ AI. Response: " + resp;
            
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Exception in callGeminiApi: " + e.getMessage());
            return "Exception: " + e.getMessage();
        }
    }
} 