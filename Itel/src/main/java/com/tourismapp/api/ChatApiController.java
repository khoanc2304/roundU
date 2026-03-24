package com.tourismapp.api;

import com.tourismapp.service.chat.ChatDatabaseService;
import com.tourismapp.service.chat.ChatDatabaseService.DatabaseResponse;
import org.apache.http.client.fluent.Request;
import org.apache.http.entity.ContentType;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/Itel/api/chat")
@CrossOrigin(origins = "*", methods = {RequestMethod.POST, RequestMethod.GET, RequestMethod.OPTIONS}, allowedHeaders = "Content-Type")
public class ChatApiController {

    private static final String GEMINI_API_KEY = "AIzaSyAQOhALT1ZFY8t80YSXmEIZ54AKZK_3WSA";
    private static final String GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=" + GEMINI_API_KEY;
    private final ChatDatabaseService chatDatabaseService = new ChatDatabaseService();

    @GetMapping
    public Map<String, Object> handleGet() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "success");
        response.put("message", "Chat API is working!");
        response.put("timestamp", System.currentTimeMillis());
        return response;
    }

    @PostMapping
    public Map<String, Object> handlePost(@RequestBody(required = false) Map<String, String> requestBody) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            if (requestBody == null || !requestBody.containsKey("question")) {
                response.put("success", false);
                response.put("error", "Không có dữ liệu đầu vào");
                return response;
            }

            String userInput = requestBody.get("question").trim();

            if (userInput.isEmpty()) {
                response.put("success", false);
                response.put("error", "Câu hỏi không được để trống");
                return response;
            }

            if (userInput.length() > 1000) {
                response.put("success", false);
                response.put("error", "Câu hỏi quá dài (tối đa 1000 ký tự)");
                return response;
            }

            DatabaseResponse dbResponse = chatDatabaseService.analyzeQuestion(userInput);

            String answer;
            if (dbResponse.hasData()) {
                String enhancedPrompt = chatDatabaseService.createAIPrompt(userInput, dbResponse);
                answer = callGeminiApi(enhancedPrompt);
            } else {
                answer = callGeminiApi(userInput);
            }

            response.put("success", true);
            response.put("answer", answer);

        } catch (Exception e) {
            response.put("success", false);
            response.put("error", "Có lỗi xảy ra: " + e.getMessage());
        }

        return response;
    }

    private String callGeminiApi(String userInput) {
        try {
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

            String resp = Request.Post(GEMINI_API_URL)
                    .bodyString(payload.toString(), ContentType.APPLICATION_JSON)
                    .connectTimeout(30000)
                    .socketTimeout(30000)
                    .execute()
                    .returnContent()
                    .asString();

            JSONObject respJson = new JSONObject(resp);

            if (respJson.has("error")) {
                JSONObject error = respJson.getJSONObject("error");
                String errorMessage = error.optString("message", "Lỗi không xác định");
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
            return "Exception: " + e.getMessage();
        }
    }
}
