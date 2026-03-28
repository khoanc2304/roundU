package com.tourismapp.controller.productController;

import com.tourismapp.config.ProjectPaths;
import com.tourismapp.entity.Product;
import com.tourismapp.service.product.IProductService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Controller
public class CompareController {

    @Autowired
    private IProductService productService;

    @GetMapping("/compareProduct")
    public String showComparePage(@RequestParam(value = "productIds", required = false) String productIds,
            HttpServletRequest request, HttpSession session) {
        if (productIds != null && !productIds.isEmpty()) {
            String[] ids = productIds.split("-");
            List<Product> compareProducts = Arrays.stream(ids)
                    .map(id -> {
                        try {
                            return Integer.parseInt(id);
                        } catch (Exception e) {
                            return null;
                        }
                    })
                    .filter(id -> id != null)
                    .map(productService::findProductById)
                    .flatMap(opt -> opt.map(Stream::of).orElseGet(Stream::empty))
                    .collect(Collectors.toList());

            Map<Product, List<String>> compareDetails = new LinkedHashMap<>();
            for (Product compareProduct : compareProducts) {
                List<String> productDetail = productService.getProductDetailByIdTop5(compareProduct.getProductId());
                compareDetails.put(compareProduct, productDetail);
            }

            session.setAttribute("compareDetails", compareDetails);
        }
        return ProjectPaths.JSP_COMPARE_PATH;
    }

    @PostMapping("/compareProduct")
    @ResponseBody
    @SuppressWarnings("unchecked")
    public void handleCompareAction(@RequestParam("action") String action,
            @RequestParam(value = "productId", required = false) String productId,
            HttpSession session, HttpServletResponse response) throws IOException {
        List<String> compareList = (List<String>) session.getAttribute("compareList");
        if (compareList == null) {
            compareList = new ArrayList<>();
        }

        if ("addCompare".equals(action) && productId != null && !compareList.contains(productId)) {
            if (compareList.size() < 3) {
                compareList.add(productId);
            }
        } else if ("removeCompare".equals(action) && productId != null) {
            compareList.remove(productId);
        } else if ("clearCompare".equals(action)) {
            compareList.clear();
        }

        session.setAttribute("compareList", compareList);

        response.setContentType("application/json");
        response.getWriter().write("{\"compareList\": ["
                + String.join(",", compareList.stream().map(id -> "\"" + id + "\"").toArray(String[]::new)) + "]}");
    }
}
