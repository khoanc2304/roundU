package com.tourismapp.controller.redirectController;

import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;
import com.tourismapp.model.Product;
import com.tourismapp.model.ProductImage;
import com.tourismapp.service.product.IProductService;
import com.tourismapp.service.product.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@WebServlet(name = "ProductPageServlet", urlPatterns = {MainControllerServlet.PRODUCTPAGE_SERVLET})
public class ProductPageServlet extends HttpServlet {

    private final IProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }
        showActiveProductDetail(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(ProjectPaths.JSP_HOMEPAGE_PATH).forward(request, response);
    }

// <editor-fold defaultstate="collapsed" desc=" functional ... ">
    private void showActiveProductDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số ID product");
            return;
        }
        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID không hợp lệ");
            return;
        }
        // if product actived -> product no hidden
        Optional<Product> product = productService.findProductById(id);
        Optional<List<ProductImage>> productImages = productService.getProductImagesById(id);
        Map<String, String> infoProduct = productService.getInforProductById(id);

        //HUY: LAY SAN PHAM THEO GIA
        List<Product> similarProducts = new ArrayList<>();

// Ưu tiên cùng loại
        similarProducts.addAll(productService.getSimilarProductsByCategory(
                product.get().getCategory().getCategoryId(),
                product.get().getProductId(),
                4
        ));

// Nếu chưa đủ, lấy theo giá
        if (similarProducts.size() < 4) {
            int missing = 4 - similarProducts.size();
            List<Product> priceProducts = productService.getSimilarProductsByPrice(
                    product.get().getPrice(),
                    product.get().getProductId(),
                    missing
            );

            for (Product p : priceProducts) {
                if (similarProducts.stream().noneMatch(sp -> sp.getProductId() == p.getProductId())) {
                    similarProducts.add(p);
                }
                if (similarProducts.size() >= 4) {
                    break;
                }
            }
        }

// Nếu vẫn chưa đủ, lấy theo hãng
        if (similarProducts.size() < 4) {
            int missing = 4 - similarProducts.size();
            List<Product> brandProducts = productService.getSimilarProductsByBrand(
                    product.get().getBrand().getBrandId(),
                    product.get().getPrice(),
                    product.get().getProductId(),
                    missing
            );

            for (Product p : brandProducts) {
                if (similarProducts.stream().noneMatch(sp -> sp.getProductId() == p.getProductId())) {
                    similarProducts.add(p);
                }
                if (similarProducts.size() >= 4) {
                    break;
                }
            }
        }

        //------------------------------------------------------------------------
        request.setAttribute("product", product.get());
        request.setAttribute("productImages", productImages.get());
        request.setAttribute("infoProduct", infoProduct);

        request.setAttribute("similarProducts", similarProducts); //huy

        request.getRequestDispatcher(ProjectPaths.JSP_PRODUCTPAGE_PATH).forward(request, response);
    }
    // </editor-fold>
}
