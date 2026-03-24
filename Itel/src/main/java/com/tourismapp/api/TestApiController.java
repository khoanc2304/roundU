package com.tourismapp.api;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/test")
public class TestApiController {

    @GetMapping
    public String handleGet() {
        return "<h1>Test Servlet is working!</h1>";
    }

    @PostMapping
    public Map<String, String> handlePost() {
        Map<String, String> response = new HashMap<>();
        response.put("status", "success");
        response.put("message", "Test POST is working!");
        return response;
    }
}
