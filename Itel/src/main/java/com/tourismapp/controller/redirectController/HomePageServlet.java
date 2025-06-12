
import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;
import com.tourismapp.model.Product;
import com.tourismapp.service.product.IProductService;
import com.tourismapp.service.product.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;


@WebServlet(name = "HomePageServlet", urlPatterns = {MainControllerServlet.HOMEPAGE_SERVLET})
public class HomePageServlet extends HttpServlet {

    private final IProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }
        switch (action) {
            case MainControllerServlet.ACTION_SEARCH_ACTIVE_PRODUCT ->
                searchActiveProduct(request, response);
            default ->
                showActiveProducts(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(ProjectPaths.JSP_HOMEPAGE_PATH).forward(request, response);
    }

    // Show active products and store them in session
    private void showActiveProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Fetch active products from service
        List<Product> activeProducts = productService.getActiveProducts();
        // Save to session
        request.getSession().setAttribute("activeProducts", activeProducts);
        // Forward the request to the homepage view
        request.getRequestDispatcher(ProjectPaths.JSP_HOMEPAGE_PATH).forward(request, response);
    }

    // Search for active products based on the query and store results in session
    private void searchActiveProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String q = request.getParameter("qProduct");
        List<Product> products;
        if (q == null || q.isEmpty()) {
            // If query is empty, fetch all active products
            products = productService.getActiveProducts();
        } else {
            // If query is provided, search for active products by name
            products = productService.searchActiveProductsByName(q);
        }
        // Save search results to session
        request.getSession().setAttribute("activeProducts", products);
        // Forward the request to the homepage view
        request.getRequestDispatcher(ProjectPaths.JSP_HOMEPAGE_PATH).forward(request, response);
    }
}
